# Overriding Calculations

Learn about overriding calculations.

## Overview

This document explains how to override calculations when using the client in `SwiftUI` previews
or test context.

The ``PsychrometricClient`` has a method that you can use to override the calculations when using
the client in a preview or test context.  The client exposes many properties that are considered 
the root item that gets used when calculating / converting a request to a psychrometric value.

Each property takes a `Request` as an argument and returns a value. The properties always get called 
when calculating a psychrometric value, however many of the request types also expose static methods 
that may use other properties on the client to convert to the root value types needed for the request 
to be processed.  So, when overriding properties on the client, you may have to override more 
properties depending on your context.

The methods / properties, in general, have any other items that need to be overriden in 
their documentation.


### How to override calculations

The client exposes an ``PsychrometricClient/PsychrometricClient/override(_:closure:)`` method that you
use to override a property for a test or preview context and need access to the request in order to
return a value. It also has an ``PsychrometricClient/PsychrometricClient/override(_:returning:)`` when
you just want to return a mock value and ignore the request.

For example, let's say that we have a feature that calculates the density of water, using the
``PsychrometricClient/PsychrometricClient/DensityClient/water`` property.

```swift
final class MyFeature: ObservableObject {

  @Dependency(\.psychrometricClient.density.water) var calculateWaterDensity
  @Published var dryBulb: DryBulb
  @Published var waterDensity: DensityOf<Water>? = nil

  init(dryBulb: DryBulb) { 
    self.dryBulb = dryBulb
  }

  func calculateWaterDensityButtonTapped() async throws { 
    self.waterDensity = try await calculateWaterDensity(self.dryBulb)
  }
}

```

Now let's say for test or preview purposes we just want to return a mock value, we can override just the
water density property on the client returning our mock value.

```swift
func testCalculateWaterDensity() async throws { 
  try await withDependencies {
    // Override just the density of water property for the test.
    $0.psychrometricClient.override(\.density.water, returning: 60)
    
  } operation: {
    let feature = MyFeature(dryBulb: 40)
    try await feature.calculateWaterDensity()
    XCTAssertEqual(feature.waterDensity, 60)
  }
}
```
