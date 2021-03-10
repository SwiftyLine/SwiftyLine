//
//  FlagInfo.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/9.
//

import Foundation

public enum ParseError: Error {
    
    case missingRequiredArguments(ArgumentInfo)

    case missingArgumentsValue(ArgumentInfo)
    
}

public struct ParseResult {
    
    var commands = [String]()
    
    
    var arguments = [String: String]()
    
    var flags = [String]()
    
    var values = [String]()
    
    var error: ParseError?
    
}

struct Parser {
    
    func parse(info: CommandInfo, argv: [String]) -> ParseResult {
        var result = ParseResult()
        var arguments = Array(argv.dropFirst())
        result.commands.append(info.command)
        
        var targetCmd = info
        while let name = arguments.first, let cmd = targetCmd.sub(command: name) {
            arguments.removeFirst()
            targetCmd = cmd
            result.commands.append(name)
        }
        
        while arguments.count > 0 {
            let current = arguments.removeFirst()
            if current.isAbbr {
                if current.count > 2 {
                    // mult abbrs
                    let abbrs = current.abbrs
                    arguments.insert(contentsOf: abbrs, at: 0)
                    continue
                } else {
                    // find abbr
                    let abbr = current.last!
                    if let info = targetCmd.sub(abbr: abbr) {
                        if let arg = info as? ArgumentInfo {
                            if arguments.count == 0 {
                                result.error = .missingArgumentsValue(arg)
                                break
                            } else {
                                let value = arguments.removeFirst()
                                result.arguments[arg.key] = value
                            }
                        }
                        else if let flg = info as? FlagInfo {
                            result.flags.append(flg.key)
                        }
                        continue
                    }
                }
            }
            if current.isKey {
                // find key
                if let info = targetCmd.sub(key: String(current.dropFirst(2))) {
                    if let arg = info as? ArgumentInfo {
                        if arguments.count == 0 {
                            result.error = .missingArgumentsValue(arg)
                            break
                        } else {
                            let value = arguments.removeFirst()
                            result.arguments[arg.key] = value
                        }
                    }
                    else if let flg = info as? FlagInfo {
                        result.flags.append(flg.key)
                    }
                    continue
                }
            }
            // value
            result.values.append(current)
        }
        
        return result
    }
    
}
