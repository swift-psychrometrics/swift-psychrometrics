import Psychrometrics
import Foundation

extension Psychrometrics {
  
  static var imperialMock: Self {
    Self.init(
      dryBulb: .fahrenheit(75),
      humidity: 50%,
      pressure: .init(altitude: .seaLevel, units: .imperial),
      units: .imperial
    )!
  }
  
  static var metricMock: Self {
    Self.init(
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

func printPsychrometrics(_ psychrometrics: Psychrometrics, units: PsychrometricEnvironment.Units) {
  let message = """

  Psychrometrics - \(units == .metric ? "Metric" : "Imperial")
  ------------------------------------
  
  Dry Bulb:               \(psychrometrics.dryBulb.rawValue.numberString) \(psychrometrics.dryBulb.units.rawValue)
  Dew Point:              \(psychrometrics.dewPoint.rawValue.numberString) \(psychrometrics.dewPoint.units.rawValue)
  Wet Bulb:               \(psychrometrics.wetBulb.rawValue.numberString) \(psychrometrics.wetBulb.units.rawValue)
  Relative Humidity:      \(psychrometrics.relativeHumidity.rawValue.numberString)%
  Humidity Ratio:         \(psychrometrics.humidityRatio.rawValue.numberString)
  Degree of Saturation:   \(psychrometrics.degreeOfSaturation.numberString)
  Atmospheric Pressure:   \(psychrometrics.atmosphericPressure.rawValue.numberString) \(psychrometrics.atmosphericPressure.units.rawValue)
  Vapor Pressure:         \(psychrometrics.vaporPressure.rawValue.numberString) \(psychrometrics.vaporPressure.units.rawValue)
  Volume:                 \(psychrometrics.volume.rawValue.numberString) \(psychrometrics.volume.units.rawValue)
  Density:                \(psychrometrics.density.rawValue.numberString) \(psychrometrics.density.units.rawValue)
  Enthalpy:               \(psychrometrics.enthalpy.rawValue.numberString) \(psychrometrics.enthalpy.units.rawValue)
  
  """
  
  print(message)
}

printPsychrometrics(.imperialMock, units: .imperial)
printPsychrometrics(.metricMock, units: .metric)
