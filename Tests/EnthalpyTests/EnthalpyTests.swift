import XCTest
import Temperature
import RelativeHumidity
import Enthalpy

final class EnthalpyTests: XCTestCase {
  
  func test_enthalpy() {
    let enthalpy = Enthalpy(temperature: .fahrenheit(75), humidity: 50%)
    
    XCTAssertEqual(round(enthalpy.rawValue * 100) / 100, 28.11)
    XCTAssertEqual(round(enthalpy.humidityRatio * 10000) / 10000, 0.0092)
    XCTAssertEqual(round(enthalpy.partialPressure * 10000) / 10000, 0.215)
    
    let enthalpy2 = Temperature.fahrenheit(75)
      .enthalpy(humidity: 50%, pressure: .init(altitude: .seaLevel))
    
    XCTAssertEqual(round(enthalpy2.rawValue * 100) / 100, 28.11)
    XCTAssertEqual(round(enthalpy2.humidityRatio * 10000) / 10000, 0.0092)
    XCTAssertEqual(round(enthalpy2.partialPressure * 10000) / 10000, 0.215)
  }
  
  func test_enthalpy_at_altitude() {
    let enthalpy = Enthalpy(temperature: .fahrenheit(75), humidity: 50%, altitude: 1000)
    XCTAssertEqual(round(enthalpy.rawValue * 100) / 100, 28.51)
    XCTAssertEqual(round(enthalpy.humidityRatio * 10000) / 10000, 0.0096)
    XCTAssertEqual(round(enthalpy.partialPressure * 10000) / 10000, 0.215)
    
    let enthalpy2 = Temperature.fahrenheit(75).enthalpy(humidity: 50%, altitude: 1000)
    XCTAssertEqual(round(enthalpy2.rawValue * 100) / 100, 28.51)
    XCTAssertEqual(round(enthalpy2.humidityRatio * 10000) / 10000, 0.0096)
    XCTAssertEqual(round(enthalpy2.partialPressure * 10000) / 10000, 0.215)
  }
}
