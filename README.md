# CodableExtensions
### DecodableDefault.swift 主要功能

Codable仅支持默认值
```
// 例:
class foo: Codable {
  @Default.EmptyInt var foo: Int?
}
```
Codable同时支持默认值和Combine的 @Published属性数据流
```
// 例:
class foo: Codable {
  @DefaultPublished.EmptyInt var foo: Int?
}
```
### JSON.swift 主要功能
```
{
  "foo1": "1"
  "foo2" : {"foo": 1}
}
// 如果希望foo2只希望是解码Dictionary, 属性必须都遵循Codable协议，解码会报错不支持类型Any
class foo: Codable {
  var foo1: String?
  var foo2: [String: Any]?
}

// 使用JSON代替Any
class foo: Codable {
  var foo1: String?
  var foo2: [String: JSON]?
}
// 如果想获取原始类型
foo2.dictionaryValue
foo2.mapAnyValues()

```
