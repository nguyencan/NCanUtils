//
//  Dictionary_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/27/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

public extension NSDictionary {
    
    func contain(key: String) -> Bool {
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
