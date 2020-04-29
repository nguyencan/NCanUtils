//
//  String_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/26/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

#if canImport(CoreGraphics)
import CoreGraphics
#endif

#if canImport(CommonCrypto)
import CommonCrypto
#endif

public extension String {
    
    enum CompareType {
        case equal, equalPlain
        case contain, containPlain
    }

    func toDictionary() -> [String: Any] {
        if let data = self.data(using: .utf8) {
            do {
                return try (JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:])
            } catch {
                return [:]
            }
        }
        return [:]
    }
    
    func toDouble(default defaultNumber: Double = 0) -> Double {
        if let num = Double(self) {
            return num
        }
        return defaultNumber
    }
    
    func toFloat(default defaultNumber: Float = 0) -> Float {
        if let num = Float(self) {
            return num
        }
        return defaultNumber
    }
    
    func toInt(default defaultNumber: Int = 0) -> Int {
        if let num = Int(self) {
            return num
        }
        return defaultNumber
    }
    
    func isValidNumericsPassword(limit: Int) -> Bool {
        if isEmpty {
            return true
        } else if count <= limit, Int(self) != nil {
            return true
        }
        return false
    }
    
    func upercaseOnlyFirst() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst()).lowercased()
        return first + other
    }
    
    mutating func upercaseOnlyFirst() {
        self = self.upercaseOnlyFirst()
    }
    
    func compare(_ string: String, type: CompareType) -> Bool {
        if type == .contain {
            return contains(string)
        } else if type == .equal {
            return self == string
        } else {
            let diacriticSelf = self.lowercased().folding(options: .diacriticInsensitive, locale: .current).replacingOccurrences(of: "đ", with: "d")
            let diacriticString = string.lowercased().folding(options: .diacriticInsensitive, locale: .current).replacingOccurrences(of: "đ", with: "d")
            if type == .containPlain {
                return diacriticSelf.contains(diacriticString)
            } else {
                return diacriticSelf == diacriticString
            }
        }
    }
    
    #if canImport(UIKit)
    func boldFor(_ strings: [String], with font: UIFont, exactText: Bool) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self, attributes: [.font: font])
        for text in strings {
            if text.isEmpty {
                continue
            }
            let ranges: [NSRange]
            if exactText {
                ranges = attributedString.string.rangesOfExactString(findStr: text)
            } else {
                ranges = attributedString.string.rangesOfPlainString(findStr: text)
            }
            for range in ranges {
               attributedString.addAttribute(.font, value: font.toBold(), range: range)
            }
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 5
        paragraphStyle.lineSpacing = 1
        paragraphStyle.lineBreakMode = .byTruncatingTail
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: self.count))
        
        return attributedString
    }
    #endif
    
    /// NCanUtils: Safely subscript string with index.
    ///
    ///        "Hello World!"[safe: 3] -> "l"
    ///        "Hello World!"[safe: 20] -> nil
    ///
    /// - Parameter index: index.
    subscript(safe index: Int) -> Character? {
        guard index >= 0 && index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }

    /// NCanUtils: Safely subscript string within a given range.
    ///
    ///        "Hello World!"[safe: 6..<11] -> "World"
    ///        "Hello World!"[safe: 21..<110] -> nil
    ///
    ///        "Hello World!"[safe: 6...11] -> "World!"
    ///        "Hello World!"[safe: 21...110] -> nil
    ///
    /// - Parameter range: Range expression.
    subscript<R>(safe range: R) -> String? where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: Int.min..<Int.max)
        guard range.lowerBound >= 0,
            let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex),
            let upperIndex = index(startIndex, offsetBy: range.upperBound, limitedBy: endIndex) else {
                return nil
        }

        return String(self[lowerIndex..<upperIndex])
    }
    
    #if os(iOS) || os(macOS)
    /// NCanUtils: Copy string to global pasteboard.
    ///
    ///        "SomeText".copyToPasteboard() // copies "SomeText" to pasteboard
    ///
    func copyToPasteboard() {
        #if os(iOS)
        UIPasteboard.general.string = self
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(self, forType: .string)
        #endif
    }
    #endif
    
    #if canImport(Foundation)
    /// NCanUtils: Array of strings separated by new lines.
    ///
    ///        "Hello\ntest".lines() -> ["Hello", "test"]
    ///
    /// - Returns: Strings separated by new lines.
    func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
    #endif
    
    #if canImport(Foundation)
    /// NCanUtils: an array of all words in a string
    ///
    ///        "Swift is amazing".words() -> ["Swift", "is", "amazing"]
    ///
    /// - Returns: The words contained in a string.
    func words() -> [String] {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    #endif
    
    #if canImport(Foundation)
    /// NCanUtils: Count of words in a string.
    ///
    ///        "Swift is amazing".wordsCount() -> 3
    ///
    /// - Returns: The count of words contained in a string.
    func wordCount() -> Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }
    #endif
    
    #if canImport(Foundation)
    /// NCanUtils: Count of substring in string.
    ///
    ///        "Hello World!".count(of: "o") -> 2
    ///        "Hello World!".count(of: "L", caseSensitive: false) -> 3
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: count of appearance of substring in string.
    func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive {
            return lowercased().components(separatedBy: string.lowercased()).count - 1
        }
        return components(separatedBy: string).count - 1
    }
    #endif

    /// NCanUtils: Check if string starts with substring.
    ///
    ///        "hello World".starts(with: "h") -> true
    ///        "hello World".starts(with: "H", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string starts with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string starts with substring.
    func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }
    
    /// NCanUtils: Check if string ends with substring.
    ///
    ///        "Hello World!".ends(with: "!") -> true
    ///        "Hello World!".ends(with: "WoRld!", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string ends with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string ends with substring.
    func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }
    
    /// NCanUtils: Random string of given length.
    ///
    ///        String.random(ofLength: 18) -> "u7MMZYvGo9obcOcPj8"
    ///
    /// - Parameter length: number of characters in string.
    /// - Returns: random string of given length.
    static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(base.randomElement()!)
        }
        return randomString
    }

    /// NCanUtils: Reverse string.
    @discardableResult
    mutating func reverse() -> String {
        let chars: [Character] = reversed()
        self = String(chars)
        return self
    }
    
    #if canImport(Foundation)
    /// NCanUtils: Removes spaces and new lines in beginning and end of string.
    ///
    ///        var str = "  \n Hello World \n\n\n"
    ///        str.trim()
    ///        print(str) // prints "Hello World"
    ///
    @discardableResult
    mutating func trim() -> String {
        self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return self
    }
    #endif
    
    /// NCanUtils: Truncate string (cut it to a given number of characters).
    ///
    ///        var str = "This is a very long sentence"
    ///        str.truncate(toLength: 14)
    ///        print(str) // prints "This is a very..."
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string (default is "...").
    @discardableResult
    mutating func truncate(toLength length: Int, trailing: String? = "...") -> String {
        guard length > 0 else { return self }
        if count > length {
            self = self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
        }
        return self
    }

    /// NCanUtils: Truncated string (limited to a given number of characters).
    ///
    ///        "This is a very long sentence".truncated(toLength: 14) -> "This is a very..."
    ///        "Short sentence".truncated(toLength: 14) -> "Short sentence"
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string.
    /// - Returns: truncated string (this is an extr...).
    func truncated(toLength length: Int, trailing: String? = "...") -> String {
        guard 1..<count ~= length else { return self }
        return self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
    }
}

