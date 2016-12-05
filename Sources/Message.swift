//
//  Message.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

public struct Message {
  private struct Constants {
    static let titleAttribute              = "title"
    static let messageAttribute            = "message"
    static let continueButtonTextAttribute = "continueButtonText"
    static let cancelButtonTextAttribute   = "cancelButtonText"
  }

  public let title: String
  public let message: String
  public let continueButtonText: String
  public let cancelButtonText: String?

  public init(json: AnyObject) {
    title              = json[Constants.titleAttribute] as! String
    message            = json[Constants.messageAttribute] as! String
    continueButtonText = json[Constants.continueButtonTextAttribute] as! String
    cancelButtonText   = json[Constants.cancelButtonTextAttribute] as? String
  }
}
