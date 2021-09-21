import XCTest
import Core
import SpecificVolume

final class SpecificVolumeTests: XCTestCase {
  func test_specificVolume() {
    let volume = SpecificVolume(for: 75, at: 100%, altitude: .seaLevel)
    XCTAssertEqual(round(volume * 100) / 100, 13.89)
    XCTAssertEqual(
      round(SpecificVolume(for: 76.1, at: 58.3%, altitude: .seaLevel) * 100) / 100,
      13.75
    )
  }
}
