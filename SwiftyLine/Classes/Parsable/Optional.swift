//
//  Optional.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/8.
//

import Foundation

@propertyWrapper
public struct opt: Explain {
    
    
    public var value: String?
    public var wrappedValue: String? {
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
