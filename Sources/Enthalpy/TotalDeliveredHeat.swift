import Foundation
import Temperature
import RelativeHumidity
import Length

public struct Condition {
  
  public var temperature: Temperature
  public var humidity: RelativeHumidity
  public var altitude: Length
  
  public var enthalpy: Enthalpy { temperature.enthalpy(at: humidity, altitude: altitude) }
  
  public init(
    temperature: Temperature,
    humidity: RelativeHumidity,
    altitude: Length = .seaLevel
  ) {
    self.temperature = temperature
    self.humidity = humidity
    self.altitude = altitude
  }
}

public struct ConditionEnvelope {
  
  public var `return`: Condition
  public var supply: Condition
  
  public init(return: Condition, supply: Condition) {
    self.return = `return`
    self.supply = supply
  }
}

public func totalDeliveredHeat(_ lhs: Enthalpy, _ rhs: Enthalpy, airflow cfm: Double) -> Double {
  let deltaE = lhs > rhs
    ? lhs - rhs
    : rhs - lhs
  return 4.5 * deltaE.rawValue * cfm
}

public func totalDeliveredHeat(_ conditions: ConditionEnvelope, airflow cfm: Double) -> Double {
  totalDeliveredHeat(conditions.return.enthalpy, conditions.supply.enthalpy, airflow: cfm)
}

public func totalDeliveredHeat(
  supply supplyCondition: Condition,
  return returnCondition: Condition,
  airflow cfm: Double
) -> Double {
  totalDeliveredHeat(.init(return: returnCondition, supply: supplyCondition), airflow: cfm)
}
