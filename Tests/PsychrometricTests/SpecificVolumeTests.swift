import Dependencies
import PsychrometricClientLive
import Psychrometrics
import SharedModels
import TestSupport
import XCTest

final class SpecificVolumeTests: PsychrometricTestCase {
  
  func test_specificVolume() async throws {
    @Dependency(\.psychrometricClient) var client;
    
    let volume = try await client.specificVolume.moistAir(.dryBulb(
      75,
      relativeHumidity: 100%,
      altitude: .seaLevel
    ))
    XCTApproximatelyEqual(volume.rawValue, 13.89, tolerance: 0.0047)
    
    let volume2 = try await client.specificVolume.moistAir(.dryBulb(
      86,
      humidityRatio: 0.02,
      totalPressure: 14.175
    ))
    XCTApproximatelyEqual(volume2.rawValue, 14.7205749002918)
    
    let ratio = try await client.humidityRatio(.dryBulb(
      75,
      relativeHumidity: 100%,
      altitude: .seaLevel
    ))
    
    let volume3 = try await client.specificVolume.moistAir(.dryBulb(
      75,
      humidityRatio: ratio,
      totalPressure: .init(altitude: .seaLevel)
    ))
    XCTApproximatelyEqual(volume, volume3)
  }
  
  func test_addition() {
    let v1 = SpecificVolumeOf<MoistAir>.init(10)
    let v2 = v1 + 12
    XCTAssertEqual(v2, 22)
  }
  
  func test_units_returns_appropriatly_for_global_units() {
    let imperial = SpecificVolumeOf<DryAir>.Units.defaultFor(units: .imperial)
    XCTAssertEqual(imperial, .cubicFeetPerPound)
    let metric = SpecificVolumeOf<DryAir>.Units.defaultFor(units: .metric)
    XCTAssertEqual(metric, .cubicMeterPerKilogram)
  }
  
  func test_dry_air_imperial() async {
    @Dependency(\.psychrometricClient) var client;
    let volume = await client.specificVolume.dryAir(.dryBulb(77, totalPressure: 14.696))
    XCTApproximatelyEqual(volume, 13.5251, tolerance: 0.0047)
  }
  
  func test_dry_air_metric() async {
    @Dependency(\.psychrometricClient) var client;
    let volume = await client.specificVolume.dryAir(.dryBulb(
      .celsius(24),
      totalPressure: .pascals(101325),
      units: .metric
    ))
    XCTApproximatelyEqual(volume, 0.8443, tolerance: 0.003)
  }
  
  func test_mostAir_metric() async throws {
    @Dependency(\.psychrometricClient) var client;
    let volume = try await client.specificVolume.moistAir(.dryBulb(
      .celsius(30),
      humidityRatio: 0.02,
      totalPressure: .pascals(95461),
      units: .metric
    ))
    XCTApproximatelyEqual(volume, 0.940855374352943, tolerance: 0.0003)
  }
  
  // Not working.
//  func test_dry_bulb_from_volume() {
//    let dryBulb = Temperature.init(
//      volume: 14.72,
//      ratio: 0.02,
//      pressure: 14.175,
//      units: .imperial
//    )
//
//    XCTAssertEqual(round(dryBulb.rawValue), 86)
//  }
}
