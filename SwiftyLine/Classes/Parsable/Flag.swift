//
//  Flag.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/8.
//

import Foundation

@propertyWrapper
public struct flg: Explain {
    
    public static var key: String {
        ""
    }
    
    public var value: Bool = false
    public var wrappedValue: Bool {
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
