# Retired (iOS)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A simple framework to help recommend/force app updates and sunset old versions

## Installation

### Carthage

Add the following to your Cartfile:

```
github "pseudomuto/Retired" ~> 0.0
```

### Cocoapods

Add this to your Podfile:

```
pod "Retired", "~> 0.0"
```

### Swift Package Manager

Add the dependency in your Package.swift file:

```swift
import PackageDescription

let package = Package(
  ...
  ...
  dependencies: [
    .Package(url: "https://github.com/pseudomuto/Retired.git", majorVersion: 0)
  ],
  ...
  ...
)
```

## Usage

### The Versions File

You'll need to host a JSON file on a server somewhere that defines options like whether or not an update is required,
recommended or not necessary.

The file also defines the messaging to be displayed in each case. For example, if the user has version 1.0 installed
(and the file below is used), when the you call `Retire.check` the supplied message in the completion block  will be 
the `forced` one.

If they're running 1.1, you'd get the recommended message, and if they're running 2.0 no update would be required.

Here's an example of a versions file:

```json
{
  "messaging": {
    "forced": {
      "title": "App Update Required",
      "message": "A new version of the app is available. You need to update now",
      "continueButtonText": "Let's do this"
    },
    "recommended": {
      "title": "App Update Available",
      "message": "A new version is available. Want it?",
      "continueButtonText": "I want it",
      "cancelButtonText": "No thanks"
    }
  },
  "versions": [
    { "version": "1.0", "policy": "force" },
    { "version": "1.1", "policy": "recommend" },
    { "version": "2.0", "policy": "none" }
  ]
}
```

There are two types of objects here; message and version.

**message**

* `title` - The title of the alert (e.g. New Version Available)
* `message` - The message to be displayed (e.g. There's a new version available)

**version**

* `version` - The version of the app (pulled from `CFBundleShortVersionString`)
* `policy` - One of `force`, `recommend` or `none`

### Checking Status in Your App

I don't wanna tell you how to handle displaying alerts or anything, but here's what I did in the example app (if you
open the workspace you'll see it in AppDelegate.swift).

First, I made an extension on `Message`

```swift
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
    // grab your iTunesURL from here: https://linkmaker.itunes.apple.com/
    UIApplication.sharedApplication().openURL(iTunesURL)
  }
}
```

Then, in `applicationDidBecomeActive`, I query the status and show a message if necessary:

```swift
func applicationDidBecomeActive(application: UIApplication) {
  Retired.check(versionURL) { updateRequired, message, error in
    guard updateRequired else { return }

    // handle error (non 200 status or network issue)

    if let message = message {
      message.presentInController(application.keyWindow?.rootViewController)
    }
  }
}
```

> _**You should be sure to not pester the user everytime the app becomes active**_.

> You could do this with a timer, user preference or how ever you like.
