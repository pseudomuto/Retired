//
//  Version.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Foundation

public enum VersionPolicy: RawRepresentable {
  case force, recommend, none

  public typealias RawValue = String

  public var rawValue: RawValue {
    switch self {
    case .force: return "force"
    case .recommend: return "recommend"
    default: return "none"
    }
  }

  public init?(rawValue: RawValue) {
    switch rawValue.lowercased() {
    case "force": self = .force
    case "recommend": self = .recommend
    default: self = .none
    }
  }
}

public struct Version {
  private struct Constants {
    static let versionAttribute = "version"
    static let policyAttribute  = "policy"
  }

  public let versionString: String
  public let policy: VersionPolicy

  public init(json: AnyObject) {
    versionString = json[Constants.versionAttribute] as! String
    policy        = VersionPolicy(rawValue: json[Constants.policyAttribute] as! String)!
  }
}
