//
//  File.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/11.
//

import Foundation

final class CommandDecoder: Decoder {
    
    var result: ParseResult
    
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(CommandKeyedDecodingContainer(codingPath: [], result: result))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw Error.topLevelHasNoUnkeyedContainer
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw Error.topLevelHasNoSingleValueContainer
    }
    
    init(result: ParseResult) {
        self.result = result
    }
}

extension CommandDecoder {
    enum Error: Swift.Error {
        case topLevelHasNoUnkeyedContainer
        case topLevelHasNoSingleValueContainer
    }
}

final class CommandKeyedDecodingContainer<K>: KeyedDecodingContainerProtocol where K : CodingKey  {
    
    var codingPath: [CodingKey]
    let result: ParseResult
    
    var allKeys: [K] {
        fatalError()
    }
    
    init(codingPath: [CodingKey], result: ParseResult) {
        self.codingPath = codingPath
        self.result = result
    }
    
    func contains(_ key: K) -> Bool {
        return false
    }
    
    func decodeNil(forKey key: K) throws -> Bool {
        return !contains(key)
    }
    
    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
        let decoder = ArgumentDecoder(codingPath: codingPath + [key], result: result)
        return try! T.init(from: decoder)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        fatalError()
    }
    
    func superDecoder() throws -> Decoder {
        fatalError()
    }
    
    func superDecoder(forKey key: K) throws -> Decoder {
        fatalError()
    }
    
}

final class ArgumentDecoder: Decoder {
    
    var codingPath: [CodingKey]
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    let result: ParseResult
    
    let coding: [String: Any]
    
    var key: String {
        return codingPath.last!.stringValue
    }
    
    var value: Any? {
        return result.arguments[key]
    }
    
    var flag: Bool {
        return result.flags.contains(key)
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        fatalError()
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }
    
    init(codingPath: [CodingKey], result: ParseResult) {
        self.codingPath = codingPath
        self.result = result
        var coding = [String: Any]()
        self.coding = coding
    }
    
}
