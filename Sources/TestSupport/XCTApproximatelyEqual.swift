#if DEBUG
  import XCTest

  public func XCTApproximatelyEqual<T>(
    _ lhs: T,
    _ rhs: T,
    tolerance: T,
    message: String = "",
    file: StaticString = #file,
    line: UInt = #line
  ) where T: Numeric, T: Comparable {
    if lhs == rhs { return }
    let greaterValue = lhs > rhs ? lhs : rhs
    let lesserValue = lhs > rhs ? rhs : lhs
    let diff = greaterValue - lesserValue

    var message = message

    if message == "" {
      message = """


        lhs: \(lhs)
        rhs: \(rhs)
        tolerance: \(tolerance)
        diff: \(diff)

        """
    }

    XCTAssertTrue(diff <= tolerance, message, file: file, line: line)
  }

  public func XCTApproximatelyEqual<T>(
    _ lhs: T,
    _ rhs: T,
    message: String = "",
    file: StaticString = #file,
    line: UInt = #line
  ) where T: Numeric, T: Comparable, T: ExpressibleByFloatLiteral, T.FloatLiteralType == Double {
    XCTApproximatelyEqual(lhs, rhs, tolerance: 1e-6, file: file, line: line)
  }
#endif
