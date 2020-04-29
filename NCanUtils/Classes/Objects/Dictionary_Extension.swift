//
//  Dictionary_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/27/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - NSDictionary
public extension NSDictionary {
    
    func has(key: String) -> Bool {
        guard let keys: [String] = self.allKeys as? [String] else {
            return false
        }
        return keys.contains(key)
    }
    
    func dictionary(forKey key: String) -> [String: Any]? {
        if let data = self[key] {
            if let value = data as? [String: Any] {
                return value
            }
        }
        return nil
    }
    
    func dictionaryValue(forKey key: String, default defaultValue: [String: Any] = [:]) -> [String: Any] {
        return dictionary(forKey: key) ?? defaultValue
    }
    
    func dictionary<T>(forKey key: String, type: T.Type) -> [String: T]? {
        if let data = self[key] {
            if let value = data as? [String: T] {
                return value
            }
        }
        return nil
    }
    
    func dictionaryValue<T>(forKey key: String, type: T.Type, default defaultValue: [String: T] = [:]) -> [String: T] {
        return dictionary(forKey: key, type: type) ?? defaultValue
    }
    
    func array<T>(forKey key: String, type: T.Type) -> [T]? {
        if let data = self[key] {
            if let value = data as? [T] {
                return value
            }
        }
        return nil
    }
    
    func arrayValue<T>(forKey key: String, type: T.Type, default defaultValue: [T] = []) -> [T] {
        return array(forKey: key, type: type) ?? defaultValue
    }
    
    func string(forKey key: String) -> String? {
        if let data = self[key] {
            if let value = data as? String {
                return value
            }
        }
        return nil
    }
    
    func stringValue(forKey key: String, default defaultValue: String = "") -> String {
        return string(forKey: key) ?? defaultValue
    }
    
    func int(forKey key: String) -> Int? {
        if let data = self[key] {
            if let value = data as? Int {
                return value
            } else if let value = data as? String {
                return Int(value)
            }
        }
        return nil
    }
    
    func intValue(forKey key: String, default defaultValue: Int = 0) -> Int {
        return int(forKey: key) ?? defaultValue
    }
    
    func float(forKey key: String) -> Float? {
        if let data = self[key] {
            if let value = data as? Float {
                return value
            } else if let value = data as? String {
                return Float(value)
            }
        }
        return nil
    }
    
    func floatValue(forKey key: String, default defaultValue: Float = 0) -> Float {
        return float(forKey: key) ?? defaultValue
    }
    
    func double(forKey key: String) -> Double? {
        if let data = self[key] {
            if let value = data as? Double {
                return value
            } else if let value = data as? String {
                return Double(value)
            }
        }
        return nil
    }
    
    func doubleValue(forKey key: String, default defaultValue: Double = 0) -> Double {
        return double(forKey: key) ?? defaultValue
    }
    
    func bool(forKey key: String) -> Bool? {
        if let data = self[key] {
            if let value = data as? Bool {
                return value
            } else if let value = data as? String {
                return Bool(value)
            }
        }
        return nil
    }
    
    func boolValue(forKey key: String, default defaultValue: Bool = false) -> Bool {
        return bool(forKey: key) ?? defaultValue
    }
    
    func date(forKey key: String) -> Date? {
        if let value = self[key] as? Date {
            return value
        }
        return nil
    }
}

// MARK: - Dictionary
public extension Dictionary {

    /// NCanUtils: Creates a Dictionary from a given sequence grouped by a given key path.
    ///
    /// - Parameters:
    ///   - sequence: Sequence being grouped
    ///   - keypath: The key path to group by.
    init<S: Sequence>(grouping sequence: S, by keyPath: KeyPath<S.Element, Key>) where Value == [S.Element] {
       self.init(grouping: sequence, by: { $0[keyPath: keyPath] })
    }

    /// NCanUtils: Check if key exists in dictionary.
    ///
    ///        let dict: [String: Any] = ["testKey": "testValue", "testArrayKey": [1, 2, 3, 4, 5]]
    ///        dict.has(key: "testKey") -> true
    ///        dict.has(key: "anotherKey") -> false
    ///
    /// - Parameter key: key to search for
    /// - Returns: true if key exists in dictionary.
    func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    func dictionary(forKey key: Key) -> [Key: Any]? {
        if let data = self[key] {
            if let value = data as? [Key: Any] {
                return value
            }
        }
        return nil
    }
    
    func dictionaryValue(forKey key: Key, default defaultValue: [Key: Any] = [:]) -> [Key: Any] {
        return dictionary(forKey: key) ?? defaultValue
    }
    
    func dictionary<T>(forKey key: Key, type: T.Type) -> [Key: T]? {
        if let data = self[key] {
            if let value = data as? [Key: T] {
                return value
            }
        }
        return nil
    }
    
