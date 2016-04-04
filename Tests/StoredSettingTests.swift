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
  let settingsContainer = NSUserDefaults()

  lazy var storedProp: StoredSetting<NSString> = {
    return StoredSetting(name: self.settingKey, container: self.settingsContainer)
  }()

  override func tearDown() {
    super.tearDown()

    settingsContainer.removeObjectForKey(settingKey)
    settingsContainer.synchronize()
  }

  func test_Get_Value_Pulls_From_Container() {
    settingsContainer.setObject("My Value", forKey: settingKey)
    XCTAssertEqual("My Value", storedProp.value)
  }

  func test_Get_Value_When_Nil_Returns_Nil() {
    XCTAssertNil(storedProp.value)
  }

  func test_Set_Value_Stores_Value_In_Container() {
    storedProp.value = "value"
    XCTAssertEqual("value", settingsContainer.stringForKey(settingKey))
  }

  func test_Set_Value_To_Nil_Removes_Object_From_Container() {
    storedProp.value = "value"
    XCTAssertTrue(settingsContainer.dictionaryRepresentation().keys.contains(settingKey))

    storedProp.value = nil
    XCTAssertFalse(settingsContainer.dictionaryRepresentation().keys.contains(settingKey))
  }

  func test_Clear_Removes_Object_From_Container() {
    storedProp.value = "value"
    storedProp.clear()

    XCTAssertFalse(settingsContainer.dictionaryRepresentation().keys.contains(settingKey))
  }
}
