//
//  VersionTests.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Retired
import XCTest

private func createVersionJSON(version: String, policy: String) -> AnyObject {
  let json = "{ \"version\": \"\(version)\", \"policy\": \"\(policy)\" }"
  return try! createJSONObject(json)
}

private func createJSONObject(json: String) throws -> AnyObject {
  let data = json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
  return try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
}

class VersionTests: XCTestCase {
  func test_Initializer_Parses_Version() {
    let json    = createVersionJSON("1.0.1", policy: "none")
    let version = Version(json: json)

    XCTAssertEqual("1.0.1", version.versionString)
  }

  func test_Initializer_Parses_Policy_Correctly() {
    let expectations = [
      "force": VersionPolicy.Force,
      "recommend": VersionPolicy.Recommend,
      "REcommend": VersionPolicy.Recommend,
      "none": VersionPolicy.None,
      "other": VersionPolicy.None
    ]

    for (key, value) in expectations {
      let json    = createVersionJSON("1.0.1", policy: key)
      let version = Version(json: json)

      XCTAssertEqual(value, version.policy)
    }
  }
}
