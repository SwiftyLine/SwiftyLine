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
            guard let label = child.label?.dropFirst() else { continue }
            let originKey = String(label)
            if let arg = child.value as? arg {
                if arg.mode == .keyed {
                    var info = ArgumentInfo(key: arg.key ?? originKey)
                    info.optional = false
                    info.abbr = arg.abbr
                    info.help = arg.help
                    info.originKey = originKey
                    self.arguments.append(info)
                } else {
                    var info = ValueInfo(key: originKey)
                    info.optional = false
                    info.help = arg.help
                    info.originKey = originKey
                    self.values.append(info)
                }
            }
            else if let opt = child.value as? opt {
                if opt.mode == .keyed {
                    var info = ArgumentInfo(key: opt.key ?? originKey)
                    info.optional = true
                    info.abbr = opt.abbr
                    info.help = opt.help
                    info.originKey = originKey
                    self.arguments.append(info)
                } else {
                    var info = ValueInfo(key: originKey)
                    info.optional = false
                    info.help = opt.help
                    info.originKey = originKey
                    self.values.append(info)
                }
            }
            else if let flag = child.value as? flg {
                var info = FlagInfo(key: flag.key ?? originKey)
                info.abbr = flag.abbr
                info.help = flag.help
                info.originKey = originKey
                self.flags.append(info)
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
