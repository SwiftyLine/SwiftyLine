
import Foundation

public struct CommandConfiguration {
    
    var key: String
    
    var help: String
    
    var subcommands: [Command]?
    
}

public protocol Command: Explain {
    
    func main() throws;
    
    static var subcommands: [Command.Type]? { get }
    
}

public extension Command {
    
    static var subcommands: [Command.Type]? { nil }
}

public extension Command {
    
    static func main(_ arguments: [String] = CommandLine.arguments) throws {
        let cmd = Self()
        let mirror = Mirror(reflecting: cmd)
        mirror.children.forEach { (item) in
            print("\(item.label!): \(item.value)")
            let mirror = Mirror(reflecting: item.value)
            mirror.children.forEach { (subitem) in
                print("\t\(subitem.label!): \(subitem.value)")
            }
        }
        let info = CommandInfo(command: Self.self)
        print(info)
        try? cmd.main()
    }
    
}
