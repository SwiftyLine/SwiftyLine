//
//  Argument.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/8.
//

import Foundation

@propertyWrapper
public struct arg<T>: Explain {
    
    public static var key: String {
        return ""
    }
    
    public var value: T?
    public var wrappedValue: T {
        get {
            return value!
        }
        set {
            value = newValue
        }
    }
    
    public func help(_ content: String) -> arg {
        return self
    }
    
    public init() {
        
    }
}
