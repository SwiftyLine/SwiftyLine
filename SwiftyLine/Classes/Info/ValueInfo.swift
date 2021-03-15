//
//  ValueInfo.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/15.
//

import Foundation

public struct ValueInfo: ComponentInfo {
    
    public var key: String
    
    public var help: String?
    
    public var optional: Bool = false
    
    public var userInfo: [String: Any] = [:]
    
}
