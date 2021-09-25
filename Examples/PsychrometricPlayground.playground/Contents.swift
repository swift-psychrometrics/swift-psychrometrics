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
  
  Dew Point:              \(psychrometrics.dewPoint.rawValue.numberString)
  Wet Bulb:               \(psychrometrics.wetBulb.rawValue.numberString)
  Relative Humidity:      \(psychrometrics.relativeHumidity.rawValue.numberString)
  Humidity Ratio:         \(psychrometrics.humidityRatio.rawValue.numberString)
  Degree of Saturation:   \(psychrometrics.degreeOfSaturation.numberString)
  Vapor Pressure:         \(psychrometrics.vaporPressure.rawValue.numberString)
  Volume:                 \(psychrometrics.volume.rawValue.numberString)
  Enthalpy:               \(psychrometrics.enthalpy.rawValue.numberString)
  
  """
  
  print(message)
}

printPsychrometrics(.imperialMock, units: .imperial)
printPsychrometrics(.metricMock, units: .metric)
