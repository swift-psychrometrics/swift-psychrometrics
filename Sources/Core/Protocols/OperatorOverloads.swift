import Foundation

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
