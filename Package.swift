// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "Puid",
  platforms: [
    .macOS(.v10_14)
  ],
  products: [
    .library(
      name: "Puid",
      targets: ["Puid"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-gen.git",
             from: "0.4.0")
  ],
  targets: [
    .target(
      name: "Puid",
      dependencies: []),
    .testTarget(
      name: "PuidTests",
      dependencies: ["Puid"]),
    .testTarget(
      name: "CompareTests",
      dependencies: [
        "Puid",
        .product(name: "Gen", package: "swift-gen"),
      ]),
    .testTarget(
      name: "DataTests",
      dependencies: ["Puid"]),
  ]
)


