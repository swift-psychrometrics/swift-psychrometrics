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
  
  func test_DewPoint_without_calculation() {
    let dewPoint = DewPoint(temperature: .fahrenheit(63))
    XCTAssertEqual(dewPoint.temperature.fahrenheit, 63)
  }
  
  func test_equality() {
    XCTAssertEqual(DewPoint(temperature: 63), 63)
  }
  
  func test_comparable() {
    XCTAssertTrue(DewPoint(temperature: 63) > 62.54)
  }
  
  func test_addition_and_subtraction() {
    var dewPoint: DewPoint = .init(exactly: 20)!
    XCTAssertEqual(dewPoint.temperature, 20)
    dewPoint += 10
    XCTAssertEqual(dewPoint.temperature, 30)
    dewPoint -= 5
    XCTAssertEqual(dewPoint.temperature, 25)
  }
  
//  func test_magnitude() {
//    XCTAssertEqual(DewPoint.init(temperature: 75).magnitude, 75.magnitude)
//  }
  
  func test_multiplication() {
    var dewPoint: DewPoint = 10
    dewPoint *= 6
    XCTAssertEqual(dewPoint.temperature, 60)
    
    let dewPoint2 = dewPoint * 3
    XCTAssertEqual(dewPoint2.temperature, 180)
  }
}
