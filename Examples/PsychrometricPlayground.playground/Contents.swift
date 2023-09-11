import PlaygroundSupport
//import Psychrometrics
import Foundation
import PsychrometricClientLive
import _Concurrency

//extension PsychrometricResponse {
//  
//  static func imperialMock() async throws -> Self {
//    try await Self.init(
//      dryBulb: .fahrenheit(75),
//      humidity: 50%,
//      pressure: .init(altitude: .seaLevel, units: .imperial),
//      units: .imperial
//    )!
//  }
//  
//  static func metricMock() async throws -> Self {
//      try await Self.init(
//      dryBulb: .celsius(24),
//      humidity: 50%,
//      pressure: .pascals(101325),
//      units: .metric
//    )!
//  }
//}

let formatter: NumberFormatter = {
  let f = NumberFormatter()
  f.numberStyle = .decimal
  f.maximumFractionDigits = 4
  return f
}()

extension Double {
  
  var numberString: String {
    formatter.string(for: self) ?? "\(self)"
  }
}

@MainActor
func printPsychrometrics(_ psychrometrics: PsychrometricProperties, units: PsychrometricUnits) {
  let message = """

  Psychrometrics - \(units == .metric ? "Metric" : "Imperial")
  ------------------------------------
  
  Dry Bulb:               \(psychrometrics.dryBulb.value.numberString) \(psychrometrics.dryBulb.units.rawValue)
  Dew Point:              \(psychrometrics.dewPoint.value.numberString) \(psychrometrics.dewPoint.units.rawValue)
  Wet Bulb:               \(psychrometrics.wetBulb.value.numberString) \(psychrometrics.wetBulb.units.rawValue)
  Relative Humidity:      \(psychrometrics.relativeHumidity.rawValue.rawValue.numberString)%
  Humidity Ratio:         \(psychrometrics.humidityRatio.rawValue.rawValue.numberString)
  Degree of Saturation:   \(psychrometrics.degreeOfSaturation.value.numberString)
  Atmospheric Pressure:   \(psychrometrics.atmosphericPressure.value.numberString) \(psychrometrics.atmosphericPressure.units.rawValue)
  Vapor Pressure:         \(psychrometrics.vaporPressure.value.numberString) \(psychrometrics.vaporPressure.units.rawValue)
  Volume:                 \(psychrometrics.specificVolume.rawValue.numberString) \(psychrometrics.specificVolume.units.rawValue)
  Density:                \(psychrometrics.density.value.numberString) \(psychrometrics.density.units.rawValue)
  Enthalpy:               \(psychrometrics.enthalpy.rawValue.rawValue.numberString) \(psychrometrics.enthalpy.units.rawValue)

  """
  
  print(message)
}

//let imperial = try await PsychrometricResponse.imperialMock()
let imperial = try await withDependencies {
  $0.psychrometricClient = .liveValue
} operation: {
  @Dependency(\.psychrometricClient) var client;
  return try await client.psychrometricProperties(.dryBulb(75, relativeHumidity: 50%))
}

printPsychrometrics(imperial, units: PsychrometricUnits.imperial)

PlaygroundPage.current.needsIndefiniteExecution = true
//printPsychrometrics(metric, units: PsychrometricUnits.metric)

//let enthalpy1 = try? await MoistAirEnthalpy.init(dryBulb: 75, humidity: 50%)
//let enthalpy2 = try? await MoistAirEnthalpy.init(dryBulb: 93, humidity: 30%)
