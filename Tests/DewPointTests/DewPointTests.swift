import XCTest
import Temperature
import RelativeHumidity
import DewPoint

final class DewPointTests: XCTestCase {
  
  func test_dewPoint_fahrenheit() {
    let temperature = Temperature.fahrenheit(75)
    XCTAssertEqual(round(temperature.dewPoint(humidity: 50%).temperature.fahrenheit * 100) / 100, 55.11)
  }
  
  func test_dewPoint_celsius() {
    let temperature = Temperature.celsius(23)
    XCTAssertEqual(round(temperature.dewPoint(humidity: 50%).temperature.celsius * 100) / 100, 12.02)
  }
  
  func test_calculating_humidity_from_dewPoint() {
    let temperature = Temperature.celsius(24)
    let dewPoint = Temperature.celsius(12.94)
    XCTAssertEqual(round(RelativeHumidity(temperature: temperature, dewPoint: dewPoint).rawValue), 50)
  }
}
