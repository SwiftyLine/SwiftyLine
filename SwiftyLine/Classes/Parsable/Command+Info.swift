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
        let key = command.configuration?.key ?? "\(command)".convertedToSnakeCase()
        self.keyPath = (`super`?.keyPath ?? []) + [key]
        
        // other configuration
        if let configuration = command.configuration {
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
        }
        
        // arguments, optionals, flags
        let mirror = Mirror(reflecting: command.init())
        for child in mirror.children {
            if let arg = child.value as? arg {
                var info = ArgumentInfo(key: arg.key ?? String(child.label!.dropFirst()))
                info.optional = false
                info.abbr = arg.abbr
                info.help = arg.help
                self.arguments.append(info)
            }
            else if let opt = child.value as? opt {
                var info = ArgumentInfo(key: opt.key ?? String(child.label!.dropFirst()))
                info.optional = true
                info.abbr = opt.abbr
                info.help = opt.help
                self.arguments.append(info)
            }
            else if let flag = child.value as? flg {
                var info = FlagInfo(key: flag.key ?? String(child.label!.dropFirst()))
                info.abbr = flag.abbr
                info.help = flag.help
                self.flags.append(info)
            }
        }
    }
}
