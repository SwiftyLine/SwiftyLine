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
    
    static var key: String {
        return "cmd2"
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
    
    @arg()
    var name: String
    
    @opt()
    var body: String?
    
    @flg()
    var good: Bool
    
    
    func main() throws {
    }
}

try MyCommand.main()
