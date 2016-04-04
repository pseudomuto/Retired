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
  static var nextRequestDate = StoredSetting<NSDate>("nextRequestDate")

  public static func configure(url: NSURL, bundle: NSBundle = NSBundle.mainBundle()) {
    fetcher = Fetcher(url, bundle: bundle)
  }

  public static func check(completion: RetiredCompletion) throws {
    guard shouldPerformCheck() else { return }
    guard let fetcher = fetcher else { throw RetiredError.NotConfigured }

    nextRequestDate.clear()
    fetcher.check(completion)
  }

  public static func suppressUntil(date: NSDate) {
    nextRequestDate.value = date
  }

  private static func shouldPerformCheck() -> Bool {
    if let suppressionDate = nextRequestDate.value {
      return suppressionDate.compare(NSDate()) != .OrderedDescending
    }

    return true
  }
}
