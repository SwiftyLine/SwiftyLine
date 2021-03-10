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
        var mirror = Mirror(reflecting: self)
//        for var child in mirror.children {
//            let label = String(child.label!.dropFirst())
//            let value = result.arguments[label]
//            child.value = value
//        }
        for (key, value) in result.arguments {
            mirror.set(key: key, value: value)
//            if let child = mirror.child(label: key) {
//                if var arg = child.value as? arg {
//                    arg.value = value
//                }
//            }
        }
    }
    
}


public extension Command {
    
    static func main(_ arguments: [String] = CommandLine.arguments) throws {
        let info = CommandInfo(command: Self.self)
        let result = Parser().parse(info: info, argv: arguments)
        print(info)
        print(result)
        if result.error != nil {
            
        } else {
            let cmd = Self.init(result: result)
            try? cmd.main()
        }
    }
    
}
