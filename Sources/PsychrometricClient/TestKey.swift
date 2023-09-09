import Dependencies
import Foundation
import SharedModels
import XCTestDynamicOverlay

extension DependencyValues {
  public var psychrometricClient: PsychrometricClient {
    get { self[PsychrometricClient.self] }
    set { self[PsychrometricClient.self] = newValue }
  }
}

extension PsychrometricClient: TestDependencyKey {

  public static let testValue: Self = Self.init(
    density: .init(
      dryAir: unimplemented("\(Self.self).density.dryAir", placeholder: .zero),
      moistAir: unimplemented("\(Self.self).density.moistAir", placeholder: .zero),
      water: unimplemented("\(Self.self).density.water", placeholder: .zero)
    ),
    dewPoint: unimplemented("\(Self.self).dewPoint", placeholder: .zero),
    enthalpy: .init(
      dryAir: unimplemented("\(Self.self).enthalpy.dryAir", placeholder: .zero),
      moistAir: unimplemented("\(Self.self).enthalpy.moistAir", placeholder: .zero)
    ),
    grainsOfMoisture: unimplemented("\(Self.self).grainsOfMoisture", placeholder: .zero),
    humidityRatio: unimplemented("\(Self.self).humidityRatio", placeholder: .zero),
    relativeHumidity: unimplemented("\(Self.self).relativeHumidity", placeholder: 0%),
    saturationPressure: unimplemented("\(Self.self).saturationPressure", placeholder: .zero),
    specificHeat: .init(
      water: unimplemented("\(Self.self).specificHeat.water", placeholder: .zero)
    ),
    specificHumidity: unimplemented("\(Self.self).specificHumidity", placeholder: .zero),
    specificVolume: .init(
      dryAir: unimplemented("\(Self.self).specificVolume.dryAir", placeholder: .zero),
      moistAir: unimplemented("\(Self.self).specificVolume.moistAir", placeholder: .zero)
    ),
    vaporPressure: unimplemented("\(Self.self).vaporPressure", placeholder: .zero),
    wetBulb: unimplemented("\(Self.self).wetBulb", placeholder: .zero)
  )
}
