//
//  JSON.swift
//
//  Created by XuXiaoLong on 19/10/2024.
//

import Foundation

///  JSONCodable编码 key 是String或Int类型
///
///      let json = JSON.init(["name": "foo"])
///      // 支持动态获取成员两种获取value方式
///      debugPrint("\(json?.name ?? "") == \(json?["name"] ?? "")")
///
@dynamicMemberLookup
enum JSON: Equatable, Hashable {
    // MARK: - members
    case null
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)
    indirect case object([Key: JSON])
    indirect case array([JSON])

    // MARK: - custom key

    struct Key: CodingKey, Hashable, CustomStringConvertible {
        var description: String {
            return stringValue
        }

        let stringValue: String
        init(_ string: String) { self.stringValue = string }
        init?(stringValue: String) { self.init(stringValue) }
        var intValue: Int? { return Int(stringValue) }
        init?(intValue: Int) { self.init("\(intValue)") }
    }

    // MARK: - var

    var isEmpty: Bool {
        switch self {
        case .string(let string): return string.isEmpty
        case .object(let object): return object.isEmpty
        case .array(let array): return array.isEmpty
        case .null: return true
        case .double, .bool, .int: return false
        }
    }

    var objectValue: [String: JSON]? {
        switch self {
        case .object(let object):
            let mapped: [String: JSON] = Dictionary(uniqueKeysWithValues:
                object.map { (key, value) in (key.stringValue, value) })
            return mapped
        default: return nil
        }
    }

    var arrayValue: [JSON]? {
        switch self {
        case .array(let array): return array
        default: return nil
        }
    }

    var stringValue: String? {
        switch self {
        case .string(let string): return string
        default: return nil
        }
    }

    var doubleValue: Double? {
        switch self {
        case .double(let double): return double
        default: return nil
        }
    }

    var intValue: Int? {
        switch self {
        case .int(let int): return int
        default: return nil
        }
    }

    var boolValue: Bool? {
        switch self {
        case .bool(let bool): return bool
        default: return nil
        }
    }

    var anyValue: Any? {
        switch self {
        case .null: return nil
        case .string(let string): return string
        case .double(let double): return double
        case .int(let int): return int
        case .bool(let bool): return bool
        case .array(let array):
            return array.compactMap{ $0.anyValue }
        case .object(let object):
            return Dictionary(uniqueKeysWithValues:
                                object.compactMap { (key, value) -> (String, Any)? in
                if let nonNilValue = value.anyValue {
                    return (key.stringValue, nonNilValue)
                } else { return nil }
            })
        }
    }

    var dictionaryValue: [String: Any]? {
        return anyValue as? [String: Any]
    }

    subscript(index: Int) -> JSON? {
        switch self {
        case .array(let array): return array[index]
        default: return nil
        }
    }

    subscript(key: String) -> JSON? {
        guard let jsonKey = Key(stringValue: key),
            case .object(let object) = self,
            let value = object[jsonKey]
            else { return nil }
        return value
    }

    subscript(dynamicMember member: String) -> JSON {
        return self[member] ?? .null
    }
}

// MARK: - init
extension JSON: Codable {

    public init?(_ value: Any) {
        switch value {
        case let string as String:
            self = .string(string)
        case let int as Int:
            self = .int(int)
        case let double as Double:
            self = .double(double)
        case let float as Float:
            self = .double(Double(float))
        case let float as CGFloat:
            self = .double(Double(float))
        case let bool as Bool:
            self = .bool(bool)
        case let array as [Any]:
            self = .array(array.compactMap(JSON.init))
        case let object as [String: Any]:
            var result: [Key: JSON] = [:]
            for (key, subValue) in object {
                result[Key(key)] = JSON(subValue)
            }
            self = .object(result)
        case let number as NSNumber:
            let numberStr = String(cString: number.objCType)
            if numberStr == "q" {
                self = .int(number.intValue)
            } else if numberStr == "c" {
                self = .bool(number.boolValue)
            } else {
                self = .double(number.doubleValue)
            }
        default:
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self) { self = .string(string) }
        else if let double = try? decoder.singleValueContainer().decode(Double.self) { self = .double(double) }
        else if let object = try? decoder.container(keyedBy: Key.self) {
            var result: [Key: JSON] = [:]
            for key in object.allKeys {
                result[key] = (try? object.decode(JSON.self, forKey: key)) ?? .null
            }
            self = .object(result)
        }
        else if var array = try? decoder.unkeyedContainer() {
            var result: [JSON] = []
            for _ in 0..<(array.count ?? 0) {
                result.append(try array.decode(JSON.self))
            }
            self = .array(result)
        }
        else if let bool = try? decoder.singleValueContainer().decode(Bool.self) { self = .bool(bool) }
        else if let isNull = try? decoder.singleValueContainer().decodeNil(), isNull { self = .null }
        else if let int = try? decoder.singleValueContainer().decode(Int.self) { self = .int(int) }
        else { throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [],
                                                                       debugDescription: "Unknown JSON type")) }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .string(let string):
            var container = encoder.singleValueContainer()
            try container.encode(string)
        case .double(let double):
            var container = encoder.singleValueContainer()
            try container.encode(double)
        case .int(let int):
            var container = encoder.singleValueContainer()
            try container.encode(int)
        case .bool(let bool):
            var container = encoder.singleValueContainer()
            try container.encode(bool)
        case .object(let object):
            var container = encoder.container(keyedBy: Key.self)
            for (key, value) in object {
                try container.encode(value, forKey: key)
            }
        case .array(let array):
            var container = encoder.unkeyedContainer()
            for value in array {
                try container.encode(value)
            }
        case .null:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}

// MARK: - description
extension JSON: CustomStringConvertible {

    var description: String {
        switch self {
        case .string(let string): return "\"\(string)\""
        case .double(let double):  return "\(double)"
        case .object(let object):
            let keyValues = object
                .map { (key, value) in "\"\(key)\": \(value)" }
                .joined(separator: ",")
            return "{\(keyValues)}"
        case .array(let array):
            return "\(array)"
        case .bool(let bool):
            return "\(bool)"
        case .null:
            return "null"
        case .int(let int):
            return "\(int)"
        }
    }
}

// MARK: - Literal extensions
extension JSON: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension JSON: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .double(value)
    }
}

extension JSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

extension JSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension JSON: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: JSON...) {
        self = .array(elements)
    }
}

extension JSON: ExpressibleByDictionaryLiteral {
    init(dictionaryLiteral elements: (Key, JSON)...) {
        self = .object([Key: JSON](elements, uniquingKeysWith: { first, _ in first }))
    }
}

extension JSONEncoder {
    func stringEncode<T>(_ value: T) throws -> String where T : Encodable {
        // JSONEncoder promises to always return UTF-8
        return String(data: try self.encode(value), encoding: .utf8)!
    }
}

// MARK: - Dictionary extensions

extension Dictionary where Key == String, Value == Any {
    internal func mapJsonValues() -> [String: JSON] {
        self.compactMapValues({ JSON($0) })
    }
}

extension Dictionary where Key == String, Value == JSON {
    internal func mapAnyValues() -> [String: Any] {
        return self.compactMapValues({ $0.anyValue })
    }
}
