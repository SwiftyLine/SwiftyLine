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
        configuration.key = "subcmd"
        configuration.help = "Sub command helper"
        return configuration
    }
    
    func main() throws {
        print("my command 2")
    }
}

struct MyCommand: Command {
    
    static var configuration: CommandConfiguration? {
        var configuration = CommandConfiguration()
        configuration.help = "This tool name"
        configuration.subcommands = [MyCommand2.self]
        return configuration
    }
    
    @arg(key: "fakename", abbr: "a", help: "nihao")
    var name: String
    
    @arg(mode: .value, help: "Value")
    var subname: String
    
    @opt(help: "Body description")
    var body: String?
    
    @flg(key: "abc", abbr: "f", help: "Flag Helper")
    var ijk: Bool
    
    func main() throws {
        print("Input name = \(name)")
        print("Sub name = \(subname)")
        if let body = self.body {
            print("Input body = \(body)")
        }
        if ijk {
            print("Input ijk")
        }
    }
}

try MyCommand.main()
