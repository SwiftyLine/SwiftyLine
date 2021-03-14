//
//  FlagInfo.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/9.
//

import Foundation

public struct OperationString {
    
    public enum Style: Int {
        case none = 0
        case bold, light, italic, underline, flash, reversal, clear
        
        case black = 30, red, green, yellow
        case blue, purple, darkGreen, white
        
        case _black = 40, _red, _green, _yellow
        case _blue, _purple, _darkGreen, _white
    }
    
    public struct Builder {
        var style: [Style] = []
        
        public func build(_ string: String) -> OperationString {
            return OperationString(content: string, style: style)
        }
    }
    
    var content: String
    var style: [Style]
    var text: String { "\(self)" }
    
}

extension OperationString: CustomStringConvertible {
    
    public var description: String {
        "\(style.text)\(content)\([].text)"
    }
    
}

extension Array where Element == OperationString.Style {
    
    var text: String {
        if count == 0 {
            return "\u{001B}[0m"
        }
        return "\u{001B}[\(map({ "\($0.rawValue)" }).joined(separator: ";"))m"
    }

}

public extension String {
    
    var bold: OperationString { .init(content: self, style: [.bold]) }
    var light: OperationString { .init(content: self, style: [.light]) }
    var italic: OperationString { .init(content: self, style: [.italic]) }
    var underline: OperationString { .init(content: self, style: [.underline]) }
    var flash: OperationString { .init(content: self, style: [.flash]) }
    var reversal: OperationString { .init(content: self, style: [.reversal]) }
    var clear: OperationString { .init(content: self, style: [.clear]) }
    
    var black: OperationString { .init(content: self, style: [.black]) }
    var red: OperationString { .init(content: self, style: [.black]) }
    var green: OperationString { .init(content: self, style: [.black]) }
    var yellow: OperationString { .init(content: self, style: [.yellow]) }
    var blue: OperationString { .init(content: self, style: [.blue]) }
    var purple: OperationString { .init(content: self, style: [.purple]) }
    var darkGreen: OperationString { .init(content: self, style: [.darkGreen]) }
    var white: OperationString { .init(content: self, style: [.white]) }
    
    var _black: OperationString { .init(content: self, style: [._black]) }
    var _red: OperationString { .init(content: self, style: [._red]) }
    var _green: OperationString { .init(content: self, style: [._green]) }
    var _yellow: OperationString { .init(content: self, style: [._yellow]) }
    var _blue: OperationString { .init(content: self, style: [._blue]) }
    var _purple: OperationString { .init(content: self, style: [._purple]) }
    var _darkGreen: OperationString { .init(content: self, style: [._darkGreen]) }
    var _white: OperationString { .init(content: self, style: [._white]) }
}

public extension OperationString {
    
    var bold: OperationString { return .init(content: content, style: style + [.bold]) }
    var light: OperationString { return .init(content: content, style: style + [.light]) }
    var italic: OperationString { return .init(content: content, style: style + [.italic]) }
    var underline: OperationString { return .init(content: content, style: style + [.underline]) }
    var flash: OperationString { return .init(content: content, style: style + [.flash]) }
    var reversal: OperationString { return .init(content: content, style: style + [.reversal]) }
    var clear: OperationString { return .init(content: content, style: style + [.clear]) }
    
    var black: OperationString { return .init(content: content, style: style + [.black]) }
    var red: OperationString { return .init(content: content, style: style + [.red]) }
    var green: OperationString { return .init(content: content, style: style + [.green]) }
    var yellow: OperationString { return .init(content: content, style: style + [.yellow]) }
    var blue: OperationString { return .init(content: content, style: style + [.blue]) }
    var purple: OperationString { return .init(content: content, style: style + [.purple]) }
    var darkGreen: OperationString { return .init(content: content, style: style + [.darkGreen]) }
    var white: OperationString { return .init(content: content, style: style + [.white]) }
    
    var _black: OperationString { return .init(content: content, style: style + [._black]) }
    var _red: OperationString { return .init(content: content, style: style + [._red]) }
    var _green: OperationString { return .init(content: content, style: style + [._green]) }
    var _yellow: OperationString { return .init(content: content, style: style + [._yellow]) }
    var _blue: OperationString { return .init(content: content, style: style + [._blue]) }
    var _purple: OperationString { return .init(content: content, style: style + [._purple]) }
    var _darkGreen: OperationString { return .init(content: content, style: style + [._darkGreen]) }
    var _white: OperationString { return .init(content: content, style: style + [._white]) }
    
}
