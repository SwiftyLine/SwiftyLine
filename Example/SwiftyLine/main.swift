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
        print(good)
    }
}

struct MyCommand: Command {
    
    static var key: String {
        return "cmd"
    }
    
    static var subcommands: [Command.Type]? {
        return [MyCommand2.self]
    }
    
    @arg()
    var name: String
    
    @opt()
    var body: String?
    
    @flg()
    var good: Bool
    
    
    func main() throws {
        print(good)
    }
}

try MyCommand.main()
