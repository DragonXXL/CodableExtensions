//
//  DecodableDefault.swift
//
//  Created by XuXiaoLong on 19/10/2024.
//

import Foundation

// MARK: - Codable仅支持默认值
// 例: @Default.EmptyInt var foo: Int?
public enum Default {
    @propertyWrapper
    public struct Wrapper<Source: DecodableDefaultSource> {
        public typealias Value = Source.Value
        public var wrappedValue = Source.defaultValue

        public init(wrappedValue: Source.Value = Source.defaultValue) {
            self.wrappedValue = wrappedValue
        }
    }
}

extension Default.Wrapper: Equatable where Value: Equatable {}

extension Default.Wrapper: Hashable where Value: Hashable {}

extension Default.Wrapper: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

public protocol DecodableDefaultSource {

    associatedtype Value: Decodable

    static var defaultValue: Value { get }
}

extension Default.Wrapper: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(Value.self)
    }
}


public extension KeyedDecodingContainer {
    func decode<T>(_ type: Default.Wrapper<T>.Type,
                   forKey key: Key) throws -> Default.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}

public extension Default {

    typealias EmptyList<T: List> = Wrapper<Sources.EmptyList<T>>

    typealias EmptyMap<T: Map> = Wrapper<Sources.EmptyMap<T>>

    typealias EmptyFloat = Wrapper<Sources.EmptyFloat>

    typealias EmptyCGFloat = Wrapper<Sources.EmptyCGFloat>

    typealias EmptyString = Wrapper<Sources.EmptyString>

    typealias EmptyInt = Wrapper<Sources.EmptyInt>

    typealias EmptyIntOne = Wrapper<Sources.EmptyIntOne>

    typealias EmptyDouble = Wrapper<Sources.EmptyDouble>

    typealias EmptyInt64 = Wrapper<Sources.EmptyInt64>

    typealias True = Wrapper<Sources.True>

    typealias False = Wrapper<Sources.False>

    typealias Source = DecodableDefaultSource

    typealias Map = Decodable & ExpressibleByDictionaryLiteral

    typealias List = Decodable & ExpressibleByArrayLiteral

    enum Sources {

        public enum EmptyList<T: List>: Source {
            public static var defaultValue: T { [] }
        }

        public enum EmptyMap<T: Map>: Source {
            public static var defaultValue: T { [:] }
        }

        public enum EmptyInt: Source {
            public static var defaultValue: Int { 0 }
        }

        public enum EmptyInt64: Source {
            public static var defaultValue: Int64 { 0 }
        }

        public enum EmptyIntOne: Source {
            public static var defaultValue: Int { 1 }
        }

        public enum EmptyFloat: Source {
            public static var defaultValue: Float { 0.0 }
        }

        public enum EmptyDouble: Source {
            public static var defaultValue: Double { 0.00000 }
        }

        public enum EmptyCGFloat: Source {
            public static var defaultValue: CGFloat { 0.0 }
        }

        public enum EmptyString: Source {
            public static var defaultValue: String { "" }
        }

        public enum True: Source {
            public static var defaultValue: Bool { true }
        }

        public enum False: Source {
            public static var defaultValue: Bool { false }
        }
    }
}

// MARK: - Codable同时支持默认值和Combine得 @Published属性数据流

/// 例:
///
///     @DefaultPublished.EmptyInt var foo: Int?
///
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum DefaultPublished {
    @propertyWrapper
    public class Wrapper<Source: PublishedCodableDefaultSource>: Codable {
        typealias Value = Source.Value
        @Published public var wrappedValue = Source.defaultValue

        public var projectedValue: Wrapper {
            return self
        }

        required public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            wrappedValue = try container.decode(Value.self)
        }

        public init() {}

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(wrappedValue)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol PublishedCodableDefaultSource {

    associatedtype Value: Codable

    static var defaultValue: Value { get }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension DefaultPublished {

    typealias EmptyList<T: List> = Wrapper<Sources.EmptyList<T>>

    typealias EmptyMap<T: Map> = Wrapper<Sources.EmptyMap<T>>

    typealias EmptyFloat = Wrapper<Sources.EmptyFloat>

    typealias EmptyCGFloat = Wrapper<Sources.EmptyCGFloat>

    typealias EmptyString = Wrapper<Sources.EmptyString>

    typealias EmptyInt = Wrapper<Sources.EmptyInt>

    typealias EmptyIntOne = Wrapper<Sources.EmptyIntOne>

    typealias EmptyDouble = Wrapper<Sources.EmptyDouble>

    typealias EmptyInt64 = Wrapper<Sources.EmptyInt64>

    typealias True = Wrapper<Sources.True>

    typealias False = Wrapper<Sources.False>

    typealias Map = Codable & ExpressibleByDictionaryLiteral

    typealias List = Codable & ExpressibleByArrayLiteral

    typealias Source = PublishedCodableDefaultSource

    enum Sources {

        public enum EmptyList<T: List>: Source {
            public static var defaultValue: T { [] }
        }

        public enum EmptyMap<T: Map>: Source {
            public static var defaultValue: T { [:] }
        }

        public enum EmptyInt: Source {
            public static var defaultValue: Int { 0 }
        }

        public enum EmptyInt64: Source {
            public static var defaultValue: Int64 { 0 }
        }

        public enum EmptyIntOne: Source {
            public static var defaultValue: Int { 1 }
        }

        public enum EmptyFloat: Source {
            public static var defaultValue: Float { 0.0 }
        }

        public enum EmptyDouble: Source {
            public static var defaultValue: Double { 0.00000 }
        }

        public enum EmptyCGFloat: Source {
            public static var defaultValue: CGFloat { 0.0 }
        }

        public enum EmptyString: Source {
            public static var defaultValue: String { "" }
        }

        public enum True: Source {
            public static var defaultValue: Bool { true }
        }

        public enum False: Source {
            public static var defaultValue: Bool { false }
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension KeyedDecodingContainer {
    func decode<T>(_ type: DefaultPublished.Wrapper<T>.Type,
                   forKey key: Key) throws -> DefaultPublished.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private class PublishedWrapper<T> {
    @Published private(set) var value: T

    init(_ value: Published<T>) {
        _value = value
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Published {
    var unofficialValue: Value {
        PublishedWrapper(self).value
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Published: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        self.init(wrappedValue: try Value.init(from: decoder))
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Published: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        try unofficialValue.encode(to: encoder)
    }
}
