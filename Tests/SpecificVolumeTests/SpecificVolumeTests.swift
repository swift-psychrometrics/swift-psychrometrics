import XCTest
import Core
import SpecificVolume
import HumidityRatio

final class SpecificVolumeTests: XCTestCase {
  func test_specificVolume() {
    let volume = SpecificVolume(for: 75, at: 100%, altitude: .seaLevel)
    XCTAssertEqual(round(volume * 100) / 100, 13.89)
    XCTAssertEqual(
      round(SpecificVolume(for: 76.1, at: 58.3%, altitude: .seaLevel) * 100) / 100,
      13.75
    )
    
    let ratio = HumidityRatio(for: 75, at: 100%, altitude: .seaLevel)
    let volume2 = SpecificVolumeOf<MoistAir>.init(dryBulb: 75, ratio: ratio, altitude: .seaLevel, units: .imperial)
    XCTAssertEqual(
      round(volume.rawValue * 100000) / 100000,
      round(volume2.rawValue * 100000) / 100000
    )
  }
}
