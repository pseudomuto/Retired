//
//  Retired.swift
//  Retired
//
//  Created by David Muto on 2016-03-30.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

public class Retired {
  static var bundle            = NSBundle.mainBundle()
  static let errorDomain       = "RetiredError"
  static let errorCodeNotFound = 1

  public static func check(url: NSURL, completion: (Bool, Message?, NSError?) -> Void) {
    let service = DownloadService(url: url)

    service.fetch() { versionFile, error in
      guard error == nil else {
        completion(false, nil, error!)
        return
      }

      let file     = versionFile!
      let version  = bundle.objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
      let versions = file.versions.map { $0.versionString }

      guard let index = versions.indexOf(version) else {
        completion(false, nil, NSError(domain: errorDomain, code: errorCodeNotFound, userInfo: nil))
        return
      }

      switch file.versions[index].policy {
      case .Force:
        completion(true, file.forcedMessage, nil)
      case .Recommend:
        completion(true, file.recommendedMessage, nil)
      case .None:
        completion(false, nil, nil)
      }
    }
  }
}
