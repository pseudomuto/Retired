//
//  Retired.swift
//  Retired
//
//  Created by David Muto on 2016-03-30.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Foundation

public struct Retired {
  static let timeout: NSTimeInterval  = 20;
 
  static var sessionConfig: NSURLSessionConfiguration = {
    let session                        = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    session.HTTPCookieAcceptPolicy     = .Never
    session.HTTPCookieStorage          = nil
    session.HTTPShouldSetCookies       = false
    session.timeoutIntervalForRequest  = timeout
    session.timeoutIntervalForResource = timeout

    return session
  }()
}