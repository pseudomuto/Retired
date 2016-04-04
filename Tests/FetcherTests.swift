//
//  FetcherTests.swift
//  Retired
//
//  Created by David Muto on 2016-04-04.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Nocilla
@testable import Retired
import XCTest

class FetcherTests: XCTestCase {
  let versionURL = "https://example.com/versions.json"
  let bundle = NSBundle(forClass: RetiredTests.self)

  var fetcher: Fetcher?

  override func setUp() {
    LSNocilla.sharedInstance().start()
    fetcher = Fetcher(NSURL(string: versionURL)!, bundle: bundle)
  }

  override func tearDown() {
    LSNocilla.sharedInstance().stop()
  }

  func test_Check_When_Forced_Update_Required() {
    stubVersionsWith("Versions")

    assertResult { shouldUpdate, message, error in
      XCTAssertTrue(shouldUpdate)
      XCTAssertNotNil(message)
      XCTAssertNil(error)

      XCTAssertEqual("A new version of the app is available. You need to update now", message!.message)
    }
  }

  func test_Check_When_Update_Recommended() {
    stubVersionsWith("VersionsRecommendUpdate")

    assertResult { shouldUpdate, message, error in
      XCTAssertTrue(shouldUpdate)
      XCTAssertNotNil(message)
      XCTAssertNil(error)

      XCTAssertEqual("A new version is available. Want it?", message!.message)
    }
  }

  func test_Check_When_Current_Version_Not_Found() {
    stubVersionsWith("VersionsWithoutCurrent")

    assertResult { shouldUpdate, message, error in
      XCTAssertFalse(shouldUpdate)
      XCTAssertNil(message)
      XCTAssertNotNil(error)

      XCTAssertEqual(RetiredErrorDomain, error!.domain)
    }
  }

  func test_Check_When_Error_Occurs() {
    stubRequest("GET", versionURL).andFailWithError(NSError(domain: "err", code: 1, userInfo: nil))

    assertResult { shouldUpdate, message, error in
      XCTAssertFalse(shouldUpdate)
      XCTAssertNil(message)
      XCTAssertNotNil(error)
    }
  }

  private func assertResult(completion: (Bool, Message?, NSError?) -> Void) {
    let expectation = expectationWithDescription("Check")

    fetcher!.check() { shouldUpdate, message, error in
      completion(shouldUpdate, message, error)
      expectation.fulfill()
    }

    waitForExpectationsWithTimeout(0.5, handler: nil)
  }

  private func stubVersionsWith(name: String) {
    stubRequest("GET", versionURL)
      .andReturn(200)
      .withBody(String(data: fixtureData(name), encoding: NSUTF8StringEncoding))
  }
}