//
//  Info.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/2/28.
//

import Foundation

public protocol Helper {
    
    func print(command: CommandInfo)
    
}

var shared: Helper?

extension Helper {
    
    static func register(helper: Helper) {
        shared = helper
    }
    
    static var current: Helper {
        return shared ?? PodHelper()
    }
    
    static func print(command: CommandInfo) {
        self.current.print(command: command)
    }
}

public struct PodHelper: Helper {
    
    public func print(command: CommandInfo) {
        
    }
    
}
