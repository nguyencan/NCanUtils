//
//  MoneyUtility.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/29/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

import Foundation

// MARK: - Money:Double
public class Money {

    /// NCanUtils: Money string to double
    ///
    ///     Money.toDouble(money: "15.000,25") -> 15000.25
    ///     Money.toDouble(money: "15.000đ") -> 15000
    ///     Money.toDouble(money: "15,000.25", grouped: ",", decimal: ".") -> 15000
    ///     Money.toDouble(money: "15 000.25", grouped: " ", decimal: ".") -> 15000
    ///
    static public func toDouble(money: String
        , grouped: String = "."
        , decimal: String = ","
        , currency: String = "") -> Double {
        let str = replaceCharsBeforeFormat(money: money, grouped: grouped, decimal: decimal, currency: currency)
        if let money = Double(str) {
            return money
        } else {
            return Double(0)
        }
    }
    
    private static func replaceCharsBeforeFormat(money: String
        , grouped: String = "."
        , decimal: String = ","
        , currency: String = "") -> String {
        var result = money.replacingOccurrences(of: grouped, with: "")
        if !decimal.isEmpty {
            result = result.replacingOccurrences(of: decimal, with: ".")
        }
        if !currency.isEmpty {
            result = result.replacingOccurrences(of: currency, with: "")
        }
        return result
    }

    /// NCanUtils: format double to (price) money string
    ///
    ///     Money.formatForPrice(money: 15000) -> "15.000"
    ///     Money.formatForPrice(money: 0) -> "FREE"
    ///     Money.formatForPrice(money: 15000, currency: "đ") -> "15.000đ"
    ///
    static public func formatForPrice(money: Double, currency: String?) -> String {
        return format(money: money, currency: currency, default: "FREE")
    }

    /// NCanUtils: format double to (outcome) money string
    ///
    ///     Money.formatForOutcome(money: 15000) -> "-15.000"
    ///     Money.formatForOutcome(money: 0) -> "-"
    ///     Money.formatForOutcome(money: 15000, currency: "đ") -> "-15.000đ"
    ///
    static public func formatForOutcome(money: Double, currency: String?) -> String {
        return format(money: money, prefix: "-", currency: currency)
    }

    /// NCanUtils: format double to (income) money string
    ///
    ///     Money.formatForIncome(money: 15000) -> "+15.000"
    ///     Money.formatForIncome(money: 0) -> "-"
    ///     Money.formatForIncome(money: 15000, currency: "đ") -> "+15.000đ"
    ///
    static public func formatForIncome(money: Double, currency: String?) -> String {
        return format(money: money, prefix: "+", currency: currency)
    }

    /// NCanUtils: format double to money string
    ///
    ///     Money.format(money: 0, default: "ABC") -> "ABC"
    ///     Money.format(money: 0, prefix: "+", currency: "đ", default: "ABC") -> "ABC"
    ///     Money.format(money: 0) -> "0"
    ///     Money.format(money: 0, prefix: "+") -> "-"
    ///     Money.format(money: 0, prefix: "-") -> "-"
    ///     Money.format(money: 0, prefix: "+", currency: "đ") -> "0đ"
    ///     Money.format(money: 15000) -> "15.000"
    ///     Money.format(money: 15000, prefix: "-") -> "-15.000"
    ///     Money.format(money: 15000, currency: "đ") -> "15.000đ"
    ///     Money.format(money: 15000, prefix: "-", currency: "đ") -> "-15.000đ"
    ///     Money.format(money: 15000, prefix: "-", currency: "đ", default: "ABC") -> "-15.000đ"
    ///
    static public func format(money: Double, prefix: String? = nil, currency: String? = nil, default defaultResult: String? = nil) -> String {
        var result: String = ""
        if money != 0 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            formatter.decimalSeparator = ","
            result = formatter.string(from: NSNumber(value: money)) ?? ""
        }
        let mCurrency: String = currency ?? ""
        let mPrefix: String = prefix ?? ""
        
        if result.isEmpty {
            if let value = defaultResult, !value.isEmpty {
                result = value
            } else {
                if mPrefix == "+" || mPrefix == "-" {
                    result = "-"
                } else {
                    result = "0\(mCurrency)"
                }
            }
        } else {
            result = "\(mPrefix)\(result)\(mCurrency)"
        }
        return result
    }

    /// NCanUtils: format double to short money string
    ///
    ///     let nilValue: Double? = nil
    ///     Money.collapse(money: nilValue) -> ""
    ///     Money.collapse(money: nilValue, default: "ABC") -> "ABC"
    ///     Money.collapse(money: 0) -> "0"
    ///     Money.collapse(money: 0.050) -> "0.5"
    ///     Money.collapse(money: 100) -> "100"
    ///     Money.collapse(money: 1000) -> "1K"
    ///     Money.collapse(money: 1500) -> "1.5K"
    ///     Money.collapse(money: 1000000) -> "1M"
    ///     Money.collapse(money: 1005000 -> "1M
    ///     Money.collapse(money: 1050000 -> "1.1M
    ///     Money.collapse(money: 1500000 -> "1.5M
    ///
    static public func collapse(money: Double?, default defaultResult: String = "") -> String {
        if let value = money {
            let thousandNum: Double = value/1000
            let millionNum: Double = value/1000000
            if value >= 1000 && value < 1000000 {
                if (floor(thousandNum) == thousandNum) {
                    return "\(Int(thousandNum))K"
                }
                return "\(roundToPlaces(double: thousandNum, places: 1).clean)K"
            } else if value >= 1000000 {
                if (floor(millionNum) == millionNum) {
                    return "\(Int(millionNum))M"
                }
                return "\(roundToPlaces(double: millionNum, places: 1).clean)M"
            } else {
                return value.clean
            }
        } else {
            return defaultResult
        }
    }
    
    private static func roundToPlaces(double: Double, places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(double * divisor) / divisor
    }
}

// MARK: - Money:Float
extension Money {
    
    /// NCanUtils: Money string to float. Like toDouble function
    ///
    static public func toFloat(money: String
        , grouped: String = "."
        , decimal: String = ","
        , currency: String = "") -> Float {
        let str = replaceCharsBeforeFormat(money: money, grouped: grouped, decimal: decimal, currency: currency)
        if let money = Float(str) {
            return money
        } else {
            return Float(0)
        }
    }
    
    /// NCanUtils: format float to (price) money string. Like formatForPrice(double) function
    ///
    static public func formatForPrice(money: Float, currency: String?) -> String {
        return format(money: Double(money), currency: currency, default: "FREE")
    }
    
    /// NCanUtils: format float to (outcome) money string. Like formatForOutcome(double) function
    ///
    static public func formatForOutcome(money: Float, currency: String?) -> String {
        return format(money: Double(money), prefix: "-", currency: currency)
    }
    
    /// NCanUtils: format float to (income) money string. Like formatForIncome(double) function
    ///
    static public func formatForIncome(money: Float, currency: String?) -> String {
        return format(money: Double(money), prefix: "+", currency: currency)
    }
    
    /// NCanUtils: format float to money string. Like format(double) function
    ///
    static public func format(money: Float, prefix: String? = nil, currency: String? = nil, default defaultResult: String? = nil) -> String {
        return format(money: Double(money), prefix: prefix, currency: currency, default: defaultResult)
    }
    
    /// NCanUtils: format float to short money string. Like collapse(double) function
    ///
    static public func collapse(money: Float?, default defaultResult: String = "") -> String {
        if let value = money {
            return collapse(money: Double(value), default: defaultResult)
        } else {
            return defaultResult
        }
    }
}
