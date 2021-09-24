import XCTest
import PsychrometricCore
import CoreUnitTypes

final class GrainsOfMoistureTests: XCTestCase {
  
  func test_grains() {
    let temperature = Temperature.fahrenheit(75)
    let grains = temperature.grains(humidity: 50%)
    XCTAssertEqual(round(grains.rawValue * 100) / 100, 65.91)
  }
  
  func test_comparable() {
    XCTAssertTrue(GrainsOfMoisture.init(exactly: 28)! > 26)
  }
  
  func test_addition_and_subtraction() {
    var grains = GrainsOfMoisture.init(10)
    grains += 10
    XCTAssertEqual(grains.rawValue, 20)
    grains -= 5
    XCTAssertEqual(grains.rawValue, 15)
  }
  
  func test_magnitude() {
    XCTAssertEqual(GrainsOfMoisture.init(10).magnitude, 10.magnitude)
  }
  
  func test_multiplication() {
    var grains: GrainsOfMoisture = 10 * 3
    XCTAssertEqual(grains.rawValue, 30)
    grains *= 2
    XCTAssertEqual(grains.rawValue, 60)
  }
}
