import Foundation

// Overload operators to work on Numeric types.  This avoids having to always reach into `Type.rawValue`
// for math operations.

public func * <T>(
  lhs: T.RawValue,
  rhs: T
)
  -> T.RawValue where T: RawNumericType, T.RawValue: NumericType
{
  lhs * rhs.rawValue
}

public func * <T>(
  lhs: T,
  rhs: T.RawValue
)
  -> T.RawValue where T: RawNumericType, T.RawValue: NumericType
{
  lhs.rawValue * rhs
}

public func + <T>(
  lhs: T.RawValue,
  rhs: T
)
  -> T.RawValue where T: RawNumericType, T.RawValue: NumericType
{
  lhs + rhs.rawValue
}

public func + <T>(
  lhs: T,
  rhs: T.RawValue
)
  -> T.RawValue where T: RawNumericType, T.RawValue: NumericType
{
  lhs.rawValue + rhs
}

public func - <T>(
  lhs: T.RawValue,
  rhs: T
)
  -> T.RawValue where T: RawNumericType, T.RawValue: NumericType
{
  lhs - rhs.rawValue
}

public func - <T>(
  lhs: T,
  rhs: T.RawValue
)
  -> T.RawValue where T: RawNumericType, T.RawValue: NumericType
{
  lhs.rawValue - rhs
}

public func / <T>(
  lhs: T.RawValue,
  rhs: T
)
  -> T.RawValue where T: RawNumericType, T.RawValue: NumericType
{
  lhs / rhs.rawValue
}

public func / <T>(
  lhs: T,
  rhs: T.RawValue
)
  -> T.RawValue where T: RawNumericType, T.RawValue: NumericType
{
  lhs.rawValue / rhs
}
