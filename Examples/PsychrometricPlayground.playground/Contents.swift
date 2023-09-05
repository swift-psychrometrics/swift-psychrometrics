import PlaygroundSupport
import Psychrometrics
import Foundation

extension PsychrometricResponse {
  
  static func imperialMock() async throws -> Self {
    try await Self.init(
      dryBulb: .fahrenheit(75),
      humidity: 50%,
      pressure: .init(altitude: .seaLevel, units: .imperial),
      units: .imperial
    )!
  }
  
  static func metricMock() async throws -> Self {
      try await Self.init(
      dryBulb: .celsius(24),
      humidity: 50%,
      pressure: .pascals(101325),
      units: .metric
    )!
  }
}

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

func printPsychrometrics(_ psychrometrics: PsychrometricResponse, units: PsychrometricUnits) {
  let message = """

  Psychrometrics - \(units == .metric ? "Metric" : "Imperial")
  ------------------------------------
  
  Dry Bulb:               \(psychrometrics.dryBulb.rawValue.numberString) \(psychrometrics.dryBulb.units.rawValue)
  Dew Point:              \(psychrometrics.dewPoint.rawValue.rawValue.numberString) \(psychrometrics.dewPoint.units.rawValue)
  Wet Bulb:               \(psychrometrics.wetBulb.rawValue.rawValue.numberString) \(psychrometrics.wetBulb.units.rawValue)
  Relative Humidity:      \(psychrometrics.relativeHumidity.rawValue.rawValue.numberString)%
  Humidity Ratio:         \(psychrometrics.humidityRatio.rawValue.rawValue.numberString)
  Degree of Saturation:   \(psychrometrics.degreeOfSaturation.numberString)
  Atmospheric Pressure:   \(psychrometrics.atmosphericPressure.rawValue.numberString) \(psychrometrics.atmosphericPressure.units.rawValue)
  Vapor Pressure:         \(psychrometrics.vaporPressure.rawValue.rawValue.numberString) \(psychrometrics.vaporPressure.units.rawValue)
  Volume:                 \(psychrometrics.volume.rawValue.numberString) \(psychrometrics.volume.units.rawValue)
  Density:                \(psychrometrics.density.rawValue.numberString) \(psychrometrics.density.units.rawValue)
  Enthalpy:               \(psychrometrics.enthalpy.rawValue.rawValue.numberString) \(psychrometrics.enthalpy.units.rawValue)
  
  """
  
  print(message)
}

//let imperial = try await PsychrometricResponse.imperialMock()
//let metric = try await PsychrometricResponse.metricMock()

//
//printPsychrometrics(imperial, units: PsychrometricUnits.imperial)
//printPsychrometrics(metric, units: PsychrometricUnits.metric)

let enthalpy1 = try? await MoistAirEnthalpy.init(dryBulb: 75, humidity: 50%)
let enthalpy2 = try? await MoistAirEnthalpy.init(dryBulb: 93, humidity: 30%)
