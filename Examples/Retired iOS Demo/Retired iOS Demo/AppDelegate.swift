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
let versionURL = NSURL(string: "http://localhost:8000/versions.json")!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    return true
  }

  func applicationDidBecomeActive(application: UIApplication) {
    Retired.check(versionURL) { shouldUpdate, message, error in
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
      alert.addAction(UIAlertAction(title: cancelButtonText, style: .Cancel, handler: nil))
    }

    controller?.presentViewController(alert, animated: true, completion: nil)
  }

  private func goToAppStore(action: UIAlertAction) {
    UIApplication.sharedApplication().openURL(iTunesURL)
  }
}
