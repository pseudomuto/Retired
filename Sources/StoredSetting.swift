//
//  StoredSetting.swift
//  Retired
//
//  Created by David Muto on 2016-04-03.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Foundation

public struct StoredSetting<T: AnyObject> {
  private let key: String
  private let settings: UserDefaults

  public var value: T? {
    get {
      return settings.object(forKey: key) as? T
    }
    set {
      if let setting = newValue {
        settings.set(setting, forKey: key)
      } else {
        settings.removeObject(forKey: key)
      }

      settings.synchronize()
    }
  }

  public init(name: String, container: UserDefaults = UserDefaults.standard) {
    key = name
    settings = container
  }

  public func clear() {
    settings.removeObject(forKey: key)
    settings.synchronize()
  }
}
