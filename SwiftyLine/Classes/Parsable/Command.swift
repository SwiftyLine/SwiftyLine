
import Foundation

public struct CommandConfiguration {
    
    public var key: String?
    
    public var help: String?
    
    public var subcommands: [Command.Type]?
    
    public init() { }
    
}

public protocol Command {
    
    static var configuration: CommandConfiguration? { get }
    
    func main() throws;
    
    init()
}

public extension Command {
    
    static var configuration: CommandConfiguration? { nil }
    
}
