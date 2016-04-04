//
//  Retired.swift
//  Retired
//
//  Created by David Muto on 2016-03-30.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

public typealias RetiredCompletion = (Bool, Message?, NSError?) -> Void

public let RetiredErrorDomain = "RetiredError"

public enum RetiredError: ErrorType {
  case NotConfigured
}

public class Retired {
  static var fetcher: FileFetcher?
  static var suppressionInterval: NSTimeInterval = 0
  static var nextRequestDate = StoredSetting<NSDate>(name: "nextRequestDate")

  public static func configure(
    url: NSURL,
    suppressionInterval: NSTimeInterval = 0,
    bundle: NSBundle = NSBundle.mainBundle()) {
      self.suppressionInterval = suppressionInterval
      self.fetcher             = Fetcher(url: url, bundle: bundle)
  }

  public static func check(completion: RetiredCompletion) throws {
    guard let fetcher = fetcher else { throw RetiredError.NotConfigured }

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

  public static func clearSuppressionInterval() {
    nextRequestDate.value = nil
  }

  private static func suppressionWindowLapsed() -> Bool {
    if let suppressionDate = nextRequestDate.value {
      return suppressionDate.compare(NSDate()) != .OrderedDescending
    }

    return true
  }
}
