//
//  DownloadServiceTests.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import OHHTTPStubs
import XCTest

@testable import Retired

private let VersionFileURL = "https://example.com/versions.json"

class DownloadServiceTests: XCTestCase {
  let service = DownloadService(string: VersionFileURL)

  override func tearDown() {
    OHHTTPStubs.removeAllStubs()
    super.tearDown()
  }

  func testFetchWhenResponseIsValid() {
    stub(condition: isHost("example.com")) { _ in
      return OHHTTPStubsResponse(
        data: fixtureData("Versions"),
        statusCode: 200,
        headers: nil
      )
    }
    validateRequest() { version, error in
      XCTAssertNil(error)
      XCTAssertNotNil(version)
    }
  }

  func testFetchWhenRequestReturnsNon200Status() {
    stub(condition: isHost(VersionFileURL)) { _ in
      return OHHTTPStubsResponse(data: Data(), statusCode: 500, headers: nil)
    }

    validateRequest() { version, error in
      XCTAssertNotNil(error)
      XCTAssertNil(version)
    }
  }

  func testFetchWhenRequestErrorsOut() {
    stub(condition: isHost(VersionFileURL)) { _ in
      return OHHTTPStubsResponse(data: Data(), statusCode: 500, headers: nil)
    }
    validateRequest() { version, error in
      XCTAssertNotNil(error)
      XCTAssertNil(version)
    }
  }

  fileprivate func validateRequest(_ block: @escaping (VersionFile?, NSError?) -> Void) {
    let expectation = self.expectation(description: "Download")

    service.fetch() { version, error in
      block(version, error)
      expectation.fulfill()
    }

    waitForExpectations(timeout: 0.5, handler: nil)
  }
}
