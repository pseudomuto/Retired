//
//  RetiredTests.swift
//  Retired
//
//  Created by David Muto on 2016-03-30.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

@testable import Retired
import XCTest

class RetiredTests: XCTestCase {
  var fetcher = TestFetcher()

  override func setUp() {
    Retired.fetcher = fetcher
  }

  override func tearDown() {
    Retired.nextRequestDate.clear()
  }

  func testCheckWhenNotConfigured() {
    Retired.fetcher = nil

    XCTAssertThrows(RetiredError.NotConfigured) {
      try Retired.check() { _, _, _ in }
    }
  }

  func testCheckWhenNotSupressedCallsTheFetcher() {
    try! Retired.check() { _, _, _ in }
    XCTAssertTrue(fetcher.called)
  }

  func testCheckWhenSupressedSkipsTheCall() {
    Retired.suppressUntil(NSDate(timeIntervalSinceNow: 5000))

    try! Retired.check() { _, _, _ in }
    XCTAssertFalse(fetcher.called)
  }

  class TestFetcher: FileFetcher {
    private(set) var called = false

    func check(completion: RetiredCompletion) {
      called = true
    }
  }
}
