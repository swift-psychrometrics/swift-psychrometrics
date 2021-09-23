import XCTest
import Core
@testable import SpecificVolume
import HumidityRatio

final class SpecificVolumeTests: XCTestCase {
  
  func test_specificVolume() {
    let volume = SpecificVolumeOf<MoistAir>(dryBulb: 75, humidity: 100%, altitude: .seaLevel)
    XCTAssertEqual(round(volume.rawValue * 100) / 100, 13.89)
    
    let volume2 = SpecificVolumeOf<MoistAir>.init(
      dryBulb: 86,
      ratio: 0.02,
      pressure: 14.175,
      units: .imperial
    )
    XCTAssertEqual(
      round(volume2.rawValue * 10e12) / 10e12,
      14.7205749002918
    )
    
    let ratio = HumidityRatio(for: 75, at: 100%, altitude: .seaLevel)
    let volume3 = SpecificVolumeOf<MoistAir>(dryBulb: 75, ratio: ratio, pressure: .init(altitude: .seaLevel), units: .imperial)
    XCTAssertEqual(
      round(volume.rawValue * 100000) / 100000,
      round(volume3.rawValue * 100000) / 100000
    )
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
  
  func test_dry_air() {
    let volume = SpecificVolumeOf<DryAir>(dryBulb: 77, pressure: 14.696, units: .imperial)
    XCTAssertEqual(
      round(volume.rawValue * 1000) / 1000,
      13.529
//      13.5251
    )
  }
}
