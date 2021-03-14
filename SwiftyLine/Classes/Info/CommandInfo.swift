//
//  Info.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/2/28.
//

import Foundation

public struct CommandInfo: ComponentInfo {
    
    public var key: String {
        return self.keyPath.last!
    }
    public var command: String {
        get { key }
    }
    
    public var keyPath: [String]
    
    public var arguments = [ArgumentInfo]()
    
    public var flags = [FlagInfo]()
    
    public var subcommands = [CommandInfo]()
    
    public var help: String?
    
}

extension CommandInfo {
    
    public func sub(command: String) -> CommandInfo? {
        for subcmd in subcommands {
            if subcmd.command == command {
                return subcmd
            }
        }
        return nil
    }
    
    public func sub(key: String) -> ComponentInfo? {
        for arg in arguments {
            if arg.key == key {
                return arg
            }
        }
        for flg in flags + FlagInfo.defaultFlags {
            if flg.key == key {
                return flg
            }
        }
        return nil
    }
    
    public func sub(abbr: Character) -> ComponentInfo? {
        for arg in arguments where arg.abbr != nil {
            if arg.abbr! == abbr {
                return arg
            }
        }
        for flg in flags where flg.abbr != nil {
            if flg.abbr! == abbr {
                return flg
            }
        }
        return nil
    }
}

extension CommandInfo: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var debug = ""
        debug.append(self.key + ": {\n")
        if self.arguments.count > 0 {
            debug.append("\targuments: [\n")
            for arg in self.arguments {
                debug.append("\t\t\(arg)\n")
            }
            debug.append("\t]\n")
        }
        if self.flags.count > 0 {
            debug.append("\tflags: [\n")
            for flag in self.flags {
                debug.append("\t\t\(flag)\n")
            }
            debug.append("\t]\n")
        }
        if self.subcommands.count > 0 {
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
