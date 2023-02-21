import SharedModels
import URLRouting

enum PathKey: String, RouteKey {
  case altitude
  case density
  case dewPoint
  case dryAir
  case enthalpy
  case grainsOfMoisture
  case humidityRatio
  case moistAir
  case pressure
  case psychrometrics
  case relativeHumidity
  case saturation
  case specificHeat
  case specificHumidity
  case specificVolume
  case temperature
  case totalPressure
  case vapor
  case vaporPressure
  case water
  case wetBulb
}

extension Path where ComponentParsers == PathBuilder.Component<String> {
  init(_ key: PathKey) {
    self.init {
      key.description
    }
  }
}
