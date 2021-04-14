//
//  String+SwiftyLine.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/10.
//

import Foundation

extension String {
    
    /// Returns a new string with the camel-case-based words of this string
    /// split by the specified separator.
    ///
    /// Examples:
    ///
    ///     "myProperty".convertedToSnakeCase()
    ///     // my_property
    ///     "myURLProperty".convertedToSnakeCase()
    ///     // my_url_property
    ///     "myURLProperty".convertedToSnakeCase(separator: "-")
    ///     // my-url-property
    func convertedToSnakeCase(separator: Character = "-") -> String {
      guard !isEmpty else { return self }
      var result = ""
      // Whether we should append a separator when we see a uppercase character.
      var separateOnUppercase = true
      for index in indices {
        let nextIndex = self.index(after: index)
        let character = self[index]
        if character.isUppercase {
          if separateOnUppercase && !result.isEmpty {
            // Append the separator.
            result += "\(separator)"
          }
          // If the next character is uppercase and the next-next character is lowercase, like "L" in "URLSession", we should separate words.
          separateOnUppercase = nextIndex < endIndex && self[nextIndex].isUppercase && self.index(after: nextIndex) < endIndex && self[self.index(after: nextIndex)].isLowercase
        } else {
          // If the character is `separator`, we do not want to append another separator when we see the next uppercase character.
          separateOnUppercase = character != separator
        }
        // Append the lowercased character.
        result += character.lowercased()
      }
      return result
    }
    
    var isKey: Bool {
        return hasPrefix("--") && count > 2
    }
    
    var isAbbr: Bool {
        return hasPrefix("-") && !hasPrefix("--") && count > 1
    }
    
    var isKeyOrAbbr: Bool {
        return isKey || isAbbr
    }
    
    var abbrs: [String] {
        if !isAbbr {
            fatalError("This key is not an abbr.");
        }
        let abbrs = dropFirst().map({ "-\($0)" })
        return abbrs
    }
}

public protocol StringConvertable {
    
    init?(_ string: String)
    
    var rawString: String { get }
    
}

extension StringConvertable {
    
    public var rawString: String { "\(self)" }
    
}

extension String: StringConvertable {
    init?(string: String) {
        self = string
    }
}

extension Int: StringConvertable {}
extension Int8: StringConvertable {}
extension Int16: StringConvertable {}
extension Int32: StringConvertable {}
extension Int64: StringConvertable {}

extension UInt: StringConvertable {}
extension UInt8: StringConvertable {}
extension UInt16: StringConvertable {}
extension UInt32: StringConvertable {}
extension UInt64: StringConvertable {}

extension Float: StringConvertable {}
extension Double: StringConvertable {}

extension Bool: StringConvertable {}
