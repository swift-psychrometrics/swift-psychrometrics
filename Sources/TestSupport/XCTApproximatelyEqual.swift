#if DEBUG
  import XCTest

  public func XCTApproximatelyEqual(
    _ lhs: Double,
    _ rhs: Double,
    tolerance: Double = 1e-6,
    message: String = "",
    file: StaticString = #file,
    line: UInt = #line
  ) {
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
#endif
