import XCTest
import HumidityRatio
import Core
import SpecificHumidity

final class SpecificHumidityTests: XCTestCase {
  func test_specificHumidity() {
    XCTAssertEqual(
      round(SpecificHumidity(water: 14.7, dryAir: 18.3).rawValue * 100) / 100,
      0.45
    )
    let temperature: Temperature = 75
    let humidity: RelativeHumidity = 50%
    let altitude: Length = 1000
    let pressure: Pressure = .init(altitude: altitude)
    let ratio = HumidityRatio(
      for: temperature, with: humidity, at: pressure
    )
    
    XCTAssertEqual(
      round(SpecificHumidity(ratio: ratio).rawValue * 100) / 100,
      0.01
    )
    XCTAssertEqual(
      round(SpecificHumidity(
        for: temperature, with: humidity, at: pressure).rawValue * 1000) / 1000,
      0.009
    )
    XCTAssertEqual(
      round(SpecificHumidity(
        for: temperature, with: humidity, at: altitude).rawValue * 1000) / 1000,
      0.009
    )
  }
}
