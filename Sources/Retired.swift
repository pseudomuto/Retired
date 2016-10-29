//
//  Retired.swift
//  Retired
//
//  Created by David Muto on 2016-03-30.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

public typealias RetiredCompletion = (Bool, Message?, NSError?) -> Void

public let RetiredErrorDomain = "RetiredError"

public enum RetiredError: Error {
  case notConfigured
}

open class Retired {
  static var fetcher: FileFetcher?
  static var suppressionInterval: TimeInterval = 0
  static var nextRequestDate = StoredSetting<NSDate>(name: "nextRequestDate")

  open static func configure(
    _ url: URL,
    suppressionInterval: TimeInterval = 0,
    bundle: Bundle = Bundle.main) {
      self.suppressionInterval = suppressionInterval
      self.fetcher             = Fetcher(url: url, bundle: bundle)
  }

  open static func check(_ completion: @escaping RetiredCompletion) throws {
    guard let fetcher = fetcher else { throw RetiredError.notConfigured }

    fetcher.check() { forcedUpdate, message, error in
      guard error == nil else {
        completion(false, nil, error)
        return
      }

      // skip the completion block unless it's a forced update or the suppression interval has lapsed
      guard forcedUpdate || suppressionWindowLapsed() else { return }

      if forcedUpdate {
        nextRequestDate.clear()
      } else {
        nextRequestDate.value = NSDate(timeIntervalSinceNow: suppressionInterval)
      }

      completion(true, message, nil)
    }
  }

  open static func clearSuppressionInterval() {
    nextRequestDate.value = nil
  }

  fileprivate static func suppressionWindowLapsed() -> Bool {
    if let suppressionDate = nextRequestDate.value {
      return suppressionDate.compare(Date()) != .orderedDescending
    }

    return true
  }
}