    func dictionaryValue<T>(forKey key: Key, type: T.Type, default defaultValue: [Key: T] = [:]) -> [Key: T] {
        return dictionary(forKey: key, type: type) ?? defaultValue
    }
    
    func array<T>(forKey key: Key, type: T.Type) -> [T]? {
        if let data = self[key] {
            if let value = data as? [T] {
                return value
            }
        }
        return nil
    }
    
    func arrayValue<T>(forKey key: Key, type: T.Type, default defaultValue: [T] = []) -> [T] {
        return array(forKey: key, type: type) ?? defaultValue
    }
    
    func string(forKey key: Key) -> String? {
        if let data = self[key] {
            if let value = data as? String {
                return value
            }
        }
        return nil
    }
    
    func stringValue(forKey key: Key, default defaultValue: String = "") -> String {
        return string(forKey: key) ?? defaultValue
    }
    
    func int(forKey key: Key) -> Int? {
        if let data = self[key] {
            if let value = data as? Int {
                return value
            } else if let value = data as? String {
                return Int(value)
            }
        }
        return nil
    }
    
    func intValue(forKey key: Key, default defaultValue: Int = 0) -> Int {
        return int(forKey: key) ?? defaultValue
    }
    
    func float(forKey key: Key) -> Float? {
        if let data = self[key] {
            if let value = data as? Float {
                return value
            } else if let value = data as? String {
                return Float(value)
            }
        }
        return nil
    }
    
    func floatValue(forKey key: Key, default defaultValue: Float = 0) -> Float {
        return float(forKey: key) ?? defaultValue
    }
    
    func double(forKey key: Key) -> Double? {
        if let data = self[key] {
            if let value = data as? Double {
                return value
            } else if let value = data as? String {
                return Double(value)
            }
        }
        return nil
    }
    
    func doubleValue(forKey key: Key, default defaultValue: Double = 0) -> Double {
        return double(forKey: key) ?? defaultValue
    }
    
    func bool(forKey key: Key) -> Bool? {
        if let data = self[key] {
            if let value = data as? Bool {
                return value
            } else if let value = data as? String {
                return Bool(value)
            }
        }
        return nil
    }
    
    func boolValue(forKey key: Key, default defaultValue: Bool = false) -> Bool {
        return bool(forKey: key) ?? defaultValue
    }
    
    func date(forKey key: Key) -> Date? {
        if let value = self[key] as? Date {
            return value
        }
        return nil
    }

    /// NCanUtils: Remove all keys contained in the keys parameter from the dictionary.
    ///
    ///        var dict : [String: String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///        dict.removeAll(keys: ["key1", "key2"])
    ///        dict.keys.contains("key3") -> true
    ///        dict.keys.contains("key1") -> false
    ///        dict.keys.contains("key2") -> false
    ///
    /// - Parameter keys: keys to be removed
    mutating func removeAll<S: Sequence>(keys: S) where S.Element == Key {
        keys.forEach { removeValue(forKey: $0) }
    }

    /// NCanUtils: Remove a value for a random key from the dictionary.
    @discardableResult
    mutating func removeValueForRandomKey() -> Value? {
        guard let randomKey = keys.randomElement() else { return nil }
        return removeValue(forKey: randomKey)
    }

    #if canImport(Foundation)
    /// NCanUtils: JSON Data from dictionary.
    ///
    /// - Parameter prettify: set true to prettify data (default is false).
    /// - Returns: optional JSON Data (if applicable).
    func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
    #endif

    #if canImport(Foundation)
    /// NCanUtils: JSON String from dictionary.
    ///
    ///        dict.jsonString() -> "{"testKey":"testValue","testArrayKey":[1,2,3,4,5]}"
    ///
    ///        dict.jsonString(prettify: true)
    ///        /*
    ///        returns the following string:
    ///
    ///        "{
    ///        "testKey" : "testValue",
    ///        "testArrayKey" : [
    ///            1,
    ///            2,
    ///            3,
    ///            4,
    ///            5
    ///        ]
    ///        }"
    ///
    ///        */
    ///
    /// - Parameter prettify: set true to prettify string (default is false).
    /// - Returns: optional JSON String (if applicable).
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    #endif

    /// NCanUtils: Returns a dictionary containing the results of mapping the given closure over the sequence’s elements.
    /// - Parameter transform: A mapping closure. `transform` accepts an element of this sequence as its parameter and returns a transformed value of the same or of a different type.
    /// - Returns: A dictionary containing the transformed elements of this sequence.
    func mapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)) rethrows -> [K: V] {
        return [K: V](uniqueKeysWithValues: try map(transform))
    }

    /// NCanUtils: Returns a dictionary containing the non-`nil` results of calling the given transformation with each element of this sequence.
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an optional value.
    /// - Returns: A dictionary of the non-`nil` results of calling `transform` with each element of the sequence.
    /// - Complexity: *O(m + n)*, where _m_ is the length of this sequence and _n_ is the length of the result.
    func compactMapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)?) rethrows -> [K: V] {
        return [K: V](uniqueKeysWithValues: try compactMap(transform))
    }

}

