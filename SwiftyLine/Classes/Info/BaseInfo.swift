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
    
    var userInfo: [String: Any] { get set }
    
}

public extension ComponentInfo {
    
    var help: String? { nil }
    
}

public protocol ArgumentValue {
    
    init?(argument: String)
    
}

public enum ParseError: Error {
    
    case missingRequiredArguments(ArgumentInfo)

    case missingArgumentsValue(ArgumentInfo)
    
}
