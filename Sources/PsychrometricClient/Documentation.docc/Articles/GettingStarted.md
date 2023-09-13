# Getting Started

Learn how to integrate into your project

## Overview

Learn how to integrate the ``PsychrometricClient`` into your project.

### Adding as a dependency

To use this library in a swift package manager project, add it as a dependency in your
`Package.swift` file.

```swift
let package = PackageDescription(
  ...
  dependencies: [
    .package(url: "https://github.com/swift-psychrometrics/swift-psychrometrics.git", from: "0.1.0")
  ],
  targets: [
    .target(
      name: "<your-target-name>",
      dependencies: [
        .product("PsychrometricClient", package: "swift-psychrometrics")
        // or for the live client / calculations.
        .product("PsychrometricClientLive", package: "swift-psychrometrics")
      ]
    )
  ]
)
```

### Access the client in your feature

You access the client in your feature model by using the `Dependency` injection mechanism
provided by the [swift-dependencies](https://github.com/pointfreeco/swift-dependencies) library.

```swift
final class MyFeature: ObservableObject {
  @Dependency(\.psychrometricClient) var psychrometricClient
  
  // ...
}
```

Once the dependency is declared, you use one of it's requests to perform psychrometric calculations
for your model.

```swift
final class MyFeature: ObservableObject {
  // ...
  func submitButtonTapped() async throws { 
    self.psychrometricProperties = try await psychrometricClient.psychrometricProperties(
      .dryBulb(
        .fahrenheit(75),
        relativeHumidity: 50%,
        altitude: .seaLevel,
        units: .imperial
      )
    )
  }
}
```

### Live Client

Since the ``PsychrometricClient`` is an injectable `Dependency` then you need to load the 
`PsychrometricClientLive` module in the root of your project in order for the live dependency /
calculations to be available at runtime.  Familiarize yourself with the 
[swift-dependencies](https://pointfreeco.github.io/swift-dependencies/main/documentation/dependencies/livepreviewtest)
documentation for a better understanding of how the dependencies get resolved.
