import DewPoint
import Enthalpy
import WetBulb
import Foundation

let formatter: NumberFormatter = {
  let f = NumberFormatter()
  f.numberStyle = .decimal
  f.maximumFractionDigits = 3
  f.groupingSeparator = ","
  return f
}()

func numberString(_ value: Double) -> String {
  formatter.string(for: value) ?? "\(value)"
}

extension Condition {
  var dewPoint: DewPoint {
    temperature.dewPoint(humidity: humidity)
  }
  
  var humidityRatio: Double {
    Enthalpy.humidityRatio(for: temperature, with: humidity, at: altitude)
  }
  
  var partialPressure: Pressure { .partialPressure(for: temperature, at: humidity) }
  
  var wetBulb: WetBulb { temperature.wetBulb(at: humidity) }
  
  var string: String {
    """
      Inputs:
        Temperature: \(numberString(temperature.fahrenheit)) °F
        Humidity: \(humidity.rawValue)%
        Altitude: \(altitude.rawValue)
    
      Results:
        Dew Point: \(numberString(dewPoint.fahrenheit)) °F
        Enthalpy: \(numberString(enthalpy.rawValue))
        Humidity Ratio: \(numberString(humidityRatio))
        Partial Pressure: \(numberString(partialPressure.psi)) psi
        Wet Bulb: \(numberString(wetBulb.fahrenheit)) °F
    
    """
  }
}

let returnConditions = Condition(temperature: 76.1, humidity: 58.3%)
let supplyConditions = Condition(temperature: 55, humidity: 91.2%)
let btus = totalDeliveredHeat(supply: supplyConditions, return: returnConditions, airflow: 1_000)

print("Return Conditions")
print(returnConditions.string)
print("Supply Conditions")
print(supplyConditions.string)
print("Delivered BTU: \(numberString(btus))")
func enthalpy(for temperature: Temperature, humidityRatio: Double) -> Double {
  0.24 * temperature.fahrenheit
    + humidityRatio
    * (1061 + 0.444 * temperature.fahrenheit)
}

func humidityRatio(from enthalpy: Double, and temperature: Temperature) -> Double {
  let c1 = (0.24 * temperature.fahrenheit)
  let c2 = (1061 + 0.444 * temperature.fahrenheit)
  return (enthalpy - c1) / c2
}

let expected = returnConditions.humidityRatio
let enthalpy = returnConditions.enthalpy.rawValue
let calculated = humidityRatio(from: enthalpy, and: returnConditions.temperature)
print(expected == calculated)
