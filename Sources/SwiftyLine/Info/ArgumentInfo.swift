//
//  ArgumentInfo.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/9.
//

import Foundation

public protocol ComponentInfo {
    
    var key: String { get }
    
    var help: String? { get }
    
    var userInfo: [String: Any] { get set }
    
}

public extension ComponentInfo {
    
    var help: String? { nil }
    
}

public enum ParseError: Error {
    
    case missingRequiredArguments(ArgumentInfo)

    case missingArgumentsValue(ArgumentInfo)
    
}


public struct ArgumentInfo: ComponentInfo {
    
    public var key: String
    
    public var abbr: Character?
    
    public var help: String?
    
    public var optional: Bool = false
    
    public var userInfo: [String: Any] = [:]
    
}

public struct FlagInfo: ComponentInfo {
    
    public var key: String
    
    public var abbr: Character?
    
    public var help: String?
    
    public var userInfo: [String: Any] = [:]
    
    public static var silent = FlagInfo(key: "silent", abbr: nil, help: "Show nothing")
    
    public static var version = FlagInfo(key: "version", abbr: nil, help: "Show the version of the tool")
    
    public static var verbose = FlagInfo(key: "verbose", abbr: nil, help: "Show more debugging information")
    
    public static var noANSI = FlagInfo(key: "no-ansi", abbr: nil, help: "Show output without ANSI codes")
    
    public static var help = FlagInfo(key: "help", abbr: nil, help: "Show help banner of specified command")
    
    public static var defaultFlags: [FlagInfo] = [.silent, .version, verbose, .noANSI, .help]
    
}

public struct ValueInfo: ComponentInfo {
    
    public var key: String
    
    public var help: String?
    
    public var optional: Bool = false
    
    public var userInfo: [String: Any] = [:]
    
}

