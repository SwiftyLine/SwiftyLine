//
//  Base.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/8.
//

import Foundation

public protocol Explain {
    
    var help: String? { get }
    
    init()
}

public extension Explain {
    
    var help: String? {
        return "No help infomations"
    }
    
}

public enum Mode {
    case keyed, value
}
