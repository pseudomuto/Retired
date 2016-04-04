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

  func testInitializerParsesForcedMessage() {
    XCTAssertNotNil(file.forcedMessage)
  }

  func testInitializerParsesRecommendedMessage() {
    XCTAssertNotNil(file.recommendedMessage)
  }

  func testInitializerParsesVersions() {
    XCTAssertGreaterThan(file.versions.count, 0)

    for version in file.versions {
      XCTAssertNotNil(version)
    }
  }
}
