//
//  FlagInfo.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/9.
//

import Foundation

public struct ParseResult {
    
    var commands: [String] = [String]()
    
    
    var arguments: [String: String]?
    
    var flags: [String]?
    
    var values: [String]?
    
}

struct Parser {
    
    func parse(info: CommandInfo, argv: [String]) -> ParseResult {
        return ParseResult()
    }
    
}
