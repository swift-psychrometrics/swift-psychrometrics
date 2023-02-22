import XCTest
import Psychrometrics
import SharedModels
import TestSupport

final class HumidityRatioTests: XCTestCase {
  func test_humidityRatio_as_mass() async {
    let ratio = await HumidityRatio(water: 14.7, dryAir: 18.3)
    XCTAssertEqual(
      round(ratio.rawValue * 100) / 100,
      0.50
    )
  }
  
  func test_humidityRatio_and_partialPressure() async throws {
    let partialPressure = try await VaporPressure(dryBulb: 75, humidity: 50%)
    let humidityRatio = await HumidityRatio(
      totalPressure: .init(altitude: .seaLevel),
      vaporPressure: partialPressure
    )
    XCTAssertEqual(round(humidityRatio.rawValue * 10000) / 10000, 0.0092)
    XCTAssertEqual(round(partialPressure.psi * 10000) / 10000, 0.215)
  }
  
  func test_humidityRatio_and_vapor_pressure() async throws {
    // conditions at 77°F and standard pressure at 1000'
    let ratio = await HumidityRatio(totalPressure: 14.175, vaporPressure: 0.45973)
    XCTApproximatelyEqual(ratio.rawValue, 0.020847)
    let vaporPressure = try VaporPressure(ratio: ratio, pressure: 14.175)
    XCTApproximatelyEqual(vaporPressure, 0.45973)
  }
  
  func test_humidity_ratio_at_different_conditions_imperial() async throws {
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
      let ratio = try await HumidityRatio(dryBulb: temp, pressure: 14.696)
      XCTApproximatelyEqual(ratio.rawValue.rawValue, expected.rawValue.rawValue, tolerance: diff)
    }
  }
  
  func test_humidity_ratio_at_different_conditions_metric() async throws {
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
      let ratio = try await HumidityRatio(dryBulb: .celsius(temp), pressure: .pascals(101325))
      XCTApproximatelyEqual(ratio.rawValue.rawValue, expected.rawValue.rawValue, tolerance: diff)
    }
  }

  func test_humidityRatio_and_relativeHumidity_imperial() async throws {
    let relativeHumidity = try await RelativeHumidity.init(dryBulb: 100, ratio: 0.00523, pressure: 14.696, units: .imperial)
    XCTAssertEqual(round(relativeHumidity.rawValue.rawValue), 13)
  }
}
