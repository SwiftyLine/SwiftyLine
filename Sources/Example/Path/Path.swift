//
//  Path.swift
//  Thumboard
//
//  Created by 吴双 on 2020/5/4.
//  Copyright © 2020 Magic-Unique. All rights reserved.
//

import Foundation

internal extension String {
    func removeEndSeparator() -> String {
        var _string = self
        
        if _string.hasSuffix("/") {
            _string = String(_string[..<_string.index(before: _string.endIndex)])
        }
        
        return _string
    }
    
    var lastPathComponent: String {
        let components = self.components(separatedBy: "/")
        return components.last ?? ""
    }
    
    var pathExtension: String {
        let last = lastPathComponent
        let components = last.components(separatedBy: ".")
        if components.count > 1 {
            return components.last!
        } else {
            return ""
        }
    }
}

extension Array where Element == String {
    fileprivate mutating func trim() {
        if let last = last {
            if last == "" {
                removeLast()
            }
        }
        if let first = first {
            if first == "" {
                removeFirst()
            }
        }
    }
}

public struct Path {
    let components: [String]
    
    public static var currentPath: Path {
        return Path(string: FileManager.default.currentDirectoryPath)
    }
    
    private init(components: [String]) {
        self.components = components
    }
    
    public init(string: String = FileManager.default.currentDirectoryPath) {
        var _string = string.removeEndSeparator()
        
        if _string.hasPrefix("~") {
            _string = NSHomeDirectory() + String(_string[_string.index(_string.startIndex, offsetBy: 1)...])
        } else if _string.hasPrefix("/") == false {
            let cwd = FileManager.default.currentDirectoryPath
            _string = cwd + String(_string[_string.index(_string.startIndex, offsetBy: 1)...])
        }
        
        var components = _string.components(separatedBy: "/")
        components.trim()
        
        var formats = [String]()
        for item in components {
            if item == "." {
                continue
            }
            else if item == ".." {
                formats.removeLast()
            }
            else {
                formats.append(item)
            }
        }
        self.init(components: formats)
    }
    
    public var superpath: Path? {
        if components.count > 0 {
            var components = self.components
            components.removeLast()
            return Path(components: components)
        } else {
            return nil;
        }
    }
    
    public var string: String {
        return "/" + components.joined(separator: "/")
    }
    
    public var fileURL: URL {
        return URL(fileURLWithPath: string)
    }
    
    public var lastPathComponent: String {
        return components.last!
    }
    
    public var pathExtension: String {
        return lastPathComponent.pathExtension
    }
    
    public func subpath(component: String) -> Path {
        var components = self.components
        components += component.removeEndSeparator().components(separatedBy: "/")
        return Path(components: components)
    }
    
    public func relative(to path: Path = .currentPath, current: Bool = false) -> String {
        var thisComponents = self.components
        var thatComponents = path.components
        while thisComponents.count > 0 && thatComponents.count > 0 {
            if thisComponents[0] != thatComponents[0] {
                break
            }
            thisComponents.removeFirst()
            thatComponents.removeFirst()
        }
        var components = [String]()
        for _ in 0..<thatComponents.count {
            components.append("..")
        }
        components += thisComponents
        if current {
            components.insert(".", at: 0)
        }
        return components.joined(separator: "/")
    }
}
