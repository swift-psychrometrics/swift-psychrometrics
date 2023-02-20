import XCTest
import Psychrometrics
import SharedModels

final class SpecificHeatTests: XCTestCase {
  
  func test_specific_heat_of_water() async {
    let specificHeat = await SpecificHeat.water(temperature: .init(.fahrenheit(50)))
    XCTAssertEqual(round(specificHeat.rawValue.fahrenheit * 100) / 100, 1)
  }
}
