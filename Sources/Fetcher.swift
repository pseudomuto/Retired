//
//  Fetcher.swift
//  Retired
//
//  Created by David Muto on 2016-04-04.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Foundation

public protocol FileFetcher {
  func check(_ completion: @escaping RetiredCompletion)
}

class Fetcher: FileFetcher {
  let url: URL
  let bundle: Bundle

  init(url: URL, bundle: Bundle) {
    self.url    = url
    self.bundle = bundle
  }

  public func check(_ completion: @escaping RetiredCompletion) {
    let service = DownloadService(url: url)

    service.fetch() { versionFile, error in
      guard error == nil else {
        completion(false, nil, error!)
        return
      }

      let file = versionFile!

      guard let definition = file.findVersion(self.currentVersion()) else {
        completion(false, nil, NSError(domain: RetiredErrorDomain, code: 1, userInfo: nil))
        return
      }

      let message = file.messageForVersion(definition)
      completion(definition.policy == .force, message, nil)
    }
  }

  private func currentVersion() -> String {
    return bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
  }
}