// MARK: - String:Validate
public extension String {
    
    /// NCanUtils: First character of string (if applicable).
    ///
    ///        "Hello".firstCharacterAsString -> Optional("H")
    ///        "".firstCharacterAsString -> nil
    ///
    var firstCharacterAsString: String? {
        guard let first = first else { return nil }
        return String(first)
    }
    
    /// NCanUtils: Last character of string (if applicable).
    ///
    ///        "Hello".lastCharacterAsString -> Optional("o")
    ///        "".lastCharacterAsString -> nil
    ///
    var lastCharacterAsString: String? {
        guard let last = last else { return nil }
        return String(last)
    }

    #if canImport(Foundation)
    /// NCanUtils: Bool value from string (if applicable).
    ///
    ///        "1".bool -> true
    ///        "False".bool -> false
    ///        "Hello".bool = nil
    ///
    var bool: Bool? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch selfLowercased {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    #endif
    
    /// NCanUtils: Check if string contains one or more letters.
    ///
    ///        "123abc".hasLetters -> true
    ///        "123".hasLetters -> false
    ///
    var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }

    /// NCanUtils: Check if string contains one or more numbers.
    ///
    ///        "abcd".hasNumbers -> false
    ///        "123abc".hasNumbers -> true
    ///
    var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    
    #if canImport(Foundation)
    /// NCanUtils: Latinized string.
    ///
    ///        "Hèllö Wórld!".latinized -> "Hello World!"
    ///
    var latinized: String {
        return folding(options: .diacriticInsensitive, locale: Locale.current)
    }
    #endif

