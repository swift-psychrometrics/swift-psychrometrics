// swift-tools-version:5.7
import Foundation
import PackageDescription

var package = Package(
  name: "swift-psychrometrics",
  platforms: [
    .macOS(.v12),
      .iOS(.v15)
  ],
  products: [
    .library(name: "ConcurrencyHelpers", targets: ["ConcurrencyHelpers"]),
    .library(name: "SharedModels", targets: ["SharedModels"]),
    .library(name: "SiteRouter", targets: ["SiteRouter"]),
    .library(name: "PsychrometricEnvironment", targets: ["PsychrometricEnvironment"]),
    .library(name: "Psychrometrics", targets: ["Psychrometrics"]),
    .library(name: "TestSupport", targets: ["TestSupport"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "0.12.0"),
    .package(
      url: "https://github.com/pointfreeco/swift-custom-dump.git", from: "0.6.1"
    ),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.0"),
    .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.6.0"),
    .package(url: "https://github.com/pointfreeco/swift-url-routing", from: "0.4.0"),
    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "0.6.0"),
  ],
  targets: [
    .target(
      name: "ConcurrencyHelpers",
      dependencies: []
    ),
    .target(
      name: "SharedModels",
      dependencies: [
        .product(name: "Tagged", package: "swift-tagged")
      ]
    ),
    .testTarget(
      name: "SharedModelsTests",
      dependencies: [
        "SharedModels",
        "Psychrometrics",
        "TestSupport",
      ]
    ),
    .target(
      name: "PsychrometricEnvironment",
      dependencies: [
        "SharedModels",
        .product(name: "Dependencies", package: "swift-dependencies"),
      ]
    ),
    .target(
      name: "SiteRouter",
      dependencies: [
        "SharedModels",
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "URLRouting", package: "swift-url-routing"),
      ]
    ),
    .testTarget(
      name: "SiteRouterTests",
      dependencies: [
        "SiteRouter",
        .product(name: "CustomDump", package: "swift-custom-dump"),
      ]
    ),
    .target(
      name: "Psychrometrics",
      dependencies: [
        "SharedModels",
        "PsychrometricEnvironment",
      ]
    ),
    .testTarget(
      name: "PsychrometricTests",
      dependencies: [
        "Psychrometrics",
        "TestSupport",
      ]
    ),
    .target(
      name: "TestSupport",
      dependencies: []
    ),
  ]
)

// MARK: - Client
if ProcessInfo.processInfo.environment["TEST_SERVER"] == nil {
  package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.51.0")
  ])
  package.products.append(contentsOf: [
    .library(name: "DewPointCalcFeature", targets: ["DewPointCalcFeature"])
  ])
  package.targets.append(contentsOf: [
    .target(
      name: "DewPointCalcFeature",
      dependencies: [
        "Psychrometrics",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
  ])
}

// #MARK: - CLI
if #available(macOS 10.15, *),
  ProcessInfo.processInfo.environment["PSYCHROMETRIC_CLI_ENABLED"] != nil
{
  //  package.platforms = [
  //    .macOS(.v10_15)
  //  ]
  package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/vapor/console-kit.git", from: "4.2.0")
  ])
  package.products.append(contentsOf: [
    .executable(name: "psychrometrics", targets: ["swift-psychrometrics"])
  ])
  package.targets.append(contentsOf: [
    .executableTarget(
      name: "swift-psychrometrics",
      dependencies: [
        "Psychrometrics",
        .product(name: "ConsoleKit", package: "console-kit"),
      ]
    )
  ])
}

// MARK: - Server
package.dependencies.append(contentsOf: [
  .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
  .package(url: "https://github.com/pointfreeco/vapor-routing.git", from: "0.1.0"),
])
package.products.append(contentsOf: [
  .executable(name: "server", targets: ["server"]),
  .library(name: "ApiMiddleware", targets: ["ApiMiddleware"]),
  .library(name: "ApiMiddlewareLive", targets: ["ApiMiddlewareLive"]),
  .library(name: "ServerConfig", targets: ["ServerConfig"]),
  .library(name: "SiteMiddleware", targets: ["SiteMiddleware"]),
])
package.targets.append(contentsOf: [
  .target(
    name: "ApiMiddleware",
    dependencies: [
      "ConcurrencyHelpers",
      "SharedModels",
      .product(name: "CasePaths", package: "swift-case-paths"),
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
    ]
  ),
  .target(
    name: "ApiMiddlewareLive",
    dependencies: [
      "ApiMiddleware",
      "Psychrometrics",
    ]
  ),
  .executableTarget(
    name: "server",
    dependencies: [
      "ServerConfig",
      .product(name: "Vapor", package: "vapor"),
    ]
  ),
  .target(
    name: "ServerConfig",
    dependencies: [
      "ApiMiddlewareLive",
      "SiteMiddleware",
      "SiteRouter",
      .product(name: "Vapor", package: "vapor"),
      .product(name: "VaporRouting", package: "vapor-routing"),
    ]
  ),
  .target(
    name: "SiteMiddleware",
    dependencies: [
      "ApiMiddleware",
      "SharedModels",
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "Vapor", package: "vapor"),
      .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
    ]
  ),
  .testTarget(
    name: "SiteMiddlewareTests",
    dependencies: [
      "ApiMiddlewareLive",
      "SiteMiddleware",
      "TestSupport",
    ]
  ),
])
