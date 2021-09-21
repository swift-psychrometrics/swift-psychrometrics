import XCTest
import Core
import SpecificHeat

final class SpecificHeatTests: XCTestCase {
  
  func test_specific_heat_of_water() {
    let specificHeat = SpecificHeat.water(at: .fahrenheit(50))
    XCTAssertEqual(round(specificHeat.rawValue.fahrenheit * 100) / 100, 1)
  }
}