    /// NCanUtils: Check if string contains only letters.
    ///
    ///        "abc".isAlphabetic -> true
    ///        "123abc".isAlphabetic -> false
    ///
    var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }

    /// NCanUtils: Check if string contains at least one letter and one number.
    ///
    ///        // useful for passwords
    ///        "123abc".isAlphaNumeric -> true
    ///        "abc".isAlphaNumeric -> false
    ///
    var isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    var isAllDigits: Bool {
        if self.isEmpty {
            return false
        }
        let charcterSet  = NSCharacterSet(charactersIn: "0123456789").inverted
        let filtered = components(separatedBy: charcterSet).joined()
        return  self == filtered
    }
    
    var isNumberic: Bool {
        let numberRegEx = "^(?:(\\+|\\-))([0-9]\\d*)(?:\\.\\d*)?$";
        return NSPredicate.test(self, pattern: numberRegEx)
    }
    
    var isVietnamPhone: Bool {
        let phoneRegEx = "^(\\+84|0)[1-9]{1}\\d{8}"
        return NSPredicate.test(self, pattern: phoneRegEx)
    }
    
    var isPhone: Bool {
        let phoneRegEx = "^((((\\+)|(00))[0-9]{6,14}$)|((0)[1-9]{1}\\d{8}))"
        return NSPredicate.test(self, pattern: phoneRegEx)
    }
    
    var isValidMail: Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        
        return NSPredicate.test(self, pattern: emailRegEx)
    }
    
    #if canImport(Foundation)
    /// NCanUtils: Check if string is a valid URL.
    ///
    ///        "https://google.com".isValidUrl -> true
    ///
    var isValidUrl: Bool {
        return URL(string: self) != nil
    }
    #endif
    
    #if canImport(Foundation)
    /// NCanUtils: Check if string is a valid schemed URL.
    ///
    ///        "https://google.com".isValidSchemedUrl -> true
    ///        "google.com".isValidSchemedUrl -> false
    ///
    var isValidSchemedUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }
    #endif

    #if canImport(Foundation)
    /// NCanUtils: Check if string is a valid https URL.
    ///
    ///        "https://google.com".isValidHttpsUrl -> true
    ///
    var isValidHttpsUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }
    #endif

    #if canImport(Foundation)
    /// NCanUtils: Check if string is a valid http URL.
    ///
    ///        "http://google.com".isValidHttpUrl -> true
    ///
    var isValidHttpUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }
    #endif

    #if canImport(Foundation)
    /// NCanUtils: Check if string is a valid file URL.
    ///
    ///        "file://Documents/file.txt".isValidFileUrl -> true
    ///
    var isValidFileUrl: Bool {
        return URL(string: self)?.isFileURL ?? false
    }
    #endif
    
    #if canImport(Foundation)
    /// NCanUtils: URL from string (if applicable).
    ///
    ///        "https://google.com".url -> URL(string: "https://google.com")
    ///        "not url".url -> nil
    ///
    var url: URL? {
        return URL(string: self)
    }
    #endif

    #if canImport(Foundation)
    /// NCanUtils: String with no spaces or new lines in beginning and end.
    ///
    ///        "   hello  \n".trimmed -> "hello"
    ///
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    #endif

    #if canImport(Foundation)
    /// NCanUtils: Readable string from a URL string.
    ///
    ///        "it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
    ///
    var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    #endif

    #if canImport(Foundation)
    /// NCanUtils: URL escaped string.
    ///
    ///        "it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    #endif

    #if canImport(Foundation)
    /// NCanUtils: String without spaces and new lines.
    ///
    ///        "   \n Swifter   \n  Swift  ".withoutSpacesAndNewLines -> "NCanUtils"
    ///
    var withoutSpacesAndNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    #endif

    #if canImport(Foundation)
    /// NCanUtils: Check if the given string contains only white spaces
    var isWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    #endif
    
    /// NCanUtils: Pad string to fit the length parameter size with another string in the start.
    ///
    ///   "hue".padStart(10) -> "       hue"
    ///   "hue".padStart(10, with: "br") -> "brbrbrbhue"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    @discardableResult
    mutating func padStart(_ length: Int, with string: String = " ") -> String {
        self = paddingStart(length, with: string)
        return self
    }

    /// NCanUtils: Returns a string by padding to fit the length parameter size with another string in the start.
    ///
    ///   "hue".paddingStart(10) -> "       hue"
    ///   "hue".paddingStart(10, with: "br") -> "brbrbrbhue"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the start.
    func paddingStart(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)] + self
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)] + self
        }
    }

    /// NCanUtils: Pad string to fit the length parameter size with another string in the start.
    ///
    ///   "hue".padEnd(10) -> "hue       "
    ///   "hue".padEnd(10, with: "br") -> "huebrbrbrb"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    @discardableResult
    mutating func padEnd(_ length: Int, with string: String = " ") -> String {
        self = paddingEnd(length, with: string)
        return self
    }

    /// NCanUtils: Returns a string by padding to fit the length parameter size with another string in the end.
    ///
    ///   "hue".paddingEnd(10) -> "hue       "
    ///   "hue".paddingEnd(10, with: "br") -> "huebrbrbrb"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the end.
    func paddingEnd(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return self + string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)]
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return self + padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)]
        }
    }

    /// NCanUtils: Removes given prefix from the string.
    ///
    ///   "Hello, World!".removingPrefix("Hello, ") -> "World!"
    ///
    /// - Parameter prefix: Prefix to remove from the string.
    /// - Returns: The string after prefix removing.
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    /// NCanUtils: Removes given suffix from the string.
    ///
    ///   "Hello, World!".removingSuffix(", World!") -> "Hello"
    ///
    /// - Parameter suffix: Suffix to remove from the string.
    /// - Returns: The string after suffix removing.
    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    /// NCanUtils: Adds prefix to the string.
    ///
    ///     "www.apple.com".withPrefix("https://") -> "https://www.apple.com"
    ///
    /// - Parameter prefix: Prefix to add to the string.
    /// - Returns: The string with the prefix prepended.
    func withPrefix(_ prefix: String) -> String {
        guard !hasPrefix(prefix) else { return self }
        return prefix + self
    }
}

