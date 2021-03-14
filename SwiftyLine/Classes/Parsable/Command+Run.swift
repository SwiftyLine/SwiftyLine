//
//  Command+Running.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/9.
//
//  Parse command as root and run it.
//

import Foundation

public extension Command {
    
    static func main(_ arguments: [String] = CommandLine.arguments) throws {
        let info = CommandInfo(command: Self.self)
        let result = info.parse(argv: arguments)
        if result.error != nil {
            let helper = CommandHelper.current
            let string = helper.helpBanner(for: result.command)
            print(string)
        } else {
            let decoder = CommandDecoder(result: result)
            let cmd = try? Self.init(from: decoder)
            try? cmd?.main()
        }
    }
    
}
