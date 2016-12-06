//
//  Helpers.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Foundation
import XCTest

func fixtureData(_ name: String) -> Data {
  let bundle = Bundle(for: MessageTests.self)
  let path   = bundle.path(forResource: name, ofType: "json")!

  return (try! Data(contentsOf: URL(fileURLWithPath: path)))
}

func jsonFixture(_ name: String) -> AnyObject {
  let data = fixtureData(name)
  return try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
}

func XCTAssertThrows<T: Error>(_ error: T, expression: () throws -> Void) {
  do {
    try expression()
  }
  catch let err as T {
    XCTAssertNotNil(err)
  }
  catch let err {
    XCTFail("Expected \(T.self), but got \(type(of: err))")
  }
}