extension NSPredicate {
    
    fileprivate static func test(_ text: String, pattern: String) -> Bool {
        let string = text.trimmingCharacters(in: .whitespaces)
        if string.isEmpty {
            return false
        }
        let predicate = NSPredicate(format:"SELF MATCHES %@", pattern)
        return predicate.evaluate(with: string)
    }
}

// MARK: - String:Open
extension String {
    
    public enum OpenType {
        case website, mail, call
    }
    
    #if canImport(UIKit)
    public func open(type: OpenType) {
        let urlStr: String
        if type == .call {
            urlStr = "tel://\(self.removeCharsNotIn("0123456789+"))"
        } else if type == .mail {
            urlStr = "mailto://\(self)"
        } else {
            urlStr = "\(self)"
        }
        if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    #endif
    
    private func removeCharsNotIn(_ satisfiedChars: String) -> String {
        let okayChars: Set<Character> = Set(satisfiedChars)
        return String(self.filter { okayChars.contains($0) })
    }
}

// MARK: - String:Range
extension String {
    
    public func rangesOfPlainString(findStr: String) -> [NSRange] {
        let diacriticSelf = self.lowercased().folding(options: .diacriticInsensitive, locale: .current).replacingOccurrences(of: "đ", with: "d")
        let diacriticString = findStr.lowercased().folding(options: .diacriticInsensitive, locale: .current).replacingOccurrences(of: "đ", with: "d")
        
        return rangesOfString(source: diacriticSelf, findStr: diacriticString)
    }
    
