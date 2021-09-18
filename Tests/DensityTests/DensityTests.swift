import XCTest
import Density
import Temperature
import Pressure

final class DensityTests: XCTestCase {
  
  func testDensityOfWater() {
    let density = Density.water(at: .fahrenheit(50))
    XCTAssertEqual(
      round(density.rawValue * 100) / 100,
      62.58
    )
  }
  
  func testDensityOfAir() {
    let density = Density.dryAir(at: .fahrenheit(60), pressure: .psi(0))
    XCTAssertEqual(
      round(density.rawValue * 1000) / 1000,
      0.076
    )
  }
}
