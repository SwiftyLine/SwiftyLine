//
//  Argument.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/8.
//

import Foundation

@propertyWrapper
public struct arg: Explain {
    
    public static var key: String {
        return ""
    }
    
    public var value: String?
    public var wrappedValue: String {
        set { value = newValue }
        get { value! }
    }
    
    public func help(_ content: String) -> arg {
        return self
    }
    
    public init() {
        
    }
}
