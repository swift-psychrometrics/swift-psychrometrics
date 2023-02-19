public protocol RouteKey: CustomStringConvertible, CaseIterable { }

extension RouteKey where Self: RawRepresentable, Self.RawValue == String {
  
  public var description: String { rawValue }
}
