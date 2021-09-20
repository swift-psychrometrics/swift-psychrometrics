import XCTest
import Temperature
@testable import Pressure

final class PressureTests: XCTestCase {
  
  func test_converting_to_atmosphere() {
    XCTAssertEqual(Pressure.atmosphere(10).atmosphere, 10)
    XCTAssertEqual(Pressure.psi(10).atmosphere, 0.6804596377991787)
    XCTAssertEqual(Pressure.bar(10).atmosphere, 9.8692316931427)
    XCTAssertEqual(Pressure.inchesWaterColumn(10).atmosphere, 0.0245832)
    XCTAssertEqual(Pressure.millibar(10).atmosphere, 0.0098692316931427)
    XCTAssertEqual(Pressure.pascals(10).atmosphere, 9.869231693142701e-5)
    XCTAssertEqual(Pressure.psi(10).atmosphere, 0.6804596377991787)
    XCTAssertEqual(Pressure.torr(10).atmosphere, 0.013157893594088999)
    
    var temp = Pressure.atmosphere(10)
    XCTAssertEqual(temp.atmosphere, 10)
    temp.atmosphere = 20
    XCTAssertEqual(temp.atmosphere, 20)
  }
  
  func test_converting_to_bar() {
    XCTAssertEqual(Pressure.torr(42).bar, 0.0559953954000001)
    
    var temp = Pressure.bar(10)
    XCTAssertEqual(temp.bar, 10)
    temp.bar = 20
    XCTAssertEqual(temp.bar, 20)
  }
  
  func test_converting_to_inchesWaterColumn() {
    XCTAssertEqual(Pressure.pascals(100).inchesWaterColumn, 0.4014624496868878)
    var temp = Pressure.inchesWaterColumn(10)
    XCTAssertEqual(temp.inchesWaterColumn, 10)
    temp.inchesWaterColumn = 20
    XCTAssertEqual(temp.inchesWaterColumn, 20)
  }
  
  func test_converting_to_millibar() {
    XCTAssertEqual(Pressure.psi(112).millibar, 7722.128915714985)
    var temp = Pressure.millibar(10)
    XCTAssertEqual(temp.millibar, 10)
    temp.millibar = 20
    XCTAssertEqual(temp.millibar, 20)
  }
  
  func test_converting_to_pascals() {
    XCTAssertEqual(Pressure.inchesWaterColumn(0.4014624496868878).pascals, 100)
    var temp = Pressure.pascals(10)
    XCTAssertEqual(temp.pascals, 10)
    temp.pascals = 20
    XCTAssertEqual(temp.pascals, 20)
  }
  
  func test_converting_to_psig() {
    XCTAssertEqual(Pressure.atmosphere(13).psi, 191.04733444655298)
    var temp = Pressure.psi(10)
    XCTAssertEqual(temp.psi, 10)
    temp.psi = 20
    XCTAssertEqual(temp.psi, 20)
  }
  
  func test_converting_to_torr() {
    XCTAssertEqual(Pressure.bar(0.0559953954000001).torr, 42)
    var temp = Pressure.torr(10)
    XCTAssertEqual(temp.torr, 10)
    temp.torr = 20
    XCTAssertEqual(temp.torr, 20)
  }
  
  func test_pressure_for_altitude() {
    let pressure = Pressure(altitude: .feet(1000))
    XCTAssertEqual(round(pressure.psi * 100) / 100, 14.15)
  }
  
  func test_vapor_pressure() {
    let temperature = Temperature.fahrenheit(56)
    let pressure = Pressure.vaporPressure(at: temperature)
    XCTAssertEqual(
      round(pressure.millibar * 10) / 10,
      15.3
    )
    XCTAssertEqual(
      round(pressure.psi * 100) / 100,
      0.22
    )
  }
  
  func test_comparable() {
    XCTAssertTrue(Pressure.psi(10) > 5)
  }
  
  func test_equality() {
    XCTAssertEqual(Pressure.psi(14.695948803580999), Pressure.atmosphere(1))
  }
  
  func test_addition_and_subtraction() {
    var pressure: Pressure = 20.1
    XCTAssertEqual(pressure.psi, 20.1)
    pressure += 10
    XCTAssertEqual(pressure.psi, 30.1)
    pressure -= 5
    XCTAssertEqual(pressure.psi, 25.1)
  }
  
  func test_multiplication() {
    var pressure: Pressure = .init(exactly: 10)! * 10
    XCTAssertEqual(pressure.psi, 100)
    pressure *= 2
    XCTAssertEqual(pressure.psi, 200)
  }
  
//  func test_magnitude() {
//    XCTAssertEqual(Pressure.psi(100).magnitude, 100.magnitude)
//  }
  
  func test_PressureUnit_symbol() {
    XCTAssertEqual(Pressure.Unit.atmosphere.symbol, "atm")
    XCTAssertEqual(Pressure.Unit.bar.symbol, "bar")
    XCTAssertEqual(Pressure.Unit.inchesWater.symbol, "inH2O")
    XCTAssertEqual(Pressure.Unit.millibar.symbol, "mb")
    XCTAssertEqual(Pressure.Unit.pascals.symbol, "Pa")
    XCTAssertEqual(Pressure.Unit.psi.symbol, "psi")
    XCTAssertEqual(Pressure.Unit.torr.symbol, "torr")
  }
  
  func test_PressureUnit_pressureKeyPath() {
    var pressure = Pressure.atmosphere(10)
    XCTAssertEqual(pressure[.atmosphere], 10)
    
    pressure.bar = 10
    XCTAssertEqual(pressure[.bar], 10)
    
    pressure.inchesWaterColumn = 10
    XCTAssertEqual(pressure[.inchesWater], 10)
    
    pressure.millibar = 10
    XCTAssertEqual(pressure[.millibar], 10)
    
    pressure.pascals = 10
    XCTAssertEqual(pressure[.pascals], 10)
    
    pressure.psi = 10
    XCTAssertEqual(pressure[.psi], 10)
    
    pressure[.torr] = 10
    XCTAssertEqual(pressure[.torr], 10)
  }
  
  func test_saturation_pressure() {
    let tempsAndExpectation: [(Temperature, Pressure)] = [
      (.fahrenheit(-30), .psi(0.00344)),
      (.fahrenheit(32), .psi(0.08865))
    ]
    
    for (temp, expected) in tempsAndExpectation {
      XCTAssertEqual(
        round(Pressure.saturationPressure(at: temp).psi * 100000) / 100000,
        expected.psi
      )
    }
  }
}
