import ConsoleKit
import Core
import Enthalpy
import Foundation

@available(macOS 10.15, *)
struct TotalHeatCommand: Command {

  struct Signature: CommandSignature {
    @Option(name: "return-temperature", help: "The return temperature.")
    var returnTemperature: Double?

    @Option(name: "return-humidity", help: "The return humidity.")
    var returnHumidity: Double?

    @Option(name: "supply-temperature", help: "The supply temperature.")
    var supplyTemperature: Double?

    @Option(name: "supply-humidity", help: "The supply humidity.")
    var supplyHumidity: Double?

    @Option(name: "altitude", help: "The altitude.")
    var altitude: Double?

    @Option(name: "cfm", help: "The cfms of airflow")
    var cfm: Double?
  }

  var help: String {
    "Calculate the total delivered heat quantity for the given conditions."
  }

  func run(using context: CommandContext, signature: Signature) throws {
    var returnTemperature: Double
    if let returnTemperatureInput = signature.returnTemperature {
      returnTemperature = returnTemperatureInput
    } else {
      let tempNumString = context.console.ask("What is the return temperature:")
      returnTemperature = Double(tempNumString) ?? 0
    }

    var returnHumidity: Double
    if let inputHumidity = signature.returnHumidity {
      returnHumidity = inputHumidity
    } else {
      let humidityNumString = context.console.ask("What is the return humidity:")
      returnHumidity = Double(humidityNumString) ?? 0
    }

    var supplyTemperature: Double
    if let supplyTemperatureInput = signature.supplyTemperature {
      supplyTemperature = supplyTemperatureInput
    } else {
      let tempNumString = context.console.ask("What is the supply temperature:")
      supplyTemperature = Double(tempNumString) ?? 0
    }

    var supplyHumidity: Double
    if let inputHumidity = signature.supplyHumidity {
      supplyHumidity = inputHumidity
    } else {
      let humidityNumString = context.console.ask("What is the supply humidity:")
      supplyHumidity = Double(humidityNumString) ?? 0
    }

    let altitude: Double
    if let altitudeInput = signature.altitude {
      altitude = altitudeInput
    } else {
      let altitudeString = context.console.ask("What is the altitude:")
      altitude = Double(altitudeString) ?? 0
    }

    let cfm: Double
    if let cfmInput = signature.cfm {
      cfm = cfmInput
    } else {
      let cfmString = context.console.ask("What is the CFM:")
      cfm = Double(cfmString) ?? 0
    }

    let conditions = ConditionEnvelope(
      return: .init(temperature: .init(returnTemperature), humidity: .init(returnHumidity)),
      supply: .init(temperature: .init(supplyTemperature), humidity: .init(supplyHumidity))
    )

    context.console.output("")
    context.console.output("Input Conditions:", style: .init(color: .brightBlue))
    context.console.output(
      #"""
        Return        Supply
        ------        ------

        $RT °F         $ST °F
        $RH%           $SH%

      Altitude: $A

      """#.replacingOccurrences(of: "$RT", with: numberString(for: returnTemperature))
        .replacingOccurrences(of: "$ST", with: numberString(for: supplyTemperature))
        .replacingOccurrences(of: "$RH", with: numberString(for: returnHumidity))
        .replacingOccurrences(of: "$SH", with: numberString(for: supplyHumidity))
        .replacingOccurrences(of: "$A", with: numberString(for: altitude)),
      style: .init(color: .brightBlue)
    )

    context.console.output("")
    let result = totalDeliveredHeat(conditions, airflow: cfm)

    context.console.output(
      "Delivered BTU: \(numberString(for: result)) BTU/H",
      style: .init(color: .green)
    )
  }
}
