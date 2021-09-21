import XCTest
import Density
import Core

final class DensityTests: XCTestCase {
  
  func testDensityOfWater() {
    let density = Density.water(at: .fahrenheit(50))
    XCTAssertEqual(
      round(density.rawValue * 100) / 100,
      62.58
    )
  }
  
  func testDensityOfAir() {
    let density = Density.dryAir(at: .fahrenheit(60), pressure: .psi(14.7))
    XCTAssertEqual(
      round(density.rawValue * 1000) / 1000,
      0.076
    )
    let density2 = Density.dryAir(at: .fahrenheit(60), altitude: .seaLevel)
    XCTAssertEqual(
      round(density2.rawValue * 1000) / 1000,
      0.076
    )
  }
  
  func testDensityUnit() {
    XCTAssertEqual(DensityUnit.dryAir.label, "Dry Air")
    XCTAssertEqual(DensityUnit.water.label, "Water")
  }
}
