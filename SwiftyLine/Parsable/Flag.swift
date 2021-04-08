//
//  Flag.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/8.
//

import Foundation

@propertyWrapper
public struct flg: Explain, Decodable {
    
    public var wrappedValue: Bool = false
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        if let _decoder = decoder as? ArgumentDecoder {
            self.wrappedValue = _decoder.flag
        }
    }
    
    public var key: String?
    public var abbr: Character?
    public var help: String?
    
    public init(key: String? = nil, abbr: Character? = nil, help: String? = nil) {
        self.key = key
        self.abbr = abbr
        self.help = help
    }
}
