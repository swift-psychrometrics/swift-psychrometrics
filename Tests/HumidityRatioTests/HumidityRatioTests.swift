import XCTest
import PsychrometricCore
import CoreUnitTypes
import TestSupport

final class HumidityRatioTests: XCTestCase {
  func test_humidityRatio_as_mass() {
    XCTAssertEqual(
      round(HumidityRatio(water: 14.7, dryAir: 18.3).rawValue * 100) / 100,
      0.50
    )
  }
  
  func test_humidityRatio_and_partialPressure() {
    let partialPressure = Pressure.vaporPressure(for: 75, at: 50%)
    let humidityRatio = HumidityRatio(
      totalPressure: .init(altitude: .seaLevel),
      partialPressure: partialPressure
    )
    XCTAssertEqual(round(humidityRatio.rawValue * 10000) / 10000, 0.0092)
    XCTAssertEqual(round(partialPressure.psi * 10000) / 10000, 0.215)
  }
  
  func test_humidityRatio_and_vapor_pressure() {
    // conditions at 77°F and standard pressure at 1000'
    let ratio = HumidityRatio(totalPressure: 14.175, partialPressure: 0.45973)
    XCTApproximatelyEqual(ratio.rawValue, 0.020847)
    let vaporPressure = Pressure.init(ratio: ratio, pressure: 14.175)
    XCTApproximatelyEqual(vaporPressure.rawValue, 0.45973)
  }
  
  func test_humidity_ratio_at_different_conditions_imperial() {
    let values: [(Temperature, HumidityRatio, Double)] = [
      (-58, 0.0000243, 0.01),
      (-4, 0.0006373, 0.01),
      (23, 0.0024863, 0.005),
      (41, 0.005425, 0.005),
      (77, 0.02173, 0.005),
      (122, 0.086863, 0.01),
      (185, 0.838105, 0.02)
    ]
    
    for (temp, expected, diff) in values {
      let ratio = HumidityRatio(for: temp, pressure: 14.696)
      XCTApproximatelyEqual(ratio.rawValue, expected.rawValue, tolerance: diff)
    }
  }
  
  func test_humidity_ratio_at_different_conditions_metric() {
    let values: [(Double, HumidityRatio, Double)] = [
      (-50, 0.0000243, 0.01),
      (-20, 0.0006373, 0.01),
      (-5, 0.0024863, 0.005),
      (5, 0.005425, 0.005),
      (25, 0.02173, 0.005),
      (50, 0.086863, 0.01),
      (85, 0.838105, 0.02)
    ]
    
    for (temp, expected, diff) in values {
      let ratio = HumidityRatio(for: .celsius(temp), pressure: .pascals(101325))
      XCTApproximatelyEqual(ratio.rawValue, expected.rawValue, tolerance: diff)
    }
  }

  func test_humidityRatio_and_relativeHumidity_imperial() {
    let relativeHumidity = RelativeHumidity.init(dryBulb: 100, ratio: 0.00523, pressure: 14.696, units: .imperial)
    XCTAssertEqual(round(relativeHumidity.rawValue), 13)
  }
}
