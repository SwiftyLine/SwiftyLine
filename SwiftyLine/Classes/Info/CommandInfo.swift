//
//  Info.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/2/28.
//

import Foundation

public struct CommandInfo: ComponentInfo {
    
    public var key: String
    
    public var arguments = [ArgumentInfo]()
    public var optionals = [ArgumentInfo]()
    
    public var flags = [FlagInfo]()
    
    public var subcommands: [CommandInfo]?
    
    public var help: String?
    
}

extension CommandInfo: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var debug = ""
        debug.append(self.key + ": {\n")
        debug.append("\targuments: [\n")
        for arg in self.arguments {
            debug.append("\t\t\(arg)\n")
        }
        debug.append("\t]\n")
        debug.append("\tflags: [\n")
        for flag in self.flags {
            debug.append("\t\t\(flag)\n")
        }
        debug.append("\t]\n")
        if let subcommands = self.subcommands {
            debug.append("\tsubcommands: [\n")
            for subcmd in subcommands {
                let string = "\(subcmd)"
                let lines = string.components(separatedBy: "\n")
                for line in lines {
                    debug.append("\t\t\(line)\n")
                }
            }
            debug.append("\t]\n")
        }
        debug.append("}")
        return debug
    }
    
}
