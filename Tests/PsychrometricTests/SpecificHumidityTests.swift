import XCTest
import Psychrometrics
import SharedModels
import TestSupport

final class SpecificHumidityTests: XCTestCase {
  func test_specificHumidity() async throws {
    XCTAssertEqual(
      round(SpecificHumidity(water: 14.7, dryAir: 18.3).rawValue * 100) / 100,
      0.45
    )
    let temperature: Temperature = 75
    let humidity: RelativeHumidity = 50%
    let altitude: Length = 1000
    let pressure: Pressure = .init(altitude: altitude)
    let ratio = try await HumidityRatio(
      dryBulb: temperature, humidity: humidity, pressure: pressure
    )
    
    XCTAssertEqual(
      round(SpecificHumidity(ratio: ratio).rawValue * 100) / 100,
      0.01
    )
    var sut = try await SpecificHumidity(
        for: temperature, with: humidity, at: pressure).rawValue * 1000
    XCTAssertEqual(
      round(sut) / 1000,
      0.009
    )
    sut = try await SpecificHumidity(
        for: temperature, with: humidity, at: altitude).rawValue * 1000
    XCTAssertEqual(
      round(sut) / 1000,
      0.009
    )
  }
  
  func test_conversions_between_specificHumidity_and_humidityRatio() throws {
    let specific = SpecificHumidity(ratio: 0.006)
    XCTApproximatelyEqual(specific.rawValue,  0.00596421471)
    let ratio = try HumidityRatio(specificHumidity: 0.00596421471)
    XCTApproximatelyEqual(ratio.rawValue, 0.006)
  }
}
