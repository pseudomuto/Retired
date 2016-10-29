//
//  FetcherTests.swift
//  Retired
//
//  Created by David Muto on 2016-04-04.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

//import Nocilla
@testable import Retired
import XCTest

class FetcherTests: XCTestCase {
//  let versionURL = "https://example.com/versions.json"
//  let bundle = Bundle(for: RetiredTests.self)
//
//  var fetcher: Fetcher?
//
//  override func setUp() {
//    LSNocilla.sharedInstance().start()
//    fetcher = Fetcher(url: URL(string: versionURL)!, bundle: bundle)
//  }
//
//  override func tearDown() {
//    LSNocilla.sharedInstance().stop()
//  }
//
//  func testCheckWhenForcedUpdateRequired() {
//    stubVersionsWith("Versions")
//
//    assertResult { forcedUpdate, message, error in
//      XCTAssertTrue(forcedUpdate)
//      XCTAssertNotNil(message)
//      XCTAssertNil(error)
//
//      XCTAssertEqual("A new version of the app is available. You need to update now", message!.message)
//    }
//  }
//
//  func testCheckWhenUpdateRecommended() {
//    stubVersionsWith("VersionsRecommendUpdate")
//
//    assertResult { forcedUpdate, message, error in
//      XCTAssertFalse(forcedUpdate)
//      XCTAssertNotNil(message)
//      XCTAssertNil(error)
//
//      XCTAssertEqual("A new version is available. Want it?", message!.message)
//    }
//  }
//
//  func testCheckWhenCurrentVersionNotFound() {
//    stubVersionsWith("VersionsWithoutCurrent")
//
//    assertResult { forcedUpdate, message, error in
//      XCTAssertFalse(forcedUpdate)
//      XCTAssertNil(message)
//      XCTAssertNotNil(error)
//
//      XCTAssertEqual(RetiredErrorDomain, error!.domain)
//    }
//  }
//
//  func testCheckWhenErrorOccurs() {
//    stubRequest("GET", versionURL as LSMatcheable!).andFailWithError(NSError(domain: "err", code: 1, userInfo: nil))
//
//    assertResult { forcedUpdate, message, error in
//      XCTAssertFalse(forcedUpdate)
//      XCTAssertNil(message)
//      XCTAssertNotNil(error)
//    }
//  }
//
//  fileprivate func assertResult(_ completion: @escaping (Bool, Message?, NSError?) -> Void) {
//    let expectation = self.expectation(description: "Check")
//
//    fetcher!.check() { forcedUpdate, message, error in
//      completion(forcedUpdate, message, error)
//      expectation.fulfill()
//    }
//
//    waitForExpectations(timeout: 0.5, handler: nil)
//  }
//
//  fileprivate func stubVersionsWith(_ name: String) {
//    stubRequest("GET", versionURL as LSMatcheable!)
//      .andReturn(200)
//      .withBody(String(data: fixtureData(name), encoding: String.Encoding.utf8))
//  }
}
