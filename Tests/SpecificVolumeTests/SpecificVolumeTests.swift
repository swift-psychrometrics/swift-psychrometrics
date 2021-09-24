import XCTest
@testable import PsychrometricCore
import CoreUnitTypes
import TestSupport

final class SpecificVolumeTests: XCTestCase {
  
  func test_specificVolume() {
    let volume = SpecificVolumeOf<MoistAir>(dryBulb: 75, humidity: 100%, altitude: .seaLevel)
    XCTApproximatelyEqual(volume.rawValue, 13.89, tolerance: 0.0047)
    
    let volume2 = SpecificVolumeOf<MoistAir>.init(
      dryBulb: 86,
      ratio: 0.02,
      pressure: 14.175,
      units: .imperial
    )
    XCTApproximatelyEqual(volume2.rawValue, 14.7205749002918)
    
    let ratio = HumidityRatio(for: 75, at: 100%, altitude: .seaLevel)
    let volume3 = SpecificVolumeOf<MoistAir>(
      dryBulb: 75,
      ratio: ratio,
      pressure: .init(altitude: .seaLevel),
      units: .imperial
    )
    XCTApproximatelyEqual(volume.rawValue, volume3.rawValue)
  }
  
  func test_addition() {
    let v1 = SpecificVolumeOf<MoistAir>.init(10)
    let v2 = v1 + 12
    XCTAssertEqual(v2, 22)
  }
  
  func test_units_returns_appropriatly_for_global_units() {
    let imperial = SpecificVolumeOf<DryAir>.Units.for(.imperial)
    XCTAssertEqual(imperial, .cubicFeetPerPound)
    let metric = SpecificVolumeOf<DryAir>.Units.for(.metric)
    XCTAssertEqual(metric, .cubicMeterPerKilogram)
  }
  
  func test_dry_air_imperial() {
    let volume = SpecificVolumeOf<DryAir>(dryBulb: 77, pressure: 14.696, units: .imperial)
    XCTApproximatelyEqual(volume, 13.5251, tolerance: 0.0047)
  }
  
  func test_dry_air_metric() {
    let volume = SpecificVolumeOf<DryAir>.init(
      dryBulb: .celsius(24),
      pressure: .pascals(101325),
      units: .metric
    )
    XCTApproximatelyEqual(volume, 0.8443, tolerance: 0.003)
  }
  
  func test_mostAir_metric() {
    let volume = SpecificVolumeOf<MoistAir>.init(
      dryBulb: .celsius(30),
      ratio: 0.02,
      pressure: .pascals(95461),
      units: .metric
    )
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
