import XCTest
import Temperature
import RelativeHumidity
import Enthalpy

final class EnthalpyTests: XCTestCase {
  
  func test_enthalpy() {
    let enthalpy = Enthalpy(temperature: .fahrenheit(75), humidity: 50%)
    
    XCTAssertEqual(round(enthalpy.rawValue * 100) / 100, 28.11)
    
    let enthalpy2 = Temperature.fahrenheit(75)
      .enthalpy(humidity: 50%, pressure: .init(altitude: .seaLevel))
    
    XCTAssertEqual(round(enthalpy2.rawValue * 100) / 100, 28.11)
  }

  func test_humidityRatio_and_partialPressure() {
    let partialPressure = Pressure.partialPressure(for: 75, at: 50%)
    let humidityRatio = Enthalpy.humidityRatio(for: .init(altitude: .seaLevel), with: partialPressure)
    XCTAssertEqual(round(humidityRatio * 10000) / 10000, 0.0092)
    XCTAssertEqual(round(partialPressure.psi * 10000) / 10000, 0.215)
  }
  
  func test_enthalpy_at_altitude() {
    let enthalpy = Enthalpy(temperature: .fahrenheit(75), humidity: 50%, altitude: 1000)
    XCTAssertEqual(round(enthalpy.rawValue * 100) / 100, 28.51)
//    XCTAssertEqual(round(enthalpy.humidityRatio * 10000) / 10000, 0.0096)
//    XCTAssertEqual(round(enthalpy.partialPressure * 10000) / 10000, 0.215)
    
    let enthalpy2 = Temperature.fahrenheit(75).enthalpy(humidity: 50%, altitude: 1000)
    XCTAssertEqual(round(enthalpy2.rawValue * 100) / 100, 28.51)
//    XCTAssertEqual(round(enthalpy2.humidityRatio * 10000) / 10000, 0.0096)
//    XCTAssertEqual(round(enthalpy2.partialPressure * 10000) / 10000, 0.215)
  }
  
  func test_addition_and_subtraction() {
    var enthalpy: Enthalpy = 28
    enthalpy += 1
    XCTAssertEqual(enthalpy.rawValue, 29)
    enthalpy -= 2
    XCTAssertEqual(enthalpy.rawValue, 27)
    enthalpy.rawValue -= 1
    XCTAssertEqual(enthalpy.rawValue, 26)
  }
  
  func test_equality() {
    XCTAssertEqual(Enthalpy.init(28.11), 28.11)
  }
  
  func test_comparable() {
    XCTAssertTrue(Enthalpy.init(exactly: 30)! > 28)
  }
  
  func test_magnitude() {
    XCTAssertEqual(Enthalpy.init(10).magnitude, 10.magnitude)
  }
  
  func test_multiplication() {
    var enthalpy: Enthalpy = 10 * 2
    XCTAssertEqual(enthalpy.rawValue, 20)
    enthalpy *= 2
    XCTAssertEqual(enthalpy.rawValue, 40)
  }
}
