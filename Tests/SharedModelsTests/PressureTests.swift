import Dependencies
import PsychrometricClientLive
import SharedModels
import TestSupport
import XCTest

final class PressureTests: XCTestCase {

  override func invokeTest() {
    withDependencies {
      $0.psychrometricClient = .liveValue
    } operation: {
      super.invokeTest()
    }
  }

  func test_converting_to_atmosphere() {
    XCTAssertEqual(TotalPressure.atmosphere(10).atmosphere, 10)
    XCTAssertEqual(TotalPressure.psi(10).atmosphere, 0.6804596377991787)
    XCTAssertEqual(TotalPressure.bar(10).atmosphere, 9.8692316931427)
    XCTAssertEqual(TotalPressure.inchesWater(10).atmosphere, 0.0245832)
    XCTAssertEqual(TotalPressure.millibar(10).atmosphere, 0.0098692316931427)
    XCTAssertEqual(TotalPressure.pascals(10).atmosphere, 9.869231693142701e-5)
    XCTAssertEqual(TotalPressure.psi(10).atmosphere, 0.6804596377991787)
    XCTAssertEqual(TotalPressure.torr(10).atmosphere, 0.013157893594088999)

    var temp = TotalPressure.atmosphere(10)
    XCTAssertEqual(temp.atmosphere, 10)
    temp.atmosphere = 20
    XCTAssertEqual(temp.atmosphere, 20)
  }

  func test_converting_to_bar() {
    XCTAssertEqual(TotalPressure.torr(42).bar, 0.0559953954000001)

    var temp = TotalPressure.bar(10)
    XCTAssertEqual(temp.bar, 10)
    temp.bar = 20
    XCTAssertEqual(temp.bar, 20)
  }

  func test_converting_to_inchesWaterColumn() {
    XCTAssertEqual(TotalPressure.pascals(100).inchesWater, 0.4014624496868878)
    var temp = TotalPressure.inchesWater(10)
    XCTAssertEqual(temp.inchesWater, 10)
    temp.inchesWater = 20
    XCTAssertEqual(temp.inchesWater, 20)
  }

  func test_converting_to_millibar() {
    XCTAssertEqual(TotalPressure.psi(112).millibar, 7722.128915714985)
    var temp = TotalPressure.millibar(10)
    XCTAssertEqual(temp.millibar, 10)
    temp.millibar = 20
    XCTAssertEqual(temp.millibar, 20)
  }

  func test_converting_to_pascals() {
    XCTAssertEqual(TotalPressure.inchesWater(0.4014624496868878).pascals, 100)
    var temp = TotalPressure.pascals(10)
    XCTAssertEqual(temp.pascals, 10)
    temp.pascals = 20
    XCTAssertEqual(temp.pascals, 20)
  }

  func test_converting_to_psig() {
    XCTAssertEqual(TotalPressure.atmosphere(13).psi, 191.04733444655298)
    var temp = TotalPressure.psi(10)
    XCTAssertEqual(temp.psi, 10)
    temp.psi = 20
    XCTAssertEqual(temp.psi, 20)
  }

  func test_converting_to_torr() {
    XCTAssertEqual(TotalPressure.bar(0.0559953954000001).torr, 42)
    var temp = TotalPressure.torr(10)
    XCTAssertEqual(temp.torr, 10)
    temp.torr = 20
    XCTAssertEqual(temp.torr, 20)
  }

  func test_pressure_for_altitude() {
    let pressure = TotalPressure(altitude: .feet(1000))
    XCTApproximatelyEqual(pressure.rawValue, 14.175, tolerance: 0.0024)
    //    XCTAssertEqual(round(pressure.psi * 100) / 100, 14.17)
  }

  func test_comparable() {
    XCTAssertTrue(TotalPressure.psi(10) > 5)
  }

  func test_equality() {
    XCTAssertEqual(TotalPressure.psi(14.695948803580999), TotalPressure.atmosphere(1))
  }

  func test_addition_and_subtraction() {
    var pressure: TotalPressure = 20.1
    XCTAssertEqual(pressure.psi, 20.1)
    pressure += 10
    XCTAssertEqual(pressure.psi, 30.1)
    pressure -= 5
    XCTAssertEqual(pressure.psi, 25.1)
  }

  func test_multiplication() {
    var pressure: TotalPressure = .init(exactly: 10)! * 10
    XCTAssertEqual(pressure.psi, 100)
    pressure *= 2
    XCTAssertEqual(pressure.psi, 200)
  }

  //  func test_magnitude() {
  //    XCTAssertEqual(Pressure.psi(100).magnitude, 100.magnitude)
  //  }

  func test_PressureUnit_symbol() {
    XCTAssertEqual(PressureUnit.atmosphere.symbol, "atm")
    XCTAssertEqual(PressureUnit.bar.symbol, "bar")
    XCTAssertEqual(PressureUnit.inchesWater.symbol, "inH2O")
    XCTAssertEqual(PressureUnit.millibar.symbol, "mb")
    XCTAssertEqual(PressureUnit.pascals.symbol, "Pa")
    XCTAssertEqual(PressureUnit.psi.symbol, "psi")
    XCTAssertEqual(PressureUnit.torr.symbol, "torr")
  }

  func test_PressureUnit_pressureKeyPath() {
    var pressure = TotalPressure.atmosphere(10)
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
  func test_saturation_pressure_imperial() async throws {
    @Dependency(\.psychrometricClient) var client

    let tempsAndExpectation: [(DryBulb, TotalPressure, Double)] = [
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
      let pressure = try await client.saturationPressure(.dryBulb(temp, units: .imperial))
      XCTApproximatelyEqual(pressure.value, expected.value, tolerance: tolerance)
    }
  }

  func test_saturation_pressure_metric() async throws {
    @Dependency(\.psychrometricClient) var client

    let tempsAndExpectation: [(DryBulb, TotalPressure, Double)] = [
      (.celsius(-60), .pascals(1.08), 0.01),
      (.celsius(-20), .pascals(103.24), 0.024),
      (.celsius(-5), .pascals(401.74), 0.0242),
      (.celsius(5), .pascals(872.6), 0.114),
      (.celsius(25), .pascals(3169.7), 0.484),
      (.celsius(50), .pascals(12351.3), 1.444),
      (.celsius(100), .pascals(101418.0), 0.717),
      (.celsius(150), .pascals(476101.4), 96.476),  // This is pretty far off.
    ]

    for (temp, expected, tolerance) in tempsAndExpectation {
      let pressure = try await client.saturationPressure(.dryBulb(temp, units: .metric))
      XCTApproximatelyEqual(pressure.value, expected.value, tolerance: tolerance)
    }
  }

  // FIXME
  //  func test_vapor_pressure_with_relativeHumidity_metric() async throws {
  //    let pressure = try await VaporPressure(dryBulb: .celsius(25), humidity: 80%, units: .metric)
  ////    XCTApproximatelyEqual(pressure.rawValue, 2535.2, tolerance: 0.18)
  //    let humidity = try await RelativeHumidity.init(dryBulb: .celsius(25), pressure: pressure, units: .metric)
  //    XCTApproximatelyEqual(humidity.rawValue, 80)
  //  }
}
