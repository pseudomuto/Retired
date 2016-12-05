//
//  DownloadService.swift
//  Retired
//
//  Created by David Muto on 2016-03-31.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Foundation

private let timeout: TimeInterval = 20;

private let session: URLSession = {
  let config                        = URLSessionConfiguration.ephemeral
  config.httpCookieAcceptPolicy     = .never
  config.httpCookieStorage          = nil
  config.httpShouldSetCookies       = false
  config.requestCachePolicy         = .reloadIgnoringLocalCacheData
  config.timeoutIntervalForRequest  = timeout
  config.timeoutIntervalForResource = timeout

  return URLSession(configuration: config)
}()

class DownloadService {
  typealias VersionBlock = (VersionFile?, NSError?) -> Void

  private struct Constants {
    static let errorDomain = "RetiredDownloadError"
  }

  private let url: URL

  init(url: URL) {
    self.url = url
  }

  convenience init(string: String) {
    self.init(url: URL(string: string)!)
  }

  func fetch(_ completion: @escaping VersionBlock) {
    let task = session.dataTask(with: url, completionHandler: { data, response, error in
      guard self.foundError(error as NSError?, completion: completion) == false else { return }
      guard self.foundInvalidResponse(response!, completion: completion) == false else { return }

      let json = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
      completion(VersionFile(json: json as AnyObject), nil)
    }) 

    task.resume()
  }

  private func foundError(_ error: NSError?, completion: VersionBlock) -> Bool {
    if let error = error {
      completion(nil, error)
      return true
    }

    return false
  }

  private func foundInvalidResponse(_ response: URLResponse, completion: VersionBlock) -> Bool {
    let httpResponse = response as! HTTPURLResponse

    if httpResponse.statusCode / 100 != 2 {
      let err = NSError(domain: Constants.errorDomain, code: httpResponse.statusCode, userInfo: nil)
      completion(nil, err)
      return true
    }

    return false
  }
}
