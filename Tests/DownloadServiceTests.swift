//
//  DownloadServiceTests.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Nocilla
import XCTest

@testable import Retired

private let VersionFileURL = "https://example.com/versions.json"

class DownloadServiceTests: XCTestCase {
  let service = DownloadService(string: VersionFileURL)

  override func setUp() {
    LSNocilla.sharedInstance().start()
  }

  override func tearDown() {
    LSNocilla.sharedInstance().stop()
  }

  func testFetchWhenResponseIsValid() {
    stubRequest("GET", VersionFileURL)
      .andReturn(200)
      .withBody(String(data: fixtureData("Versions"), encoding: NSUTF8StringEncoding))

    validateRequest() { version, error in
      XCTAssertNil(error)
      XCTAssertNotNil(version)
    }
  }

  func testFetchWhenRequestReturnsNon200Status() {
    stubRequest("GET", VersionFileURL).andReturn(500)

    validateRequest() { version, error in
      XCTAssertNotNil(error)
      XCTAssertNil(version)
    }
  }

  func testFetchWhenRequestErrorsOut() {
    stubRequest("GET", VersionFileURL).andFailWithError(NSError(domain: "SomeDomain", code: 1, userInfo: nil))

    validateRequest() { version, error in
      XCTAssertNotNil(error)
      XCTAssertNil(version)
    }
  }

  private func validateRequest(block: (VersionFile?, NSError?) -> Void) {
    let expectation = expectationWithDescription("Download")

    service.fetch() { version, error in
      block(version, error)
      expectation.fulfill()
    }

    waitForExpectationsWithTimeout(0.5, handler: nil)
  }
}
