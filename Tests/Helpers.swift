//
//  Helpers.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Foundation
import XCTest

func fixtureData(name: String) -> NSData {
  let bundle = NSBundle(forClass: MessageTests.self)
  let path   = bundle.pathForResource(name, ofType: "json")!

  return NSData(contentsOfFile: path)!
}

func jsonFixture(name: String) -> AnyObject {
  let data = fixtureData(name)
  return try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
}

func XCTAssertThrows<T: ErrorType>(error: T, expression: () throws -> Void) {
  do {
    try expression()
  }
  catch let err as T {
    XCTAssertNotNil(err)
  }
  catch let err {
    XCTFail("Expected \(T.self), but got \(err.dynamicType)")
  }
}
