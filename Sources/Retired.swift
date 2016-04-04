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
    guard shouldPerformCheck() else { return }
    guard let fetcher = fetcher else { throw RetiredError.NotConfigured }

    nextRequestDate.value = NSDate(timeIntervalSinceNow: suppressionInterval)
    fetcher.check(completion)
  }

  public static func clearSuppressionInterval() {
    nextRequestDate.value = nil
  }

  private static func shouldPerformCheck() -> Bool {
    if let suppressionDate = nextRequestDate.value {
      return suppressionDate.compare(NSDate()) != .OrderedDescending
    }

    return true
  }
}
