//
//  String_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/26/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

public extension String {

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
    
    func containsPlain(_ string: String) -> Bool {
        let diacriticSelf = self.lowercased().folding(options: .diacriticInsensitive, locale: .current).replacingOccurrences(of: "đ", with: "d")
        let diacriticString = string.lowercased().folding(options: .diacriticInsensitive, locale: .current).replacingOccurrences(of: "đ", with: "d")
        if diacriticSelf.contains(diacriticString) {
            return true
        }
        return false
    }
    
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
}

// MARK: - String:Validate
public extension String {
    
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
    
    var isMail: Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        
        return NSPredicate.test(self, pattern: emailRegEx)
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
extension String {
    
    public func sha256() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
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
