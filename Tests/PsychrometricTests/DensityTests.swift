import XCTest
import Psychrometrics
import SharedModels
import TestSupport

final class DensityTests: XCTestCase {
  
  func testDensityOfWater() async {
    let density = await DensityOf<Water>(for: .fahrenheit(50))
    XCTAssertEqual(
      round(density.rawValue * 100) / 100,
      62.58
    )
  }
  
  func testDensityOfAir_imperial() async {
    let density = await DensityOf<DryAir>(for: .fahrenheit(60), pressure: .psi(14.7))
    XCTAssertEqual(
      round(density.rawValue * 1000) / 1000,
      0.076
    )
    let density2 = await DensityOf<DryAir>(for: .fahrenheit(60), altitude: .seaLevel)
    XCTAssertEqual(
      round(density2.rawValue * 1000) / 1000,
      0.076
    )
  }
  
  func test_density_of_dryAir_metric() async {
    let density = await DensityOf<DryAir>.init(
      for: .celsius(25),
      pressure: .pascals(101325),
      units: .metric
    )
    XCTApproximatelyEqual(density.rawValue, 1.18441, tolerance: 0.003)
  }
  
  func test_density_of_moistAir_metric() async {
    let density = await DensityOf<MoistAir>.init(
      dryBulb: .celsius(30),
      ratio: 0.02,
      pressure: .pascals(95461),
      units: .metric
    )
    XCTApproximatelyEqual(density, 1.08411986348219, tolerance: 0.0003)
  }

}
