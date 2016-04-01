//
//  VersionFileTests.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Retired
import XCTest

class VersionFileTests: XCTestCase {
  let file = VersionFile(json: jsonFixture("Versions"))

  func test_Initializer_Parses_Forced_Message() {
    XCTAssertNotNil(file.forcedMessage)
  }

  func test_Initializer_Parses_Recommended_Message() {
    XCTAssertNotNil(file.recommendedMessage)
  }

  func test_Initializer_Parses_Versions() {
    XCTAssertGreaterThan(file.versions.count, 0)

    for version in file.versions {
      XCTAssertNotNil(version)
    }
  }
}
