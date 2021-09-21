import ConsoleKit
import Enthalpy
import Foundation

@available(macOS 10.15, *)
struct EnthalpyCommand: Command {

  struct Signature: CommandSignature {

    @Option(name: "temperature", help: "The temperature.")
    var temperature: Double?

    @Option(name: "humidity", help: "The humidity.")
    var humidity: Double?

    @Option(name: "altitude", help: "The altitude.")
    var altitude: Double?
  }

  var help: String {
    "Calculate the enthalpy for the given conditions."
  }

  func run(using context: CommandContext, signature: Signature) throws {

    var temperature: Double
    if let inputTemp = signature.temperature {
      temperature = inputTemp
    } else {
      let tempNumString = context.console.ask("What is the temperature:")
      temperature = Double(tempNumString) ?? 0
    }

    var humidity: Double
    if let inputHumidity = signature.humidity {
      humidity = inputHumidity
    } else {
      let humidityNumString = context.console.ask("What is the humidity:")
      humidity = Double(humidityNumString) ?? 0
    }

    let altitude: Double
    if let altitudeInput = signature.altitude {
      altitude = altitudeInput
    } else {
      let altitudeString = context.console.ask("What is the altitude:")
      altitude = Double(altitudeString) ?? 0
    }

    let enthalpy = Enthalpy(for: .init(temperature), at: .init(humidity), altitude: .init(altitude))
    let firstString: String = """
        Input Conditions: \(temperature)°F at humidity: \(humidity)% and altitude: \(altitude) ft.
      """
    let resultString: String = "  Enthalpy Result: \(numberString(for: enthalpy.rawValue))"

    context.console.output("")
    context.console.output(firstString, style: .init(color: .brightBlue))
    //    context.console.output("")
    context.console.output(resultString, style: .init(color: .green))
  }
}
