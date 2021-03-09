//
//  Component.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/9.
//

import Foundation

public protocol ComponentInfo {
    
    var key: String { get }
    
    var help: String? { get }
    
}

public extension ComponentInfo {
    
    var help: String? { nil }
    
}
