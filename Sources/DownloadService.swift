//
//  DownloadService.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Foundation

private let timeout: NSTimeInterval = 20;

private let session: NSURLSession = {
  let config                        = NSURLSessionConfiguration.ephemeralSessionConfiguration()
  config.HTTPCookieAcceptPolicy     = .Never
  config.HTTPCookieStorage          = nil
  config.HTTPShouldSetCookies       = false
  config.requestCachePolicy         = .ReloadIgnoringLocalCacheData
  config.timeoutIntervalForRequest  = timeout
  config.timeoutIntervalForResource = timeout

  return NSURLSession(configuration: config)
}()

class DownloadService {
  typealias VersionBlock = (VersionFile?, NSError?) -> Void

  private struct Constants {
    static let errorDomain = "RetiredDownloadError"
  }

  private let url: NSURL

  init(url: NSURL) {
    self.url = url
  }

  convenience init(string: String) {
    self.init(url: NSURL(string: string)!)
  }

  func fetch(completion: VersionBlock) {
    let task = session.dataTaskWithURL(url) { data, response, error in
      guard self.foundError(error, completion: completion) == false else { return }
      guard self.foundInvalidResponse(response!, completion: completion) == false else { return }

      let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
      completion(VersionFile(json: json), nil)
    }

    task.resume()
  }

  private func foundError(error: NSError?, completion: VersionBlock) -> Bool {
    if let error = error {
      completion(nil, error)
      return true
    }

    return false
  }

  private func foundInvalidResponse(response: NSURLResponse, completion: VersionBlock) -> Bool {
    let httpResponse = response as! NSHTTPURLResponse

    if httpResponse.statusCode / 100 != 2 {
      let err = NSError(domain: Constants.errorDomain, code: httpResponse.statusCode, userInfo: nil)
      completion(nil, err)
      return true
    }

    return false
  }
}