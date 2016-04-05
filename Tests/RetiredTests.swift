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

  lazy var future = NSDate(timeIntervalSinceNow: 50)
  lazy var past   = NSDate(timeIntervalSinceNow: -1)

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

  func testCheckCallsTheFetcher() {
    try! Retired.check() { _, _, _ in }
    XCTAssertTrue(fetcher.called)
  }

  func testCheckWhenUpdateRecommendedSetsNextRequestDate() {
    XCTAssertNil(Retired.nextRequestDate.value)

    try! Retired.check() { _, _, _ in }
    XCTAssertTrue(fetcher.called)
    XCTAssertNotNil(Retired.nextRequestDate.value)
  }

  func testCheckWhenForcedUpdateSupressionIntervalIsCleared() {
    fetcher                       = TestFetcher(forcedUpdate: true)
    Retired.fetcher               = fetcher
    Retired.nextRequestDate.value = future

    try! Retired.check() { _, _, _ in }
    XCTAssertTrue(fetcher.called)
    XCTAssertNil(Retired.nextRequestDate.value)
  }

  func testCheckWhenSuppressedDoesNotCallCompletionBlock() {
    Retired.nextRequestDate.value = future

    var called = false
    try! Retired.check() { _, _, _ in
      called = true
    }

    XCTAssertTrue(fetcher.called)
    XCTAssertFalse(called)
  }

  func testCheckWhenSuppressedDoesNotUpdateSuppressionInterval() {
    Retired.nextRequestDate.value = future

    try! Retired.check() { _, _, _ in }
    XCTAssertTrue(fetcher.called)
    XCTAssertEqual(future, Retired.nextRequestDate.value)
  }

  func testCheckWhenIntervalLapsedCallsFetcher() {
    Retired.nextRequestDate.value = past

    try! Retired.check() { _, _, _ in }
    XCTAssertTrue(fetcher.called)
  }

  class TestFetcher: FileFetcher {
    private(set) var called = false

    private let forced: Bool

    init(forcedUpdate: Bool = false) {
      forced = forcedUpdate
    }

    func check(completion: RetiredCompletion) {
      called = true
      completion(forced, nil, nil)
    }
  }
}
