//
//  FetcherTests.swift
//  Retired
//
//  Created by David Muto on 2016-04-04.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import OHHTTPStubs
import OHHTTPStubsSwift
@testable import Retired
import XCTest

class FetcherTests: XCTestCase {
  let versionURL = "https:example.com/versions.json"
  let bundle = Bundle(for: RetiredTests.self)

  var fetcher: Fetcher?

  override func setUp() {
    fetcher = Fetcher(url: URL(string: versionURL)!, bundle: bundle)
  }

  override func tearDown() {
    HTTPStubs.removeAllStubs()
    super.tearDown()
  }

  func testCheckWhenForcedUpdateRequired() {
    stubVersionsWith("Versions")

    assertResult { forcedUpdate, message, error in
      XCTAssertTrue(forcedUpdate)
      XCTAssertNotNil(message)
      XCTAssertNil(error)

      XCTAssertEqual("A new version of the app is available. You need to update now", message!.message)
    }
  }

  func testCheckWhenUpdateRecommended() {
    stubVersionsWith("VersionsRecommendUpdate")

    assertResult { forcedUpdate, message, error in
      XCTAssertFalse(forcedUpdate)
      XCTAssertNotNil(message)
      XCTAssertNil(error)

      XCTAssertEqual("A new version is available. Want it?", message!.message)
    }
  }

  func testCheckWhenCurrentVersionNotFound() {
    stubVersionsWith("VersionsWithoutCurrent")

    assertResult { forcedUpdate, message, error in
      XCTAssertFalse(forcedUpdate)
      XCTAssertNil(message)
      XCTAssertNotNil(error)

      XCTAssertEqual(RetiredErrorDomain, error!.domain)
    }
  }

  func testCheckWhenErrorOccurs() {
    stub(condition: { request in return request.url!.absoluteString ==  self.versionURL }) { _ in
      return HTTPStubsResponse(error: NSError(domain: "err", code: 1, userInfo: nil))
    }

    assertResult { forcedUpdate, message, error in
      XCTAssertFalse(forcedUpdate)
      XCTAssertNil(message)
      XCTAssertNotNil(error)
    }
  }

  private func assertResult(_ completion: @escaping (Bool, Message?, NSError?) -> Void) {
    let expectation = self.expectation(description: "Check")

    fetcher!.check() { forcedUpdate, message, error in
      completion(forcedUpdate, message, error)
      expectation.fulfill()
    }

    waitForExpectations(timeout: 0.5, handler: nil)
  }

  private func stubVersionsWith(_ name: String) {
    stub(condition: { request in return request.url!.absoluteString ==  self.versionURL }) { _ in
      return HTTPStubsResponse(
        data: fixtureData(name),
        statusCode: 200,
        headers: nil
      )
    }
  }
}
