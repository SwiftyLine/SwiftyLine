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
            if let item = child.value as? Require {
                append(require: item, originKey: originKey)
            }
            else if let item = child.value as? Optional {
                append(optioanl: item, originKey: originKey)
            }
            else if let flag = child.value as? Flag {
                append(flag: flag, originKey: originKey)
            }
        }
    }
    
    mutating func append(require: Require, originKey: String) {
        let configuration = require.configuration
        if case let .named(key) = configuration.key {
            var info = ArgumentInfo(key: key ?? originKey)
            info.optional = false
            info.abbr = configuration.abbr
            info.help = configuration.help
            info.originKey = originKey
            self.arguments.append(info)
        } else {
            var info = ValueInfo(key: originKey)
            info.optional = false
            info.help = configuration.help
            info.originKey = originKey
            self.values.append(info)
        }
    }
    
    mutating func append(optioanl: Optional, originKey: String) {
        let configuration = optioanl.configuration
        if case let .named(key) = configuration.key {
            var info = ArgumentInfo(key: key ?? originKey)
            info.optional = true
            info.abbr = configuration.abbr
            info.help = configuration.help
            info.originKey = originKey
            self.arguments.append(info)
        } else {
            var info = ValueInfo(key: originKey)
            info.optional = false
            info.help = configuration.help
            info.originKey = originKey
            self.values.append(info)
        }
    }
    
    mutating func append(flag: Flag, originKey: String) {
        let config = flag.configuration
        var info = FlagInfo(key: config.key ?? originKey)
        info.abbr = config.abbr
        info.help = config.help
        info.originKey = originKey
        self.flags.append(info)
    }
}

extension ComponentInfo {
    
    var originKey: String {
        get { userInfo["originKey"] as? String ?? key }
        set { userInfo["originKey"] = newValue }
    }
    
}
