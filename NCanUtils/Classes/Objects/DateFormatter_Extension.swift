//
//  DateFormatter_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/29/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

public extension DateFormatter {
    
    enum Format: String {
        case fullSZ = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case fullS = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case full = "yyyy-MM-dd'T'HH:mm:ss"
        case short = "yyyy-MM-dd"
        case date = "dd/MM/yyyy"
        case timeFull = "HH:mm:ss"
        case timeShort = "HH:mm"
    }
    
    static func date(string: String) -> Date? {
        if string.isEmpty {
            return nil
        }
        let formats: [String] = [
            Format.fullSZ.rawValue,
            Format.fullS.rawValue,
            Format.full.rawValue,
            Format.short.rawValue,
            Format.date.rawValue
        ]
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale as Locale?
        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: string) {
                return date
            }
        }
        return nil
    }
    
    static func date(string: String, format: Format) -> Date? {
        return date(string: string, format: format.rawValue)
    }
    
    static func date(string: String, format: String) -> Date? {
        if string.isEmpty {
            return nil
        }
        if format.isEmpty {
            return date(string: string)
        }
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale as Locale?
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: string) {
            return date
        }
        return nil
    }
    
    static func displayDate(_ date: Date) -> String {
        return string(date, format: .date)
    }
    
    static func displayTime(_ date: Date) -> String {
        return string(date, format: .timeFull)
    }
    
    static func string(_ date: Date, format: Format) -> String {
        return string(date, format: format.rawValue)
    }
    
    static func string(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
