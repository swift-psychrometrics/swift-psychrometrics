import Dependencies
import PsychrometricClientLive
import SharedModels
import XCTest

final class GrainsOfMoistureTests: PsychrometricTestCase {
  
  func test_grains() async throws {
    @Dependency(\.psychrometricClient) var client;
    let grains = try await client.grainsOfMoisture(.dryBulb(
      .fahrenheit(75),
      relativeHumidity: 50%
    ))
    XCTAssertEqual(round(grains.rawValue * 100) / 100, 65.91)
  }
  
  func test_comparable() {
    XCTAssertTrue(GrainsOfMoisture.init(exactly: 28)! > 26)
  }
  
  func test_addition_and_subtraction() {
    var grains = GrainsOfMoisture.init(10)
    grains += 10
    XCTAssertEqual(grains.rawValue, 20)
    grains -= 5
    XCTAssertEqual(grains.rawValue, 15)
  }
  
  func test_magnitude() {
    XCTAssertEqual(GrainsOfMoisture.init(10).magnitude, 10.magnitude)
  }
  
  func test_multiplication() {
    var grains: GrainsOfMoisture = 10 * 3
    XCTAssertEqual(grains.rawValue, 30)
    grains *= 2
    XCTAssertEqual(grains.rawValue, 60)
  }
}
