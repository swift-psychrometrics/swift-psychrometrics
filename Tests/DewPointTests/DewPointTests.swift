import XCTest
import Core
import DewPoint
import HumidityRatio

final class DewPointTests: XCTestCase {
  
  func test_dewPoint_fahrenheit() {
    let temperature = Temperature.fahrenheit(75)
    XCTAssertEqual(
      round(temperature.dewPoint(humidity: 50%).rawValue.fahrenheit * 100) / 100,
      56.24
    )
  }
  
  func test_dewPoint_celsius() {
    let temperature = Temperature.celsius(23)
    XCTAssertEqual(
      round(temperature.dewPoint(humidity: 50%).rawValue.celsius * 100) / 100,
      12.65
    )
  }
  
  func test_calculating_humidity_from_dewPoint() {
    let temperature = Temperature.celsius(24)
    let dewPoint = Temperature.celsius(12.94)
    XCTAssertEqual(round(RelativeHumidity(temperature: temperature, dewPoint: dewPoint).rawValue), 50)
  }
  
  func test_DewPoint_without_calculation() {
    let dewPoint = DewPoint(.fahrenheit(63))
    XCTAssertEqual(dewPoint.rawValue.fahrenheit, 63)
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
  
  func test_dewPoint_from_vapor_pressure() {
    var vaporPressure = Pressure.saturationPressure(at: -4)
    var dewPoint = DewPoint.init(dryBulb: 59, vaporPressure: vaporPressure)
    XCTAssertEqual(round(dewPoint.fahrenheit * 1000) / 1000, -4)
    
    vaporPressure = .saturationPressure(at: 41)
    dewPoint = .init(dryBulb: 59, vaporPressure: vaporPressure)
    XCTAssertEqual(round(dewPoint.fahrenheit * 1000) / 1000, 41)
    
    vaporPressure = .saturationPressure(at: 122)
    dewPoint = .init(dryBulb: 140, vaporPressure: vaporPressure)
    XCTAssertEqual(round(dewPoint.fahrenheit * 1000) / 1000, 122)
  }
  
  func test_humidityRatio_from_dewPoint() {
    let pressure = Pressure(altitude: .seaLevel, units: .imperial)
    let ratio = HumidityRatio.init(for: 75, at: 50%, pressure: pressure)
    let dewPoint = DewPoint.init(for: 75, at: 50%)
    let ratio2 = HumidityRatio.init(dewPoint: dewPoint, pressure: pressure, units: .imperial)
    XCTAssertEqual(ratio, ratio2)
  }
}
