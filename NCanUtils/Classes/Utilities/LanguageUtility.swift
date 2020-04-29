//
//  LanguageUtility.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/29/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

public class LanguageUtility {
    
    static let supportedLanguages = ["en", "vi"]
    static let AppleLanguagesKey = "AppleLanguages"
    
    static func configureAppLanguage() {
        if let language = UserDefaults.getDeviceLanguage() {
            if !supportedLanguages.contains(language) {
                // Set default language
                let pre = NSLocale.preferredLanguages[0]
                if pre.lowercased().hasPrefix("vn") || pre.lowercased().hasPrefix("vi") {
                    UserDefaults.setDeviceLanguage("vi")
                } else {
                    UserDefaults.setDeviceLanguage("en")
                }
            }
        } else {
            // Set default language
            let pre = NSLocale.preferredLanguages[0]
            if pre.lowercased().hasPrefix("vn") || pre.lowercased().hasPrefix("vi") {
                UserDefaults.setDeviceLanguage("vi")
            } else {
                UserDefaults.setDeviceLanguage("en")
            }
        }
        method_exchangeImplementations(
            class_getInstanceMethod(Bundle.self, #selector(Bundle.localizedString(forKey:value:table:)))!,
            class_getInstanceMethod(Bundle.self, #selector(Bundle.kd_localizedStringForKey(key:value:table:)))!
        )
    }
}

public extension UserDefaults {
    
    static func getAppleLanguage() -> String? {
        if let languages = UserDefaults.standard.object(forKey: LanguageUtility.AppleLanguagesKey) as? [String] {
            return languages.first
        }
        return nil
    }
    
    static func setDeviceLanguage(_ languageName : String) -> Void {
        if let value = UserDefaults.standard.object(forKey: LanguageUtility.AppleLanguagesKey) as? [String] {
            var languages = value
            if let index = languages.firstIndex(of: languageName) {
                let languageSelected = languages[index]
                languages.remove(at: index)
                languages.insert(languageSelected, at: 0)
            }
            else {
                languages.insert(languageName, at: 0)
            }
            standard.set(languages, forKey: LanguageUtility.AppleLanguagesKey)
            standard.synchronize()
        }
    }
    
    static func getDeviceLanguage() -> String? {
        if let languages = UserDefaults.standard.object(forKey: LanguageUtility.AppleLanguagesKey) as? [String] {
            if languages.count > 0  {
                return languages[0]
            }
        }
        return nil
    }
    
    static func getUserLanguage() -> String {
        if let language = UserDefaults.getDeviceLanguage() {
            if language.hasPrefix("vi") || language.hasPrefix("vn") {
                return "vn"
            } else {
                return "en"
            }
        } else {
            let pre = NSLocale.preferredLanguages[0]
            if pre.lowercased().hasPrefix("vn") || pre.lowercased().hasPrefix("vi") {
                return "vn"
            } else {
                return "en"
            }
        }
    }
}

extension Bundle {

    @objc func kd_localizedStringForKey(key: String, value: String?, table tableName: String?) -> String {
        // Prepare default return value
        var valueToReturn : String = (value != nil && value != "") ? value! : key
        // Get return value for special supported table strings if needs
        if let language = UserDefaults.getAppleLanguage() {
            if let path = Bundle.main.path(forResource: language, ofType: "lproj") {
                if let bundle = Bundle(path: path) {
                    if let table = tableName, let value = getLocalizedString(key, table: table, bundle: bundle) {
                        valueToReturn = value
                    } else if let value = getLocalizedString(key, table: "Localizable", bundle: bundle) {
                        valueToReturn = value
                    }
                }
            }
        }
        return valueToReturn
    }
    
    private func getLocalizedString(_ key: String, table: String, bundle: Bundle) -> String? {
        var result: String? = nil
        if let path = bundle.path(forResource: table, ofType: "strings") {
            let dictionary = NSDictionary(contentsOfFile: path)
            if let value = dictionary?[key] as? String {
                result = value
            }
        }
        return result
    }
}
