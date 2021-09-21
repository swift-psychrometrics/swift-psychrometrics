import XCTest
import Core
import Enthalpy
import HumidityRatio

final class EnthalpyTests: XCTestCase {
  
  func test_enthalpy() {
    let enthalpy = Enthalpy(for: .fahrenheit(75), at: 50%)
    
    XCTAssertEqual(round(enthalpy.rawValue * 100) / 100, 28.11)
    
    let enthalpy2 = Temperature.fahrenheit(75)
      .enthalpy(at: 50%, pressure: .init(altitude: .seaLevel))
    
    XCTAssertEqual(round(enthalpy2.rawValue * 100) / 100, 28.11)
  }
  
  func test_enthalpy_at_altitude() {
    let enthalpy = Enthalpy(for: .fahrenheit(75), at: 50%, altitude: 1000)
    XCTAssertEqual(round(enthalpy.rawValue * 100) / 100, 28.49)
    
    let enthalpy2 = Temperature.fahrenheit(75).enthalpy(at: 50%, altitude: 1000)
    XCTAssertEqual(round(enthalpy2.rawValue * 100) / 100, 28.49)
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
  
  func test_humidityRatio_from_enthalpy() {
    let enthalpy = Enthalpy(for: 75, at: 50%)
    let ratio = HumidityRatio(for: 75, at: 50%, altitude: .seaLevel)
    XCTAssertEqual(
      round(enthalpy.humidityRatio(at: 75) * 1000000) / 1000000,
      round(ratio * 1000000) / 1000000
    )
  }
  
  func test_temperature_from_enthalpy_and_ratio() {
    let temperature: Temperature = 75
    let humidity: RelativeHumidity = 50%
    let ratio = HumidityRatio(for: temperature, at: humidity, altitude: .seaLevel)
    let enthalpy = Enthalpy.init(for: temperature, ratio: ratio)
    let temperature2 = Temperature(enthalpy: enthalpy, ratio: ratio)
    XCTAssertEqual(
      round(temperature2.fahrenheit * 100) / 100,
      75
    )
    XCTAssertEqual(
      round(temperature2.fahrenheit * 100) / 100,
      temperature.fahrenheit
    )
  }
  
//  func test_relative_humidity_for_dewPoint_and_dryBulb_enthalpies() {
//    let totalPressure = Pressure(altitude: .seaLevel)
//    let saturationPressure = Pressure.saturationPressure(at: 75)
//    let rh = (saturationPressure.psi / totalPressure.psi)
//    print(rh)
//    XCTFail()
//  }
}
