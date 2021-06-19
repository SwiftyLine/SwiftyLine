//
//  Command+Help.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/9.
//
// Convert command to command info
//

import Foundation

extension CommandInfo {
    
    init(command: Command.Type) {
        self.init(command: command, super: nil)
    }
    
    init(command: Command.Type, super: CommandInfo?) {
        
        // keys
        let key = command.configuration.key ?? "\(command)".convertedToSnakeCase()
        self.keyPath = (`super`?.keyPath ?? []) + [key]
        
        let configuration = command.configuration
        
        // other configuration
        self.help = configuration.help
        
        // subcommands
        if let subcommands = configuration.subcommands {
            var subinfos = [Self]()
            for command in subcommands {
                let subinfo = Self(command: command, super: self)
                subinfos.append(subinfo)
            }
            self.subcommands = subinfos
        }
        
        
        // arguments, optionals, flags
        let mirror = Mirror(reflecting: command.init())
        for child in mirror.children {
            guard let label = child.label?.dropFirst() else { continue }
            let originKey = String(label)
            if let item = child.value as? ComponentInfoProvider {
                let info = item.makeSet(key: originKey)
                if let item = info as? ArgumentInfo {
                    self.arguments.append(item)
                }
                else if let item = info as? FlagInfo {
                    self.flags.append(item)
                }
                else if let item = info as? ValueInfo {
                    self.values.append(item)
                }
            }
        }
    }
    
}

extension ComponentInfo {
    
    var originKey: String {
        get { userInfo["originKey"] as? String ?? key }
        set { userInfo["originKey"] = newValue }
    }
    
}

extension ParseResult {
    
//    func originKeyedResult(command: CommandInfo) -> ParseResult {
//        var newResult = self
//        
//        var keyMap = [String: String]()
//        for info in command.arguments {
//            keyMap[info.key] = info.originKey
//        }
//        let arguments = newResult.arguments
//        for (key, value) in arguments {
//            // MARK: - TODO: awefji
//            let originKey = keyMap[key]!;
//            if keyMap[key] == key {
//                continue
//            }
//            newResult.arguments[]
//            newResult.arguments[key] = nil
//        }
//        
//    }
    
}
