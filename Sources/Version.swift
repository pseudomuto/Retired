//
//  Version.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

public enum VersionPolicy: RawRepresentable {
  case Force, Recommend, None

  public typealias RawValue = String

  public var rawValue: RawValue {
    switch self {
    case .Force: return "force"
    case .Recommend: return "recommend"
    default: return "none"
    }
  }

  public init?(rawValue: RawValue) {
    switch rawValue.lowercaseString {
    case "force": self = .Force
    case "recommend": self = .Recommend
    default: self = .None
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
