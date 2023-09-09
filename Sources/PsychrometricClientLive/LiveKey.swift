import Dependencies
import Foundation
@_exported import PsychrometricClient
import PsychrometricEnvironment
import SharedModels

extension PsychrometricClient: DependencyKey {
  
  public static func live(environment: PsychrometricEnvironment) -> PsychrometricClient {
    PsychrometricClient.init(
      density: DensityClient(
        dryAir: { await $0.density(environment: environment) },
        moistAir: { try await $0.density(environment: environment) },
        water: { await waterDensity($0, environment: environment) }
      ),
      dewPoint: { await $0.dewPoint(environment: environment) },
      enthalpy: EnthalpyClient(
        dryAir: { await $0.enthalpy(environment: environment) },
        moistAir: { await $0.enthalpy(environment: environment) }
      ),
      grainsOfMoisture: { try await $0.grainsOfMoisture(environment: environment) },
      humidityRatio: { try await $0.humidityRatio(environment: environment) },
      relativeHumidity: { try await $0.relativeHumdity(environment: environment) },
      saturationPressure: { try await $0.saturationPressure(environment: environment) },
      specificHeat: .init(
        water: { temperature in
          fatalError()
        }
      ),
      specificHumidity: { request in
        fatalError()
      },
      specificVolume: SpecificVolumeClient(
        dryAir: { request in
          fatalError()
        },
        moistAir: { request in
          fatalError()
        }
      ),
      vaporPressure: { request in
        fatalError()
      }
    )
  }
  
  public static var liveValue: PsychrometricClient {
    @Dependency(\.psychrometricEnvironment) var environment;
    return .live(environment: environment)
  }
}
