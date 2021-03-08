//
//  Optional.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/8.
//

import Foundation

@propertyWrapper
public struct opt<T>: Explain {
    public static var key: String {
        ""
    }
    
    public var value: T?
    public var wrappedValue: T? {
        get {
            return value
        }
        set {
            value = newValue
        }
    }
    
    public init() {
        
    }
}
