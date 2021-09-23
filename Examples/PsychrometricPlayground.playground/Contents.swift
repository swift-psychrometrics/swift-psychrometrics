import Core
import DewPoint
import Enthalpy
import HumidityRatio
import SpecificVolume
import WetBulb
import Foundation

struct Psychrometrics {
  
  let humidityRatio: HumidityRatio
//  let wetBulb: WetBulb
  let dewPoint: DewPoint
  let relativeHumidity: RelativeHumidity
  let vaporPressure: Pressure
  let enthalpy: EnthalpyOf<MoistAir>
  let volume: SpecificVolumeOf<MoistAir>
  
  init(dryBulb: Temperature, wetBulb: WetBulb, pressure: Pressure) {
    self.humidityRatio = .init(dryBulb: dryBulb, wetBulb: wetBulb, pressure: pressure, units: .imperial)
//    self.wetBulb = .init(temperature: dryBulb, humidity: humidity)
    self.dewPoint = .init(dryBulb: dryBulb, ratio: self.humidityRatio, pressure: pressure, units: .imperial)
    self.relativeHumidity = .init(dryBulb: dryBulb, ratio: self.humidityRatio, pressure: pressure, units: .imperial)
    self.vaporPressure = .init(ratio: self.humidityRatio, pressure: pressure, units: .imperial)
    self.enthalpy = .init(dryBulb: dryBulb, ratio: self.humidityRatio, units: .imperial)
    self.volume = .init(dryBulb: dryBulb, ratio: self.humidityRatio, pressure: pressure, units: .imperial)
  }
}
//
//let psychrometrics = Psychrometrics(dryBulb: 32.02, wetBulb: 65, pressure: 14.696)
//print(abs(psychrometrics.humidityRatio.rawValue))
//print(psychrometrics.dewPoint)
//print(psychrometrics.relativeHumidity)
//print(psychrometrics.vaporPressure)
//print(psychrometrics.enthalpy)
//print(psychrometrics.volume)
print(Pressure.saturationPressure(at: 34, units: .imperial))
print(Pressure.saturationPressure(at: .celsius(34), units: .metric).rawValue / 1000)
