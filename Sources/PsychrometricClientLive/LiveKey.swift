import Dependencies
import Foundation
@_exported import PsychrometricClient
import PsychrometricEnvironment
import SharedModels

extension PsychrometricClient: DependencyKey {
  
  public static func live(environment: PsychrometricEnvironment) -> PsychrometricClient {
    PsychrometricClient.init(
      degreeOfSaturation: { try await $0.degreeOfSaturation(environment: environment) },
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
        water: { await $0.waterSpecificHeat() }
      ),
      specificHumidity: { await $0.specificHumidity(environment: environment) },
      specificVolume: SpecificVolumeClient(
        dryAir: { await $0.specificVolume(environment: environment) },
        moistAir: { await $0.specificVolume(environment: environment) }
      ),
      vaporPressure: { try await $0.vaporPressure(environment: environment) },
      wetBulb: { try await $0.wetBulb(environment: environment) }
    )
  }
  
  public static var liveValue: PsychrometricClient {
    @Dependency(\.psychrometricEnvironment) var environment;
    return .live(environment: environment)
  }
}
