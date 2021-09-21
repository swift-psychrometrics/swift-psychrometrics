import XCTest
import Core
import Enthalpy

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
  
  func test_specificVolume() {
    let volume = Enthalpy.specificVolume(for: 75, at: 100%, altitude: .seaLevel)
//    let vda = Enthalpy.specificVolume(for: 75, at: 0%, altitude: .seaLevel)
//    print(vda)
//    XCTFail()
    XCTAssertEqual(round(volume * 100) / 100, 13.89)
    XCTAssertEqual(
      round(Enthalpy.specificVolume(for: 76.1, at: 58.3%, altitude: .seaLevel) * 100) / 100,
      13.75
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
