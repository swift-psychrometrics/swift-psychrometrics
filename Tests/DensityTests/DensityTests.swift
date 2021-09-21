import XCTest
import Density
import Core
import SpecificVolume
import HumidityRatio

final class DensityTests: XCTestCase {
  
  func testDensityOfWater() {
    let density = DensityOf<Water>(for: .fahrenheit(50))
    XCTAssertEqual(
      round(density.rawValue * 100) / 100,
      62.58
    )
  }
  
  func testDensityOfAir() {
    let density = DensityOf<DryAir>(for: .fahrenheit(60), pressure: .psi(14.7))
    XCTAssertEqual(
      round(density.rawValue * 1000) / 1000,
      0.076
    )
    let density2 = DensityOf<DryAir>(for: .fahrenheit(60), altitude: .seaLevel)
    XCTAssertEqual(
      round(density2.rawValue * 1000) / 1000,
      0.076
    )
  }
  
  func testDensityOfMoistAir() {
    let pressure: Pressure = 14.270
    let ratio = HumidityRatio(for: 72.9, at: 72.5%, pressure: pressure)
    let volume = SpecificVolume(for: 72.9, ratio: ratio, pressure: pressure)
    let density = DensityOf<MoistAir>(volume: volume, ratio: ratio)
    XCTAssertEqual(
      round(density * 1000) / 1000,
      0.072
    )
  }
  
//  func testDensityUnit() {
//    XCTAssertEqual(DensityUnit.dryAir.label, "Dry Air")
//    XCTAssertEqual(DensityUnit.water.label, "Water")
//  }
}
