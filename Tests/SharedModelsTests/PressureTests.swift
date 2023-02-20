import XCTest
import SharedModels
import Psychrometrics
import TestSupport

final class PressureTests: XCTestCase {
  
  func test_converting_to_atmosphere() {
    XCTAssertEqual(Pressure.atmosphere(10).atmosphere, 10)
    XCTAssertEqual(Pressure.psi(10).atmosphere, 0.6804596377991787)
    XCTAssertEqual(Pressure.bar(10).atmosphere, 9.8692316931427)
    XCTAssertEqual(Pressure.inchesWater(10).atmosphere, 0.0245832)
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
    XCTAssertEqual(Pressure.pascals(100).inchesWater, 0.4014624496868878)
    var temp = Pressure.inchesWater(10)
    XCTAssertEqual(temp.inchesWater, 10)
    temp.inchesWater = 20
    XCTAssertEqual(temp.inchesWater, 20)
  }
  
  func test_converting_to_millibar() {
    XCTAssertEqual(Pressure.psi(112).millibar, 7722.128915714985)
    var temp = Pressure.millibar(10)
    XCTAssertEqual(temp.millibar, 10)
    temp.millibar = 20
    XCTAssertEqual(temp.millibar, 20)
  }
  
  func test_converting_to_pascals() {
    XCTAssertEqual(Pressure.inchesWater(0.4014624496868878).pascals, 100)
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
    XCTApproximatelyEqual(pressure.rawValue, 14.175, tolerance: 0.0024)
//    XCTAssertEqual(round(pressure.psi * 100) / 100, 14.17)
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
    
    pressure.inchesWater = 10
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
  
  // The values are tested against published table in ASHRAE 2017,
  // they are mostly within the margin of error of 300 ppm
  // recommended in ASHRAE 2017.
  func test_saturation_pressure_imperial() async {
    let tempsAndExpectation: [(Temperature, Pressure, Double)] = [
      (.fahrenheit(-76), .psi(0.000157), 0.00001),
      (.fahrenheit(-30), .psi(0.00344), 0.0003),
      (.fahrenheit(-4), .psi(0.014974), 0.0003),
      (.fahrenheit(23), .psi(0.058268), 0.0003),
      (.fahrenheit(32), .psi(0.08864), 0.0003),
      (.fahrenheit(41), .psi(0.12656), 0.0003),
      (.fahrenheit(56), .psi(0.22202), 0.0003),
      (.fahrenheit(77), .psi(0.45973), 0.0003),
      (.fahrenheit(122), .psi(1.79140), 0.0003),
      (.fahrenheit(212), .psi(14.7094), 0.0003),
      (.fahrenheit(300), .psi(67.0206), 0.014),
    ]
    
    for (temp, expected, tolerance) in tempsAndExpectation {
      let pressure = await SaturationPressure(at: temp, units: .imperial)
      XCTApproximatelyEqual(pressure.rawValue.rawValue, expected.rawValue, tolerance: tolerance)
    }
  }
  
  func test_saturation_pressure_metric() async {
    let tempsAndExpectation: [(Temperature, Pressure, Double)] = [
      (.celsius(-60), .pascals(1.08), 0.01),
      (.celsius(-20), .pascals(103.24), 0.024),
      (.celsius(-5), .pascals(401.74), 0.0242),
      (.celsius(5), .pascals(872.6), 0.114),
      (.celsius(25), .pascals(3169.7), 0.484),
      (.celsius(50), .pascals(12351.3), 1.444),
      (.celsius(100), .pascals(101418.0), 0.717),
      (.celsius(150), .pascals(476101.4), 96.476), // This is pretty far off.
    ]
    
    for (temp, expected, tolerance) in tempsAndExpectation {
      let pressure = await SaturationPressure(at: temp, units: .metric)
      XCTApproximatelyEqual(pressure.rawValue.rawValue, expected.rawValue, tolerance: tolerance)
    }
  }
  
  // FIXME
  func test_vapor_pressure_with_relativeHumidity_metric() async {
    let pressure = await VaporPressure(dryBulb: .celsius(25), humidity: 80%, units: .metric)
//    XCTApproximatelyEqual(pressure.rawValue, 2535.2, tolerance: 0.18)
    let humidity = await RelativeHumidity.init(dryBulb: .celsius(25), pressure: pressure, units: .metric)
    XCTApproximatelyEqual(humidity.rawValue, 80)
  }
}
