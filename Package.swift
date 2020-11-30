// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Retired",
  products: [
    .library(
      name: "Retired",
      targets: ["Retired iOS"])
  ],
  targets: [
    .target(
      name: "Retired iOS",
      dependencies: [],
      path: "Sources"
    ),
    .testTarget(
      name: "Retired iOSTests",
      dependencies: ["Retired iOS"],
      path: "Tests"
    )
  ]
)
