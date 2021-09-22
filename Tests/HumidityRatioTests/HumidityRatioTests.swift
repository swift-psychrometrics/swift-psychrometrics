import XCTest
import HumidityRatio
import Core

final class HumidityRatioTests: XCTestCase {
  func test_humidityRatio_as_mass() {
    XCTAssertEqual(
      round(HumidityRatio(water: 14.7, dryAir: 18.3).rawValue * 100) / 100,
      0.50
    )
  }
  
  func test_humidityRatio_and_partialPressure() {
    let partialPressure = Pressure.partialPressure(for: 75, at: 50%)
    let humidityRatio = HumidityRatio(
      totalPressure: .init(altitude: .seaLevel),
      partialPressure: partialPressure
    )
    XCTAssertEqual(round(humidityRatio.rawValue * 10000) / 10000, 0.0092)
    XCTAssertEqual(round(partialPressure.psi * 10000) / 10000, 0.215)
  }
}
