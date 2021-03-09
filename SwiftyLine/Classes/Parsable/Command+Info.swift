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
        
        // keys
        if let key = command.configuration?.key {
            self.key = key
        } else {
            self.key = "\(command)"
        }
        
        // other configuration
        if let configuration = command.configuration {
            // other configuration
            self.help = configuration.help
            
            // subcommands
            if let subcommands = configuration.subcommands {
                var subinfos = [Self]()
                for command in subcommands {
                    let subinfo = Self(command: command)
                    subinfos.append(subinfo)
                }
                self.subcommands = subinfos
            }
        }
        
        // arguments, optionals, flags
        let mirror = Mirror(reflecting: command.init())
        for child in mirror.children {
            if let _ = child.value as? arg {
                var info = ArgumentInfo(key: child.label!)
                info.optional = false
                self.arguments.append(info)
            }
            else if let _ = child.value as? opt {
                var info = ArgumentInfo(key: child.label!)
                info.optional = true
                self.optionals.append(info)
            }
            else if let _ = child.value as? flg {
                let info = FlagInfo(key: child.label!)
                self.flags.append(info)
            }
        }
    }
}
