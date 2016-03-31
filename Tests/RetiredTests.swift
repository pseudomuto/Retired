//
//  RetiredTests.swift
//  Retired
//
//  Created by David Muto on 2016-03-30.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import XCTest
@testable import Retired

class RetiredTests: XCTestCase {
  func test_NSURLSessionConfiguration_Properties() {
    let config = Retired.sessionConfig

    XCTAssertEqual(NSHTTPCookieAcceptPolicy.Never, config.HTTPCookieAcceptPolicy)
    XCTAssertNil(config.HTTPCookieStorage)
    XCTAssertFalse(config.HTTPShouldSetCookies)
    XCTAssertEqual(Retired.timeout, config.timeoutIntervalForRequest)
    XCTAssertEqual(Retired.timeout, config.timeoutIntervalForResource)
  }
}
