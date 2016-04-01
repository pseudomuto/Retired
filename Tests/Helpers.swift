//
//  Helpers.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Foundation

func fixtureData(name: String) -> NSData {
  let bundle = NSBundle(forClass: MessageTests.self)
  let path   = bundle.pathForResource(name, ofType: "json")!

  return NSData(contentsOfFile: path)!
}

func jsonFixture(name: String) -> AnyObject {
  let data = fixtureData(name)
  return try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
}
