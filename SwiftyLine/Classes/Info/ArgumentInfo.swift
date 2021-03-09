//
//  ArgumentInfo.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/9.
//

import Foundation

public struct ArgumentInfo: ComponentInfo {
    
    public var key: String
    
    public var abbr: Character?
    
    public var help: String?
    
    public var optional: Bool = false
    
}
