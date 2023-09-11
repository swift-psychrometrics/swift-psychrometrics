import Foundation
@_exported import Tagged

extension Tagged {

  public subscript<T>(dynamicMember keyPath: WritableKeyPath<RawValue, T>) -> T {
    get { self.rawValue[keyPath: keyPath] }
    set { self.rawValue[keyPath: keyPath] = newValue }
  }
}
