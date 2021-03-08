//
//  Info.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/2/28.
//

import Foundation

protocol ExplainInfo {
    
    var key: String { get }
    
    var help: String? { get }
}

extension ExplainInfo {
    
    var help: String? { nil }
    
}

struct CommandInfo: ExplainInfo {
    
    var key: String
    
    struct ArgumentInfo: ExplainInfo {
        var key: String
        var optional: Bool = false
    }
    var arguments = [ArgumentInfo]()
    
    struct FlagInfo: ExplainInfo {
        var key: String
    }
    var flags = [FlagInfo]()
    
    var subcommands: [CommandInfo]?
    
    var help: String?
}

extension CommandInfo {
    
    init(command: Command.Type) {
        key = command.key;
        help = command.help
        if let subcommands = command.subcommands {
            var subs = [CommandInfo]()
            for command in subcommands {
                let subinfo = Self(command: command)
                subs.append(subinfo)
            }
            self.subcommands = subs
        }
    }
}
