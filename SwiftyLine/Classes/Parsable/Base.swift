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

public extension Explain {
    
    static var help: String? {
        return "No help infomations"
    }
    
}
