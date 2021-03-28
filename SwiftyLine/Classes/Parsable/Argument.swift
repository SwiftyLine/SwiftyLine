//
//  Argument.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/8.
//

import Foundation

@propertyWrapper
public struct arg: Explain, Decodable {
    
    public var wrappedValue: String = ""
    
    public init() {
        self.wrappedValue = ""
    }
    
    public init(from decoder: Decoder) throws {
        let single = decoder as! ArgumentDecoder
        self.wrappedValue = single.value as! String
    }
    
    public var key: Key = .named(nil)
    public var abbr: Character?
    public var help: String?
    
    public init(key: Key? = nil, abbr: Character? = nil, help: String? = nil) {
        self.key = key ?? .named(nil)
        self.abbr = abbr
        self.help = help
    }
}
