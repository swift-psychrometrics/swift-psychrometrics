import SharedModels
import XCTest

final class RelativeHumidityTests: XCTestCase {

  func test_addition_and_subtraction() {
    var humidity: RelativeHumidity = .zero
    XCTAssertEqual(humidity.rawValue, 0)
    humidity += 10
    XCTAssertEqual(humidity.rawValue, 10)
    humidity -= 5
    XCTAssertEqual(humidity.rawValue, 5)
  }

  func test_comparable() {
    XCTAssertTrue(50.0% > 40%)
  }

  func test_magnitude() {
    XCTAssertEqual(10.1.magnitude, RelativeHumidity.init(floatLiteral: 10.1).magnitude)
  }

  func test_multiplication() {
    var humidity: RelativeHumidity = .init(exactly: 10)!
    XCTAssertEqual(humidity.fraction, 0.1)
    humidity *= 2
    XCTAssertEqual(humidity.rawValue, 20)

    let humidity2: RelativeHumidity = 10 * 2
    XCTAssertEqual(humidity2.rawValue, 20)
  }
}
