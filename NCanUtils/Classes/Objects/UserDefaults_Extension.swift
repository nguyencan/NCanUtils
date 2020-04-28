//
//  UserDefaults_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/27/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

public extension UserDefaults {
    
    /// Allows storing of Codable objects to UserDefaults.
    ///
    /// - Parameters:
    ///   - value: Codable object to store.
    ///   - key: Identifier of the object.
    func setCodable<T: Codable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            set(data, forKey: key)
        }
    }
    
    /// Retrieves a Codable object from UserDefaults.
    ///
    /// - Parameters:
    ///   - type: Class that conforms to the Codable protocol.
    ///   - key: Identifier of the object.
    /// - Returns: Codable object for key (if exists).
    func getCoable<T>(_ type: T.Type, forKey key: String) -> T? where T : Decodable {
        guard let encodedData = data(forKey: key) else {
            return nil
        }
        return try! JSONDecoder().decode(type, from: encodedData)
    }
    
    /// Allows storing list of Codable object to UserDefaults.
    ///
    /// - Parameters:
    ///   - value: List of Codable object to store.
    ///   - key: Identifier of the object.
    func setCodableArray<T: Codable>(_ value: [T], forKey key: String) {
        let data = value.map { try? JSONEncoder().encode($0) }
        set(data, forKey: key)
    }
    
    /// Retrieves a list of Codable object from UserDefaults.
    ///
    /// - Parameters:
    ///   - type: Class that conforms to the Codable protocol.
    ///   - key: Identifier of the object.
    /// - Returns: list of Codable object for key (if exists).
    func getCodableArray<T>(_ type: T.Type, forKey key: String) -> [T] where T : Decodable {
        guard let encodedData = array(forKey: key) as? [Data] else {
            return []
        }
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
    
    /// Date from UserDefaults.
    ///
    /// - Parameter key: key to find date for.
    /// - Returns: Date object for key (if exists).
    func date(forKey key: String) -> Date? {
        return object(forKey: key) as? Date
    }
}
