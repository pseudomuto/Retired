//
//  VersionTests.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Retired
import XCTest

private func createVersionJSON(_ version: String, policy: String) -> AnyObject {
  let json = "{ \"version\": \"\(version)\", \"policy\": \"\(policy)\" }"
  return try! createJSONObject(json) as AnyObject
}

private func createJSONObject(_ json: String) throws -> Any {
  let data = json.data(using: String.Encoding.utf8, allowLossyConversion: false)!
  return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
}

class VersionTests: XCTestCase {
  func testInitializerParsesVersion() {
    let json    = createVersionJSON("1.0.1", policy: "none")
    let version = Version(json: json)

    XCTAssertEqual("1.0.1", version.versionString)
  }

  func testInitializerParsesPolicyCorrectly() {
    let expectations = [
      "force": VersionPolicy.force,
      "recommend": VersionPolicy.recommend,
      "REcommend": VersionPolicy.recommend,
      "none": VersionPolicy.none,
      "other": VersionPolicy.none
    ]

    for (key, value) in expectations {
      let json    = createVersionJSON("1.0.1", policy: key)
      let version = Version(json: json)

      XCTAssertEqual(value, version.policy)
    }
  }
}
