import Dependencies
import Psychrometrics
import SharedModels
import TestSupport
import XCTest

final class DewPointTests: PsychrometricTestCase {
  
  func test_calculating_humidity_from_dewPoint() async throws {
    @Dependency(\.psychrometricClient) var client;
    let sut = try await client.relativeHumidity(.dewPoint(
      .celsius(12.94),
      dryBulb: .celsius(24)
    ))
    XCTAssertEqual(round(sut.value), 50)
  }
  
  func test_DewPoint_without_calculation() {
    let dewPoint = DewPoint(.fahrenheit(63))
    XCTAssertEqual(dewPoint.fahrenheit, 63)
  }
  
  func test_equality() {
    XCTAssertEqual(DewPoint(63), 63)
  }
  
  func test_comparable() {
    XCTAssertTrue(DewPoint(63) > 62.54)
  }
  
  func test_addition_and_subtraction() {
    var dewPoint: DewPoint = .init(exactly: 20)!
    XCTAssertEqual(dewPoint.rawValue, 20)
    dewPoint += 10
    XCTAssertEqual(dewPoint.rawValue, 30)
    dewPoint -= 5
    XCTAssertEqual(dewPoint.rawValue, 25)
  }
  
//  func test_magnitude() {
//    XCTAssertEqual(DewPoint.init(temperature: 75).magnitude, 75.magnitude)
//  }
  
  func test_multiplication() {
    var dewPoint: DewPoint = 10
    dewPoint *= 6
    XCTAssertEqual(dewPoint.rawValue, 60)
    
    let dewPoint2 = dewPoint * 3
    XCTAssertEqual(dewPoint2.rawValue, 180)
  }
  
  func test_humidityRatio_from_dewPoint_imperial() async throws {
    @Dependency(\.psychrometricClient) var client;
    
    let pressure = TotalPressure(altitude: .seaLevel, units: .imperial)
    let ratio = try await client.humidityRatio(.dryBulb(
      75,
      relativeHumidity: 50%,
      totalPressure: pressure
    ))
    
    let dewPoint = try await client.dewPoint(.dryBulb(
      75,
      humidityRatio: ratio,
      totalPressure: pressure,
      units: .imperial
    ))
    
    let ratio2 = try await client.humidityRatio(.dewPoint(
      dewPoint,
      totalPressure: pressure
    ))
    XCTApproximatelyEqual(ratio.rawValue, ratio2.rawValue, tolerance: 2.2e-5)
  }
  
  func test_humidityRatio_from_dewPoint_metric() async throws {
    @Dependency(\.psychrometricClient) var client;
    
    let pressure = TotalPressure(altitude: .seaLevel, units: .metric)
    
    let ratio = try await client.humidityRatio(.dryBulb(
      .celsius(23.89),
      relativeHumidity: 50%,
      totalPressure: pressure,
      units: .metric
    ))
    
    let dewPoint = try await client.dewPoint(.dryBulb(
      .celsius(23.89),
      humidityRatio: ratio,
      totalPressure: pressure,
      units: .metric
    ))
    
    let ratio2 = try await client.humidityRatio(.dewPoint(
      dewPoint,
      totalPressure: pressure,
      units: .metric
    ))
    
    XCTApproximatelyEqual(ratio.rawValue, ratio2.rawValue, tolerance: 0.01)
  }
  
  func test_dewPoint_from_humidityRatio_imperial() async throws {
    @Dependency(\.psychrometricClient) var client;
    
    let dewPoint = try await client.dewPoint(.dryBulb(
      100,
      humidityRatio: 0.00523,
      totalPressure: 14.696,
      units: .imperial
    ))
    
    XCTApproximatelyEqual(dewPoint.rawValue.fahrenheit, 40, tolerance: 0.21)
  }
}
