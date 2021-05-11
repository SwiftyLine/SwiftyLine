//
//  Argument.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/8.
//

import Foundation

// MARK: - Base

public enum ArgumentKey {
    case null
    case named(String?)
}

protocol ComponentInfoProvider {
    func makeSet(key: String) -> ComponentInfo
}

enum ArgumentValue<T> {
    case define
    case value(T)
}

public class ArgumentConfiguration {
    
    private var _key: ArgumentKey = .named(nil)
    public var key: ArgumentKey {
        set {
            _key = newValue
        }
        get {
            if self is PlaceholderConfiguration {
                return .null
            }
            return _key
        }
    }
    public var abbr: Character?
    public var help: String?
    
    public init() {}
    
    public var isKeyed: Bool {
        if self is ValueConfiguration { return false }
        if case .null = key { return false }
        return true
    }
    
    var optional = false
    
    
    @discardableResult public func keyed(_ key: ArgumentKey) -> Self { _key = key; return self }
    @discardableResult public func keyed(_ key: String) -> Self { keyed(.named(key)) }
    public var noKey: Self { keyed(.null) }
    
    @discardableResult public func abbr(_ abbr: Character) -> Self { self.abbr = abbr; return self }
    
    @discardableResult public func help(_ help: String) -> Self { self.help = help; return self }
    
    func toInfo(originKey: String) -> ComponentInfo {
        if case let .named(key) = self.key {
            var info = ArgumentInfo(key: key ?? originKey)
            info.optional = self.optional
            info.abbr = self.abbr
            info.help = self.help
            info.originKey = originKey
            return info
        } else {
            var info = ValueInfo(key: originKey)
            info.optional = self.optional
            info.help = self.help
            info.originKey = originKey
            return info
        }
    }
    
}

public class KeyedConfiguration: ArgumentConfiguration {}
public class ValueConfiguration: ArgumentConfiguration {}
public class PlaceholderConfiguration: ArgumentConfiguration {}
extension ArgumentConfiguration { public var isPlaceholder: Bool { return self is PlaceholderConfiguration } }

// MARK: - Require

@propertyWrapper
public struct Require<T:StringConvertable>: Decodable, ComponentInfoProvider {
    
    var _wrappedValue: ArgumentValue<T> = .define
    
    public var wrappedValue: T {
        set { _wrappedValue = .value(newValue) }
        get {
            if case let .value(v) = _wrappedValue {
                return v
            }
            fatalError("The property is not init.")
        }
    }
    
    public var configuration: ArgumentConfiguration = PlaceholderConfiguration()
    
    public init(_ building: () -> ArgumentConfiguration) {
        self.configuration = building()
    }
    
    public init(from decoder: Decoder) throws {
        let single = decoder as! ArgumentDecoder
        let value = single.value as! String
        let _value = T(value)
        self.wrappedValue = _value!
    }
    
    public init(key: ArgumentKey? = nil, abbr: Character? = nil, help: String? = nil) {
        self.init({
            let configuration: ArgumentConfiguration
            if let _key = key, case .null = _key {
                configuration = ValueConfiguration()
            } else {
                configuration = KeyedConfiguration()
                configuration.key = key ?? .named(nil)
            }
            
            configuration.abbr = abbr
            configuration.help = help
            return configuration
        })
    }
    
    func makeSet(key: String) -> ComponentInfo {
        return configuration.toInfo(originKey: key)
    }
}

// MARK: - Optional

@propertyWrapper
public struct Optional<T:StringConvertable>: Decodable, ComponentInfoProvider {
    
    var _wrappedValue: ArgumentValue<T> = .define
    
    public var wrappedValue: T? {
        set { _wrappedValue = .value(newValue!) }
        get {
            if case let .value(v) = _wrappedValue {
                return v
            }
            return nil
        }
    }
    
    public var configuration: ArgumentConfiguration = PlaceholderConfiguration()
    
    public init(_ building: () -> ArgumentConfiguration) {
        self.configuration = building()
        self.configuration.optional = true
    }
    
    public init(key: ArgumentKey? = nil, abbr: Character? = nil, help: String? = nil) {
        self.init({
            let configuration: ArgumentConfiguration
            if let _key = key, case .null = _key {
                configuration = ValueConfiguration()
            } else {
                configuration = KeyedConfiguration()
                configuration.key = key ?? .named(nil)
            }
            
            configuration.abbr = abbr
            configuration.help = help
            return configuration
        })
    }
    
    public init(from decoder: Decoder) throws {
        if let _decoder = decoder as? ArgumentDecoder {
            if let value = _decoder.value as? String {
                if let _value = T(value) {
                    self.wrappedValue = _value
                }
            }
        }
    }
    
    func makeSet(key: String) -> ComponentInfo { configuration.toInfo(originKey: key) }
}

// MARK: - Flag

public class FlagConfiguration {
    
    public var key: String?
    public var abbr: Character?
    public var help: String?
    
    public init() {}
    
    @discardableResult public func keyed(_ key: String) -> Self { self.key = key; return self }
    
    @discardableResult public func abbr(_ abbr: Character) -> Self { self.abbr = abbr; return self }
    
    @discardableResult public func help(_ help: String) -> Self { self.help = help; return self }
    
    func toInfo(originKey: String) -> FlagInfo {
        var info = FlagInfo(key: self.key ?? originKey)
        info.abbr = self.abbr
        info.help = self.help
        info.originKey = originKey
        return info
    }
}

@propertyWrapper
public struct Flag: Decodable, ComponentInfoProvider {
    
    public var wrappedValue: Bool = false
    
    public var configuration = FlagConfiguration()

    public init(from decoder: Decoder) throws {
        if let _decoder = decoder as? ArgumentDecoder {
            self.wrappedValue = _decoder.flag
        }
    }
    
    public init(_ building: () -> FlagConfiguration) {
        self.configuration = building()
    }
    
    public init(key: String? = nil, abbr: Character? = nil, help: String? = nil) {
        let configuration = FlagConfiguration()
        configuration.key = key
        configuration.abbr = abbr
        configuration.abbr = abbr
        self.configuration = configuration
    }
    
    func makeSet(key: String) -> ComponentInfo { configuration.toInfo(originKey: key) }
}
