import ConsoleKit
import Foundation

if #available(macOS 10.15, *) {
  let console = Terminal()
  let input = CommandInput(arguments: CommandLine.arguments)
  let context = CommandContext(console: console, input: input)

  var commands = Commands(enableAutocomplete: true)
  commands.use(EnthalpyCommand(), as: "enthalpy", isDefault: false)
  //  commands.use(TotalHeatCommand(), as: "total-heat", isDefault: false)

  do {
    let group =
      commands
      .group(help: "A command line utility for psychrometric calculations.")
    try console.run(group, input: input)
  } catch let error {
    console.error("\(error)")
    exit(1)
  }
}
