//
//  JSONDecoder+Extesion.swift
//  JSONCodable
//
//  Created by Hackice on 2019/6/20.
//  Copyright © 2019 Hackice. All rights reserved.
//

protocol DefaultCodingKey: CodingKey {
    var defaultValue: Any? { get }
}

extension KeyedDecodingContainer {
    
    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(Int.self, forKey: key) {
            return String(value)
        }
        if let value = try? decode(Double.self, forKey: key) {
            return String(value)
        }
        if let key = key as? DefaultCodingKey, let value = key.defaultValue {
            return value as? String
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Int(value)
        }
        if let key = key as? DefaultCodingKey, let value = key.defaultValue {
            return value as? Int
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Double(value)
        }
        if let key = key as? DefaultCodingKey, let value = key.defaultValue {
            return value as? Double
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Float(value)
        }
        if let key = key as? DefaultCodingKey, let value = key.defaultValue {
            return value as? Float
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            if let valueInt = Int(value) {
                return Bool(valueInt != 0)
            }
            return nil
        }
        if let value = try? decode(Int.self, forKey: key) {
            return Bool(value != 0)
        }
        if let key = key as? DefaultCodingKey, let value = key.defaultValue {
            return value as? Bool
        }
        return nil
    }
    
    func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        let value = try? decode(type, forKey: key)
        if value != nil {
            return value
        }
        if let key = key as? DefaultCodingKey, let value = key.defaultValue {
            return value as? T
        }
        return value
    }
}
