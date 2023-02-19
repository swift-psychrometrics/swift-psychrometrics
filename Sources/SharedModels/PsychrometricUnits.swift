/// Represents unit of measure used in calculations [SI] or [IP].
public enum PsychrometricUnits: String, CaseIterable, Codable, Sendable {

  case metric, imperial

  /// Convenience for telling if the units are imperial units.
  public var isImperial: Bool { self == .imperial }
}
