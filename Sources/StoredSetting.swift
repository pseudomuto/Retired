//
//  StoredSetting.swift
//  Retired
//
//  Created by David Muto on 2016-04-03.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

public struct StoredSetting<T: AnyObject> {
  private let key: String
  private let settings: NSUserDefaults

  public var value: T? {
    get {
      return settings.objectForKey(key) as? T
    }
    set {
      if let setting = newValue {
        settings.setObject(setting, forKey: key)
      } else {
        settings.removeObjectForKey(key)
      }

      settings.synchronize()
    }
  }

  public init(name: String, container: NSUserDefaults = NSUserDefaults.standardUserDefaults()) {
    key      = name
    settings = container
  }

  public func clear() {
    settings.removeObjectForKey(key)
    settings.synchronize()
  }
}
