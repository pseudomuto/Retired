//
//  Retired.swift
//  Retired
//
//  Created by David Muto on 2016-03-30.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

public typealias RetiredCompletion = (Bool, Message?, NSError?) -> Void

public class Retired {
  internal static let errorDomain       = "RetiredError"
  internal static let errorCodeNotFound = 1

  public static func check(url: NSURL, bundle: NSBundle = NSBundle.mainBundle(), completion: RetiredCompletion) {
    let service = DownloadService(url: url)

    service.fetch() { versionFile, error in
      guard error == nil else {
        handleError(error!, completion: completion)
        return
      }

      let file    = versionFile!
      let version = bundle.objectForInfoDictionaryKey("CFBundleShortVersionString") as! String

      guard let definition = file.findVersion(version) else {
        handleError(versionNotFoundError(), completion: completion)
        return
      }

      let message = file.messageForVersion(definition)
      completion(message != nil, message, nil)
    }
  }

  private static func handleError(error: NSError, completion: RetiredCompletion) {
    completion(false, nil, error)
  }

  private static func versionNotFoundError() -> NSError {
    return NSError(domain: errorDomain, code: errorCodeNotFound, userInfo: nil)
  }
}
