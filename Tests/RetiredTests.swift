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

  func testCheckWhenFetcherCalledSetsNextRequestDate() {
    XCTAssertNil(Retired.nextRequestDate.value)

    try! Retired.check() { _, _, _ in }
    XCTAssertTrue(fetcher.called)
    XCTAssertNotNil(Retired.nextRequestDate.value)
  }

  func testCheckWhenFetcherReturnedForcedUpdateClearsSupressionInterval() {
    fetcher                       = TestFetcher(forcedUpdate: true)
    Retired.fetcher               = fetcher

    try! Retired.check() { _, _, _ in }
    XCTAssertTrue(fetcher.called)
    XCTAssertNil(Retired.nextRequestDate.value)
  }

  func testCheckWhenSupressedSkipsTheCall() {
    Retired.nextRequestDate.value = NSDate(timeIntervalSinceNow: 5000)

    try! Retired.check() { _, _, _ in }
    XCTAssertFalse(fetcher.called)
  }

  func testCheckWhenIntervalLapsedCallsFetcher() {
    Retired.nextRequestDate.value = NSDate(timeIntervalSinceNow: -1)

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
