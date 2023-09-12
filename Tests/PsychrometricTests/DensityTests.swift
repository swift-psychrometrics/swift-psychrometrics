import Dependencies
import PsychrometricClientLive
import SharedModels
import TestSupport
import XCTest

final class DensityTests: PsychrometricTestCase {
  
  func testDensityOfWater() async throws {
    @Dependency(\.psychrometricClient) var client;
    let density = try await client.density.water(.fahrenheit(50))
    XCTAssertEqual(
      round(density.value * 100) / 100,
      62.58
    )
  }
  
  func testDensityOfAir_imperial() async throws {
    @Dependency(\.psychrometricClient) var client;
    let density = try await client.density.dryAir(
      .dryBulb(.fahrenheit(60), totalPressure: .psi(14.7))
    )
    XCTAssertEqual(
      round(density.value * 1000) / 1000,
      0.076
    )
    let density2 = try await client.density.dryAir(
      .dryBulb(.fahrenheit(60), altitude: .seaLevel)
    )
    XCTAssertEqual(
      round(density2.value * 1000) / 1000,
      0.076
    )
  }
  
  func test_density_of_dryAir_metric() async throws {
    @Dependency(\.psychrometricClient) var client;
    let density = try await client.density.dryAir(
      .dryBulb(.celsius(25), totalPressure: .pascals(101325), units: .metric)
    )
    XCTApproximatelyEqual(density.rawValue, 1.18441, tolerance: 0.003)
  }
  
  func test_density_of_moistAir_metric() async throws {
    @Dependency(\.psychrometricClient) var client;
    let density = try await client.density.moistAir(
      .dryBulb(
        .celsius(30),
        humidityRatio: 0.02,
        totalPressure: .pascals(95461),
        units: .metric
      )
    )
    XCTApproximatelyEqual(density, 1.08411986348219, tolerance: 0.0003)
  }

}
