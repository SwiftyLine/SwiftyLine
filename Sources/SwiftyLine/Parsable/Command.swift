
import Foundation

public struct CommandConfiguration {
    
    public var key: String?
    
    public var help: String?
    
    public var subcommands: [Command.Type]?
    
    public init() { }
    
}

public protocol Command: Decodable {
    
    static var configuration: CommandConfiguration { get }
    
    mutating func main() throws;
    
    init()
}

public extension Command {
    
    static var configuration: CommandConfiguration { CommandConfiguration() }
    
    static var command: String { configuration.key ?? "\(self)".convertedToSnakeCase() }
    
    static func subcommand(for command: String) -> Command.Type? {
        guard let subcommands = self.configuration.subcommands else { return nil }
        for subcommand in subcommands {
            if subcommand.command == command {
                return subcommand
            }
        }
        return nil
    }
    
    mutating func main() throws {
        let info = CommandInfo(command: Self.self)
        Helper.printBanner(for: info)
    }
    
    static func main(_ arguments: [String] = CommandLine.arguments) throws {
        let info = CommandInfo(command: Self.self)
        let result = info.parse(argv: arguments)
        if result.error != nil {
            let string = Helper.current.helpBanner(for: result.command)
            print(string)
        }
        else if result.flag(.help) {
            let string = Helper.current.helpBanner(for: result.command)
            print(string)
        }
        else {
            let decoder = CommandDecoder(result: result)
            var commandType: Command.Type = Self.self
            var commandPath = result.commandPath
            commandPath.removeFirst()
            for command in commandPath {
                commandType = commandType.subcommand(for: command)!
            }
            var cmd = try commandType.init(from: decoder)
            try cmd.main()
        }
    }
    
}
