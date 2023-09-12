import Foundation
import SharedModels

extension Pressure {

  subscript(psychrometricUnits: PsychrometricUnits) -> Double {
    switch psychrometricUnits {
    case .imperial: return psi
    case .metric: return pascals
    }
  }
}

extension Temperature {
  subscript(psychrometricUnits: PsychrometricUnits) -> Double {
    switch psychrometricUnits {
    case .imperial: return rankine
    case .metric: return kelvin
    }
  }
}
