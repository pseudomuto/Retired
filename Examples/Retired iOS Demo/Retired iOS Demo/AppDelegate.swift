//
//  AppDelegate.swift
//  Retired iOS Demo
//
//  Created by David Muto on 2016-04-01.
//  Copyright © 2016 pseudomuto. All rights reserved.
//

import Retired
import UIKit

// GET LINK FROM: https://linkmaker.itunes.apple.com/
let iTunesURL  = NSURL(string: "itms-apps://geo.itunes.apple.com/us/app/popup-amazing-products-gift/id1057634612?mt=8")!
let versionURL = NSURL(string: "http://localhost:8000/Versions.json")!

let intervalBetweenRequests: NSTimeInterval = 60 * 60 * 24 // wait a day between requests (i.e. don't pester the user)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Retired.configure(versionURL)
    return true
  }

  func applicationDidBecomeActive(application: UIApplication) {
    try! Retired.check() { updateRequired, message, error in
      guard updateRequired else { return }

      // handle error (non 200 status or network issue)

      if let message = message {
        message.presentInController(application.keyWindow?.rootViewController)
      }
    }
  }
}

extension Message {
  func presentInController(controller: UIViewController?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: continueButtonText, style: .Default, handler: goToAppStore))

    if cancelButtonText != nil {
      alert.addAction(UIAlertAction(title: cancelButtonText, style: .Cancel, handler: doItAgainLater))
    }

    controller?.presentViewController(alert, animated: true, completion: nil)
  }

  private func goToAppStore(action: UIAlertAction) {
    UIApplication.sharedApplication().openURL(iTunesURL)
  }

  private func doItAgainLater(action: UIAlertAction) {
    Retired.supressUntil(NSDate(timeIntervalSinceNow: intervalBetweenRequests))
  }
}
