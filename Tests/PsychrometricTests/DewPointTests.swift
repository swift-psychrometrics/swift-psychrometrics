import XCTest
@testable import Psychrometrics
import SharedModels
import TestSupport

final class DewPointTests: XCTestCase {
  
  func test_calculating_humidity_from_dewPoint() {
    let temperature = Temperature.celsius(24)
    let dewPoint = Temperature.celsius(12.94)
    XCTAssertEqual(round(RelativeHumidity(temperature: temperature, dewPoint: dewPoint).rawValue.rawValue), 50)
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
  
  func test_humidityRatio_from_dewPoint_imperial() {
    let pressure = Pressure(altitude: .seaLevel, units: .imperial)
    let ratio = HumidityRatio.init(dryBulb: 75, humidity: 50%, pressure: pressure)
    let dewPoint = DewPoint.init(dryBulb: 75, ratio: ratio, pressure: pressure, units: .imperial)
    let ratio2 = HumidityRatio.init(dewPoint: dewPoint, pressure: pressure, units: .imperial)
    XCTApproximatelyEqual(ratio.rawValue, ratio2.rawValue, tolerance: 2.2e-5)
  }
  
  func test_humidityRatio_from_dewPoint_metric() {
    let pressure = Pressure(altitude: .seaLevel, units: .metric)
    let ratio = HumidityRatio.init(dryBulb: .celsius(23.89), humidity: 50%, pressure: pressure, units: .metric)
    
    let dewPoint = DewPoint.init(dryBulb: .celsius(23.89), ratio: ratio, pressure: pressure, units: .metric)
    let ratio2 = HumidityRatio.init(dewPoint: dewPoint, pressure: pressure, units: .metric)
    XCTApproximatelyEqual(ratio.rawValue, ratio2.rawValue, tolerance: 0.01)
  }
  
  func test_dewPoint_from_humidityRatio_imperial() {
    let dewPoint = DewPoint.init(dryBulb: 100, ratio: 0.00523, pressure: 14.696, units: .imperial)
    XCTApproximatelyEqual(dewPoint.rawValue.fahrenheit, 40, tolerance: 0.21)
  }
}
