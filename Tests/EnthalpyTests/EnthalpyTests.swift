import XCTest
import Temperature
import RelativeHumidity
import Enthalpy

final class EnthalpyTests: XCTestCase {
  
  func test_enthalpy() {
    let enthalpy = Enthalpy(for: .fahrenheit(75), at: 50%)
    
    XCTAssertEqual(round(enthalpy.rawValue * 100) / 100, 28.11)
    
    let enthalpy2 = Temperature.fahrenheit(75)
      .enthalpy(at: 50%, pressure: .init(altitude: .seaLevel))
    
    XCTAssertEqual(round(enthalpy2.rawValue * 100) / 100, 28.11)
  }

  func test_humidityRatio_and_partialPressure() {
    let partialPressure = Pressure.partialPressure(for: 75, at: 50%)
    let humidityRatio = Enthalpy.humidityRatio(for: .init(altitude: .seaLevel), with: partialPressure)
    XCTAssertEqual(round(humidityRatio * 10000) / 10000, 0.0092)
    XCTAssertEqual(round(partialPressure.psi * 10000) / 10000, 0.215)
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
  
  func test_humidityRatio_as_mass() {
    XCTAssertEqual(
      round(Enthalpy.humidityRatio(water: 14.7, dryAir: 18.3) * 100) / 100,
      0.50
    )
  }
  
  func test_specificHumidity() {
    XCTAssertEqual(
      round(Enthalpy.specificHumidity(water: 14.7, dryAir: 18.3) * 100) / 100,
      0.45
    )
    let temperature: Temperature = 75
    let humidity: RelativeHumidity = 50%
    let altitude: Length = 1000
    let pressure: Pressure = .init(altitude: altitude)
    let ratio = Enthalpy.humidityRatio(
      for: temperature, with: humidity, at: pressure
    )
    
    XCTAssertEqual(
      round(Enthalpy.specificHumidity(ratio: ratio) * 100) / 100,
      0.01
    )
    XCTAssertEqual(
      round(Enthalpy.specificHumidity(
        for: temperature, with: humidity, at: pressure) * 1000) / 1000,
      0.009
    )
    XCTAssertEqual(
      round(Enthalpy.specificHumidity(
        for: temperature, with: humidity, at: altitude) * 1000) / 1000,
      0.009
    )
  }
  
  func test_specificVolume() {
    let volume = Enthalpy.specificVolume(for: 75, at: 100%, altitude: .seaLevel)
    XCTAssertEqual(round(volume * 100) / 100, 13.89)
    XCTAssertEqual(
      round(Enthalpy.specificVolume(for: 76.1, at: 58.3%, altitude: .seaLevel) * 100) / 100,
      13.75
    )
  }
}
