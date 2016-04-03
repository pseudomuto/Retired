//
//  VersionFile.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

public struct VersionFile {
  private struct Constants {
    static let messagingAttribute          = "messaging"
    static let forcedMessageAttribute      = "forced"
    static let recommendedMessageAttribute = "recommended"
    static let versionsAttribute           = "versions"
  }

  public let forcedMessage: Message
  public let recommendedMessage: Message
  public let versions: [Version]

  public init(json: AnyObject) {
    let messages       = json[Constants.messagingAttribute] as! [String: AnyObject]
    forcedMessage      = Message(json: messages[Constants.forcedMessageAttribute]!)
    recommendedMessage = Message(json: messages[Constants.recommendedMessageAttribute]!)

    let versionDefinitions = json[Constants.versionsAttribute] as! [AnyObject]
    versions = versionDefinitions.map { Version(json: $0) }
  }

  internal func findVersion(versionString: String) -> Version? {
    let strings = versions.map { $0.versionString }
    guard let index = strings.indexOf(versionString) else { return nil }

    return versions[index]
  }

  internal func messageForVersion(version: Version) -> Message? {
    switch version.policy {
    case .Force: return forcedMessage
    case .Recommend: return recommendedMessage
    default: return nil
    }
  }
}
