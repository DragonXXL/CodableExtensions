//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public enum JSONCodable: Codable, Equatable, Hashable {
    case null
    case int(Int)
    case double(Double)
    case bool(Bool)
    case string(String)
    indirect case array([JSONCodable])
    indirect case dictionary([String: JSONCodable])

    // MARK: - Value

    public var value: Any? {
        switch self {
        case .null:
            return nil
        case let .int(value):
            return value
        case let .double(value):
            return value
        case let .bool(value):
            return value
        case let .string(value):
            return value
        case let .array(value):
            return value.map({ $0.value })
        case let .dictionary(value):
            return value.mapValues({ $0.value })
        }
    }

    // MARK: - Init

    public init?(_ value: Any) {
        switch value {
        case let int as Int:
            self = .int(int)
        case let double as Double:
            self = .double(double)
        case let bool as Bool:
            self = .bool(bool)
        case let string as String:
            self = .string(string)
        case let array as [Any]:
            self = .array(array.compactMap({ JSONCodable($0) }))
        case let dictionary as [String: Any]:
            self = .dictionary(dictionary.compactMapValues({ JSONCodable($0) }))
        default:
            return nil
        }
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let array = try? container.decode([JSONCodable].self) {
            self = .array(array)
        } else if let dictionary = try? container.decode([String: JSONCodable].self) {
            self = .dictionary(dictionary)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "JsonValue value cannot be decoded")
        }
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .null:
            try container.encodeNil()
        case let .int(value):
            try container.encode(value)
        case let .double(value):
            try container.encode(value)
        case let .bool(value):
            try container.encode(value)
        case let .string(value):
            try container.encode(value)
        case let .array(value):
            try container.encode(value)
        case let .dictionary(value):
            try container.encode(value)
        }
    }
}

// MARK: - Literal extensions

extension JSONCodable: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension JSONCodable: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .double(value)
    }
}

extension JSONCodable: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

extension JSONCodable: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension JSONCodable: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: JSONCodable...) {
        self = .array(elements)
    }
}

extension JSONCodable: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSONCodable)...) {
        self = .dictionary([String: JSONCodable](elements, uniquingKeysWith: { first, _ in first }))
    }
}

// MARK: - Dictionary extensions

extension Dictionary where Key == String, Value == Any {
    public func mapJsonValues() -> [String: JSONCodable] {
        self.compactMapValues({ JSONCodable($0) })
    }
}

extension Dictionary where Key == String, Value == JSONCodable {
    public func mapAnyValues() -> [String: Any] {
        self.compactMapValues({ $0.value })
    }
}
