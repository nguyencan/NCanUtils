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
    
    public enum Lang: String {
        case en = "en"
        case vi = "vi"
    }
    
    static let supportedLanguages = [
        Lang.en.rawValue
        , Lang.vi.rawValue
    ]
    static let AppleLanguagesKey = "AppleLanguages"
    
    /// NCanUtils: Configure custom language for app
    ///
    /// - Call in AppDelegate:application(didFinishLaunchingWithOptions)
    ///
    public static func configureAppLanguage() {
        if let language = UserDefaults.getAppLanguage() {
            if !supportedLanguages.contains(language) {
                // Set default language
                setDefaultLanguage()
            }
        } else {
            // Set default language
            setDefaultLanguage()
        }
        // Register to load right target's language
        method_exchangeImplementations(
            class_getInstanceMethod(Bundle.self, #selector(Bundle.localizedString(forKey:value:table:)))!,
            class_getInstanceMethod(Bundle.self, #selector(Bundle.kd_localizedStringForKey(key:value:table:)))!
        )
    }
    
    static func setDefaultLanguage() {
        let pre = NSLocale.preferredLanguages[0]
        if isVN(pre) {
            UserDefaults.setAppLanguage(Lang.vi)
        } else {
            UserDefaults.setAppLanguage(Lang.en)
        }
    }
    
    static func isVN(_ language: String) -> Bool {
        if language.lowercased().hasPrefix("vn") || language.lowercased().hasPrefix("vi") {
            return true
        } else {
            return false
        }
    }
}

extension UserDefaults {
    
    static func getDeviceLanguage() -> String? {
        if let languages = UserDefaults.standard.object(forKey: LanguageUtility.AppleLanguagesKey) as? [String] {
            return languages.first
        }
        return nil
    }
    
    public static func setAppLanguage(_ language: LanguageUtility.Lang) -> Void {
        setAppLanguage(language.rawValue)
    }
    
    public static func setAppLanguage(_ languageName: String) -> Void {
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
    
    public static func getAppLanguage() -> String? {
        if let languages = UserDefaults.standard.object(forKey: LanguageUtility.AppleLanguagesKey) as? [String] {
            if languages.count > 0  {
                return languages[0]
            }
        }
        return nil
    }
    
    public static func getUserLanguage() -> String {
        if let language = UserDefaults.getAppLanguage() {
            if LanguageUtility.isVN(language) {
                return "vn"
            } else {
                return "en"
            }
        } else {
            let pre = NSLocale.preferredLanguages[0]
            if LanguageUtility.isVN(pre) {
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
        if let language = UserDefaults.getDeviceLanguage() {
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
