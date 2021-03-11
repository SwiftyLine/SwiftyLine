//
//  File.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/11.
//

import Foundation

final class CommandDecoder: Decoder {
    
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(CommandKeyedDecodingContainer(codingPath: [CodingKey]()))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw Error.topLevelHasNoUnkeyedContainer
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw Error.topLevelHasNoSingleValueContainer
    }
    
    init() {
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
    
    var allKeys: [K] {
        fatalError()
    }
    
    init(codingPath: [CodingKey]) {
        self.codingPath = codingPath
    }
    
    func contains(_ key: K) -> Bool {
        return false
    }
    
    func decodeNil(forKey key: K) throws -> Bool {
        return !contains(key)
    }
    
    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
        return try! T.init(from: try! self.superDecoder())
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
    
//    typealias Key = K
    
}
