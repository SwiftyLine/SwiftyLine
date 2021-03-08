//
//  Base.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/8.
//

import Foundation

public protocol Explain {
    
    static var key: String { get }
    
    static var help: String? { get }
    
    init()
}

public protocol ValuePackager {
    
    var package: ValuePackage { get set }
    
}

public enum ValuePackage {
    case undefine
    case value(String)
}

public extension Explain {
    
    static var help: String? {
        return "No help infomations"
    }
    
}


struct ParseResult {
    
    func get<T>(for key: String) -> T {
        return "" as! T
    }
    
}
