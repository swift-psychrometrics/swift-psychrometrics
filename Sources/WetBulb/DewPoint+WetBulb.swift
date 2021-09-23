import Core
import DewPoint
import Foundation
import HumidityRatio

//extension WetBulb {
//
//    public init(
//      dryBulb temperature: Temperature,
//      dewPoint: DewPoint,
//      pressure totalPressure: Pressure,
//      units: PsychrometricEnvironment.Units? = nil
//    ) {
//      precondition(dewPoint.rawValue < temperature)
//      let humidityRatio = HumidityRatio.init(
//        dryBulb: temperature, wetBulb: <#T##WetBulb#>, pressure: <#T##Pressure#>, units: <#T##PsychrometricEnvironment.Units?#>)
//    }
//}
extension DewPoint {

  public init(
    dryBulb temperature: Temperature,
    wetBulb: WetBulb,
    pressure: Pressure,
    units: PsychrometricEnvironment.Units? = nil
  ) {
    precondition(temperature > wetBulb.temperature)
    let humidityRatio = HumidityRatio(
      dryBulb: temperature, wetBulb: wetBulb, pressure: pressure, units: units)
    self.init(dryBulb: temperature, ratio: humidityRatio, pressure: pressure, units: units)
  }
}
