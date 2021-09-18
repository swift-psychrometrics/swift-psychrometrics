import XCTest
import Temperature
import RelativeHumidity
import Enthalpy

final class EnthalpyTests: XCTestCase {
  
  func test_enthalpy() {
    let enthalpy = Enthalpy(temperature: .fahrenheit(75), humidity: 50%)
    XCTAssertEqual(round(enthalpy.rawValue * 100) / 100, 28.11)
  }
  
  func test_enthalpy_at_altitude() {
    let enthalpy = Enthalpy(temperature: .fahrenheit(75), humidity: 50%, altitude: 1000)
    XCTAssertEqual(round(enthalpy.rawValue * 100) / 100, 28.51)
  }
}
