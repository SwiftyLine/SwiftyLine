//
//  main.swift
//  SwiftyLine_Example
//
//  Created by 吴双 on 2021/2/28.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import SwiftyLine

struct MyCommand2: Command {
    
    static var configuration: CommandConfiguration? {
        var configuration = CommandConfiguration()
        configuration.help = "Sub command helper"
        return configuration
    }
    
    @arg()
    var name: String
    
    @opt()
    var body: String?
    
    @flg()
    var good: Bool
    
    
    func main() throws {
    }
}

struct MyCommand: Command {
    
    static var configuration: CommandConfiguration? {
        var configuration = CommandConfiguration()
        configuration.subcommands = [MyCommand2.self]
        configuration.help = "This tool name"
        return configuration
    }
    
    @arg(key: "name", abbr: "a", help: "nihao")
    var name: String
    
    @opt(help: "Body description")
    var body: String?
    
    @flg(key: "ijk", abbr: "f", help: "Flag Helper")
    var ijk: Bool
    
    func main() throws {
        print("Input name = \(name)")
        if let body = self.body {
            print("Input body = \(body)")
        }
        if ijk {
            print("Input ijk")
        }
    }
}

try MyCommand.main()