    public func rangesOfExactString(findStr: String) -> [NSRange] {
        return rangesOfString(source: self, findStr: findStr)
    }
    
    private func rangesOfString(source: String, findStr: String) -> [NSRange] {
        if !source.contains(findStr) {
            return []
        }
        var arr = [NSRange]()
        var startInd = source.startIndex
        // check first that the first character of search string exists
        if let firstChar = findStr.first, source.contains(firstChar) {
            // if so set this as the place to start searching
            startInd = source.firstIndex(of: firstChar)!
        } else {
            // if not return empty array
            return arr
        }
        var i = source.distance(from: startIndex, to: startInd)
        while i <= source.count - findStr.count {
            if source[source.index(startIndex, offsetBy: i)..<source.index(startIndex, offsetBy: i + findStr.count)] == findStr {
                let range = NSRange(location: i, length: findStr.count)
                arr.append(range)
                
                i = i + findStr.count
            } else {
                i += 1
            }
        }
        return arr
    }
}

// MARK: - String:Encrypt
public extension String {
    
    #if canImport(Foundation)
    /// NCanUtils: String decoded from base64 (if applicable).
    ///
    ///        "SGVsbG8gV29ybGQh".base64Decoded = Optional("Hello World!")
    ///
    var base64Decoded: String? {
        let remainder = count % 4

        var padding = ""
        if remainder > 0 {
            padding = String(repeating: "=", count: 4 - remainder)
        }
        guard let data = Data(base64Encoded: self + padding,
                              options: .ignoreUnknownCharacters) else { return nil }

        return String(data: data, encoding: .utf8)
    }
    #endif

    #if canImport(Foundation)
    /// NCanUtils: String encoded in base64 (if applicable).
    ///
    ///        "Hello World!".base64Encoded -> Optional("SGVsbG8gV29ybGQh")
    ///
    var base64Encoded: String? {
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    #endif
    
    #if canImport(CommonCrypto)
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    #endif
    
    #if canImport(CommonCrypto)
    func sha256() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    #endif
    
    #if canImport(CommonCrypto)
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    #endif
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        return hexString
    }
}

// MARK: - Operators
public extension String {

    /// NCanUtils: Repeat string multiple times.
    ///
    ///        'bar' * 3 -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: string to repeat.
    ///   - rhs: number of times to repeat character.
    /// - Returns: new string with given string repeated n times.
    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }

    /// NCanUtils: Repeat string multiple times.
    ///
    ///        3 * 'bar' -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: number of times to repeat character.
    ///   - rhs: string to repeat.
    /// - Returns: new string with given string repeated n times.
    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }

}
