import XCTest
import Core

final class OperatorOverloadTests: XCTestCase {
  
  // Using `round` to use the global operator overload instead of the overload that
  // returns the `NumericType`.
  
  func test_addition() {
    let value: NumericTestType = 10
    XCTAssertEqual(10 + value, 20)
    XCTAssertEqual(round(value + 10), 20)
  }
  
  func test_subtraction() {
    let value: NumericTestType = 10
    XCTAssertEqual(30 - value, 20)
    XCTAssertEqual(round(value - 5), 5)
  }
  
  func test_multiplication() {
    let value: NumericTestType = 10
    XCTAssertEqual(2 * value, 20)
    XCTAssertEqual(round(value * 2), 20)
  }
  
  func test_division() {
    let value: NumericTestType = 10
    XCTAssertEqual(20 / value, 2)
    XCTAssertEqual(round(100 / value), 10)
  }
  
  func test_rawInitializable() {
    XCTAssertNotNil(NumericTestType.init(rawValue: 20))
  }
}

struct NumericTestType {
  var rawValue: Double
  
  init(_ value: Double) { self.rawValue = value }
}

extension NumericTestType: RawNumericType {
  typealias IntegerLiteralType = Double.IntegerLiteralType
  typealias FloatLiteralType = Double.FloatLiteralType
  typealias Magnitude = Double.Magnitude
}