// MARK: - Methods (Value: Equatable)
public extension Dictionary where Value: Equatable {

    /// NCanUtils: Returns an array of all keys that have the given value in dictionary.
    ///
    ///        let dict = ["key1": "value1", "key2": "value1", "key3": "value2"]
    ///        dict.keys(forValue: "value1") -> ["key1", "key2"]
    ///        dict.keys(forValue: "value2") -> ["key3"]
    ///        dict.keys(forValue: "value3") -> []
    ///
    /// - Parameter value: Value for which keys are to be fetched.
    /// - Returns: An array containing keys that have the given value.
    func keys(forValue value: Value) -> [Key] {
        return keys.filter { self[$0] == value }
    }

}

// MARK: - Methods (ExpressibleByStringLiteral)
public extension Dictionary where Key: StringProtocol {

    /// NCanUtils: Lowercase all keys in dictionary.
    ///
    ///        var dict = ["tEstKeY": "value"]
    ///        dict.lowercaseAllKeys()
    ///        print(dict) // prints "["testkey": "value"]"
    ///
    mutating func lowercaseAllKeys() {
        // http://stackoverflow.com/questions/33180028/extend-dictionary-where-key-is-of-type-string
        for key in keys {
            if let lowercaseKey = String(describing: key).lowercased() as? Key {
                self[lowercaseKey] = removeValue(forKey: key)
            }
        }
    }
}

// MARK: - Subscripts
public extension Dictionary {

    /// NCanUtils: Deep fetch or set a value from nested dictionaries.
    ///
    ///        var dict =  ["key": ["key1": ["key2": "value"]]]
    ///        dict[path: ["key", "key1", "key2"]] = "newValue"
    ///        dict[path: ["key", "key1", "key2"]] -> "newValue"
    ///
    /// - Note: Value fetching is iterative, while setting is recursive.
    ///
    /// - Complexity: O(N), _N_ being the length of the path passed in.
    ///
    /// - Parameter path: An array of keys to the desired value.
    ///
    /// - Returns: The value for the key-path passed in. `nil` if no value is found.
    subscript(path path: [Key]) -> Any? {
        get {
            guard !path.isEmpty else { return nil }
            var result: Any? = self
            for key in path {
                if let element = (result as? [Key: Any])?[key] {
                    result = element
                } else {
                    return nil
                }
            }
            return result
        }
        set {
            if let first = path.first {
                if path.count == 1, let new = newValue as? Value {
                    return self[first] = new
                }
                if var nested = self[first] as? [Key: Any] {
                    nested[path: Array(path.dropFirst())] = newValue
                    return self[first] = nested as? Value
                }
            }
        }
    }
}

// MARK: - Operators
public extension Dictionary {

    /// NCanUtils: Merge the keys/values of two dictionaries.
    ///
    ///        let dict: [String: String] = ["key1": "value1"]
    ///        let dict2: [String: String] = ["key2": "value2"]
    ///        let result = dict + dict2
    ///        result["key1"] -> "value1"
    ///        result["key2"] -> "value2"
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: dictionary
    /// - Returns: An dictionary with keys and values from both.
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }

    // MARK: - Operators
    /// NCanUtils: Append the keys and values from the second dictionary into the first one.
    ///
    ///        var dict: [String: String] = ["key1": "value1"]
    ///        let dict2: [String: String] = ["key2": "value2"]
    ///        dict += dict2
    ///        dict["key1"] -> "value1"
    ///        dict["key2"] -> "value2"
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: dictionary
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1}
    }

    /// NCanUtils: Remove keys contained in the sequence from the dictionary
    ///
    ///        let dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
    ///        let result = dict-["key1", "key2"]
    ///        result.keys.contains("key3") -> true
    ///        result.keys.contains("key1") -> false
    ///        result.keys.contains("key2") -> false
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: array with the keys to be removed.
    /// - Returns: a new dictionary with keys removed.
    static func - <S: Sequence>(lhs: [Key: Value], keys: S) -> [Key: Value] where S.Element == Key {
        var result = lhs
        result.removeAll(keys: keys)
        return result
    }

    /// NCanUtils: Remove keys contained in the sequence from the dictionary
    ///
    ///        var dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
    ///        dict-=["key1", "key2"]
    ///        dict.keys.contains("key3") -> true
    ///        dict.keys.contains("key1") -> false
    ///        dict.keys.contains("key2") -> false
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: array with the keys to be removed.
    static func -= <S: Sequence>(lhs: inout [Key: Value], keys: S) where S.Element == Key {
        lhs.removeAll(keys: keys)
    }

}
