// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Puid",
  products: [
    .library(
      name: "Puid",
      targets: ["Puid"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Puid",
      dependencies: []),
    .testTarget(
      name: "PuidTests",
      dependencies: ["Puid"]),
//    .testTarget(
//      name: "DataTests",
//      dependencies: ["Puid"]),
  ]
)
