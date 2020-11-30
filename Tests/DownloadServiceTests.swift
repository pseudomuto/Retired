//
//  DownloadServiceTests.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

@testable import Retired

private let VersionFileURL = "https://example.com/versions.json"

class DownloadServiceTests: XCTestCase {
  let service = DownloadService(string: VersionFileURL)

  override func tearDown() {
    HTTPStubs.removeAllStubs()
    super.tearDown()
  }

  func testFetchWhenResponseIsValid() {
    stub(condition: stubCondition) { _ in
      return HTTPStubsResponse(
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
    stub(condition: stubCondition) { _ in
      return HTTPStubsResponse(data: Data(), statusCode: 500, headers: nil)
    }

    validateRequest() { version, error in
      XCTAssertNotNil(error)
      XCTAssertNil(version)
    }
  }

  func testFetchWhenRequestErrorsOut() {
    stub(condition: stubCondition) { _ in
      return HTTPStubsResponse(data: Data(), statusCode: 500, headers: nil)
    }
    validateRequest() { version, error in
      XCTAssertNotNil(error)
      XCTAssertNil(version)
    }
  }

  private func validateRequest(_ block: @escaping (VersionFile?, NSError?) -> Void) {
    let expectation = self.expectation(description: "Download")

    service.fetch() { version, error in
      block(version, error)
      expectation.fulfill()
    }

    waitForExpectations(timeout: 0.5, handler: nil)
  }

  private var stubCondition: HTTPStubsTestBlock {
    { request in return request.url!.absoluteString == VersionFileURL }
  }
}
