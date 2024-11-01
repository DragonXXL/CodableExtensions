//
//  ResponseUtils.swift
//
//  Created by XuXiaoLong on 19/10/2024.
//


import Foundation

extension Decodable {

    var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }

    var dictionary: [String: Any]? {
        var dictionary = [String: Any]()
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            let name = child.label!
            dictionary[name] = child.value
        }
        if dictionary.keys.count > 0 {
            return dictionary
        }
        return nil
    }
    
}


extension Array {

    func model<T: Decodable>(_ type: T.Type) -> T? {
        if let jsonData = data {
            return jsonData.model(T.self)
        }
        debugPrint("Array解析失败\(self)")
        return nil
    }

    func toJSONString() -> String? {
        if !JSONSerialization.isValidJSONObject(self) {
            debugPrint("Array转json失败")
            return nil
        }
        if let jsonData = data {
            let JSONString = String(data: jsonData, encoding: .utf8)
            return JSONString
        }
        debugPrint("Arrayt转json失败")
        return nil
    }

    var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}


extension String {

    func toDict() -> [String: Any]? {
        guard let jsonData: Data = data(using: .utf8) else {
            debugPrint("jsonString转dict失败")
            return nil
        }
        if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            return dict as? [String: Any] ?? ["": ""]
        }
        debugPrint("jsonString转dict失败")
        return nil
    }

    func toArray() -> [Any]? {
        guard let jsonData: Data = data(using: .utf8) else {
            debugPrint("jsonString转Array失败")
            return nil
        }
        if let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            return array as? [Any] ?? [""]
        }
        debugPrint("jsonString转Array失败")
        return nil
    }

    /// json字符串转模型
    func model<T: Decodable>(_ type: T.Type) -> T? {
        if let jsonData = data(using: .utf8) {
            return jsonData.model(type)
        }
        debugPrint("解析失败\(self)")
        return nil
    }

}


extension Data {

    func utf8String() -> String? {
        if let utf8 = String(data: self, encoding: .utf8) {
            return utf8
        }
        return nil
    }

    var toDict: [String: Any]? {
        if !JSONSerialization.isValidJSONObject(self) {
            debugPrint("jsonData转dict失败")
            return nil
        }
        if let dict = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) {
            return dict as? [String: Any] ?? ["": ""]
        }
        debugPrint("jsonData转dict失败")
        return nil
    }

    var toArray: [Any]? {
        if !JSONSerialization.isValidJSONObject(self) {
            debugPrint("jsonData转Array失败")
            return nil
        }

        if let array = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) {
            return array as? [Any] ?? [""]
        }
        debugPrint("jsonData转Array失败")
        return nil
    }

    /// json data 转模型
    /// 可以直接拿网络请求成功的response直接转换
    func model<T: Decodable>(_ type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch let err {
            debugPrint("[jsonData] 解析失败\(String(describing: self.utf8String())) ---- error: \(err)")
            return nil
        }
    }

}


extension Dictionary {

    func toJSONString() -> String? {
        if !JSONSerialization.isValidJSONObject(self) {
            debugPrint("dict转json失败\(self)")
            return nil
        }
        if let jsonData = data {
            let JSONString = String(data: jsonData, encoding: .utf8)
            return JSONString
        }
        debugPrint("dict转json失败\(self)")
        return nil
    }

    var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }

    func model<T: Decodable>(_ type: T.Type) -> T? {
        if let jsonData = data {
            return jsonData.model(T.self)
        }
        debugPrint("dict解析失败\(self)")
        return nil
    }

}


struct ResponseModel<T>: Codable where T: Codable {

    var error: String?

    var data: T?

    /// 0以上为正常, -20为未知错误，-10表示有错误详情
    var code: Int = -10

    var headerToken: String?

    var message: [String]?

    var msg: String? {
        if code != 0 {
//            return LaunchCore.textFori18nConfig(code: "\(code)", messages: message)
        }
        return nil
    }

}

struct ResponseData: Codable {}

class ResponsePageData<T: Codable>: Codable {
    var arrays: [T]?
    @Default.EmptyIntOne var current = 1
    @Default.EmptyInt var total = 0
    @Default.EmptyInt var totalPage = 0
}
