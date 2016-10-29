//
//  StoredSettingTests.swift
//  Retired
//
//  Created by David Muto on 2016-04-03.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Retired
import XCTest

class StoredSettingTests: XCTestCase {
  let settingKey        = "mySetting"
  let settingsContainer = UserDefaults()

  lazy var storedProp: StoredSetting<NSString> = {
    return StoredSetting(name: self.settingKey, container: self.settingsContainer)
  }()

  override func tearDown() {
    super.tearDown()

    settingsContainer.removeObject(forKey: settingKey)
    settingsContainer.synchronize()
  }

  func testGetValuePullsFromContainer() {
    settingsContainer.set("My Value", forKey: settingKey)
    XCTAssertEqual("My Value", storedProp.value)
  }

  func testGetValueWhenNilReturnsNil() {
    XCTAssertNil(storedProp.value)
  }

  func testSetValueStoresValueInContainer() {
    storedProp.value = "value"
    XCTAssertEqual("value", settingsContainer.string(forKey: settingKey))
  }

  func testSetValueToNilRemovesObjectFromContainer() {
    storedProp.value = "value"
    XCTAssertTrue(settingsContainer.dictionaryRepresentation().keys.contains(settingKey))

    storedProp.value = nil
    XCTAssertFalse(settingsContainer.dictionaryRepresentation().keys.contains(settingKey))
  }

  func testClearRemovesObjectFromContainer() {
    storedProp.value = "value"
    storedProp.clear()

    XCTAssertFalse(settingsContainer.dictionaryRepresentation().keys.contains(settingKey))
  }
}
