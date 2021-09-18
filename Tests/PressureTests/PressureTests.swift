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
  }
  
  func test_converting_to_bar() {
    XCTAssertEqual(Pressure.torr(42).bar, 0.0559953954000001)
  }
  
  func test_converting_to_inchesWaterColumn() {
    XCTAssertEqual(Pressure.pascals(100).inchesWaterColumn, 0.4014624496868878)
  }
  
  func test_converting_to_millibar() {
    XCTAssertEqual(Pressure.psi(112).millibar, 7722.128915714985)
  }
  
  func test_converting_to_pascals() {
    XCTAssertEqual(Pressure.inchesWaterColumn(0.4014624496868878).pascals, 100)
  }
  
  func test_converting_to_psig() {
    XCTAssertEqual(Pressure.atmosphere(13).psi, 191.04733444655298)
  }
  
  func test_converting_to_torr() {
    XCTAssertEqual(Pressure.bar(0.0559953954000001).torr, 42)
  }
  
  func test_pressure_for_altitude() {
    let pressure = Pressure(altitude: 1000)
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
  
}
