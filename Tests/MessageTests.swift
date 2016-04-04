//
//  MessageTests.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Retired
import XCTest

class MessageTests: XCTestCase {
  func testInitializerWithCancelButtonText() {
    let message = Message(json: jsonFixture("RecommendedMessage"))
    
    XCTAssertEqual("title", message.title)
    XCTAssertEqual("message", message.message)
    XCTAssertEqual("continue", message.continueButtonText)
    XCTAssertEqual("cancel", message.cancelButtonText)
  }

  func testInitializerWithoutCancelButtonText() {
    let message = Message(json: jsonFixture("ForcedMessage"))

    XCTAssertEqual("title", message.title)
    XCTAssertEqual("message", message.message)
    XCTAssertEqual("continue", message.continueButtonText)
    XCTAssertNil(message.cancelButtonText)
  }
}
