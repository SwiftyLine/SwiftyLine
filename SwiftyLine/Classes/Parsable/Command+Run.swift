//
//  Command+Running.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/9.
//
//  Parse command as root and run it.
//

import Foundation

extension Command {
    
    init(result: ParseResult) {
        self.init()
    }
    
}


public extension Command {
    
    static func main(_ arguments: [String] = CommandLine.arguments) throws {
        let info = CommandInfo(command: Self.self)
        let result = Parser().parse(info: info, argv: arguments)
        print(info)
        let cmd = Self.init(result: result)
        try? cmd.main()
    }
    
}
