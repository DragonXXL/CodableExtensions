//
//  DecodableDefault.swift
//
//  Created by XuXiaoLong on 19/10/2024.
//

import Foundation


// MARK: - Codable仅支持默认值
// 例: @Default.EmptyInt var foo: Int?
enum Default {}

extension Default.Wrapper: Equatable where Value: Equatable {}


extension Default.Wrapper: Hashable where Value: Hashable {}

extension Default.Wrapper: Encodable where Value: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

protocol DecodableDefaultSource {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}


extension Default.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(Value.self)
    }
}


extension KeyedDecodingContainer {
    func decode<T>(_ type: Default.Wrapper<T>.Type,
                   forKey key: Key) throws -> Default.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}


extension Default {
    @propertyWrapper
    struct Wrapper<Source: DecodableDefaultSource> {
        typealias Value = Source.Value
        var wrappedValue = Source.defaultValue
    }
}


extension Default {


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

        enum EmptyList<T: List>: Source {
            static var defaultValue: T { [] }
        }

        enum EmptyMap<T: Map>: Source {
            static var defaultValue: T { [:] }
        }


        enum EmptyInt: Source {
            static var defaultValue: Int { 0 }
        }

        enum EmptyInt64: Source {
            static var defaultValue: Int64 { 0 }
        }

        enum EmptyIntOne: Source {
            static var defaultValue: Int { 1 }
        }

        enum EmptyFloat: Source {
            static var defaultValue: Float { 0.0 }
        }

        enum EmptyDouble: Source {
            static var defaultValue: Double { 0.00000 }
        }

        enum EmptyCGFloat: Source {
            static var defaultValue: CGFloat { 0.0 }
        }

        enum EmptyString: Source {
            static var defaultValue: String { "" }
        }


        enum True: Source {
            static var defaultValue: Bool { true }
        }

        enum False: Source {
            static var defaultValue: Bool { false }
        }


    }
}

// MARK: - Codable同时支持默认值和Combine得 @Published属性数据流

/// 例:
///
///     @DefaultPublished.EmptyInt var foo: Int?
///
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
enum DefaultPublished {
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
protocol PublishedCodableDefaultSource {
    associatedtype Value: Codable

    static var defaultValue: Value { get }
}
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension DefaultPublished {
    @propertyWrapper
    class Wrapper<Source: PublishedCodableDefaultSource>: Codable {
        typealias Value = Source.Value
        @Published var wrappedValue = Source.defaultValue

        var projectedValue: Wrapper {
            return self
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            wrappedValue = try container.decode(Value.self)
        }

        init() {

        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(wrappedValue)
        }
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension DefaultPublished {
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

        enum EmptyList<T: List>: Source {
            static var defaultValue: T { [] }
        }

        enum EmptyMap<T: Map>: Source {
            static var defaultValue: T { [:] }
        }


        enum EmptyInt: Source {
            static var defaultValue: Int { 0 }
        }



        enum EmptyInt64: Source {
            static var defaultValue: Int64 { 0 }
        }

        enum EmptyIntOne: Source {
            static var defaultValue: Int { 1 }
        }

        enum EmptyFloat: Source {
            static var defaultValue: Float { 0.0 }
        }


        enum EmptyDouble: Source {
            static var defaultValue: Double { 0.00000 }
        }

        enum EmptyCGFloat: Source {
            static var defaultValue: CGFloat { 0.0 }
        }


        enum EmptyString: Source {
            static var defaultValue: String { "" }
        }


        enum True: Source {
            static var defaultValue: Bool { true }
        }

        enum False: Source {
            static var defaultValue: Bool { false }
        }

    }

}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension KeyedDecodingContainer {
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


