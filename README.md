# CodableExtensions
### DecodableDefault.swift 主要功能

Codable仅支持默认值0
```
// 例: 
@Default.EmptyInt var foo: Int?
```
Codable同时支持默认值和Combine的 @Published属性数据流
```
// 例:
@DefaultPublished.EmptyInt var foo: Int?
```
### JSON.swift 主要功能
```
{
  "foo1": "1"
  "foo" : {"foo": 1}
}
// 如果希望foo只希望是Dictinary, 解码会报错不支持类型Any
class foo: Codable {
  var foo1: String?
  var foo: [String: Any]?
}

// 使用JSON代替Any
class foo: Codable {
  var foo1: String?
  var foo: [String: JSON]?
}
// 如果想获取原始类型
foo.dictionaryValue
foo.mapAnyValues()

```
