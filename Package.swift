// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "Puid",
  platforms: [
    .macOS(.v10_14),
    .iOS(.v12),
    .tvOS(.v12),
    .watchOS(.v5)
  ],
  products: [
    .library(
      name: "Puid",
      targets: ["Puid"]),
  ],
  targets: [
    .target(
      name: "Puid",
      dependencies: []),
    .testTarget(
      name: "PuidTests",
      dependencies: ["Puid"]),
    .testTarget(
      name: "DataTests",
      dependencies: ["Puid"]),
  ]
)


