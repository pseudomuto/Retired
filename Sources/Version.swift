//
//  Version.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

public enum VersionPolicy {
  case Force
  case Recommend
  case None

  internal static func parse(policy: String) -> VersionPolicy{
    switch policy.lowercaseString {
    case "force":
      return .Force
    case "recommend":
      return .Recommend
    default:
      return .None
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
    policy        = VersionPolicy.parse(json[Constants.policyAttribute] as! String)
  }
}