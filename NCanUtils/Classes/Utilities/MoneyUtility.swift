//
//  MoneyUtility.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/29/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

import Foundation

public class Money {
    
    static func formatForPrice(money: Float, currency: String?) -> String {
        return format(money: Double(money), currency: currency, default: "FREE")
    }
    
    static func formatForPrice(money: Double, currency: String?) -> String {
        return format(money: money, currency: currency, default: "FREE")
    }
    
    static func formatForOutcome(money: Float, currency: String?) -> String {
        return format(money: Double(money), prefix: "-", currency: currency)
    }
    
    static func formatForOutcome(money: Double, currency: String?) -> String {
        return format(money: money, prefix: "-", currency: currency)
    }
    
    static func formatForIncome(money: Float, currency: String?) -> String {
        return format(money: Double(money), prefix: "+", currency: currency)
    }
    
    static func formatForIncome(money: Double, currency: String?) -> String {
        return format(money: money, prefix: "+", currency: currency)
    }
    
    static func format(money: Float, prefix: String? = nil, currency: String? = nil, default defaultResult: String? = nil) -> String {
        return format(money: Double(money), prefix: prefix, currency: currency, default: defaultResult)
    }
    
    static func format(money: Double, prefix: String? = nil, currency: String? = nil, default defaultResult: String? = nil) -> String {
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
    
    static func collapse(money: Float?, default defaultResult: String = "") -> String {
        if let value = money {
            return collapse(money: Double(value), default: defaultResult)
        } else {
            return defaultResult
        }
    }
    
    static func collapse(money: Double?, default defaultResult: String = "") -> String {
        if let value = money {
            let thousandNum: Double = value/1000
            let millionNum: Double = value/1000000
            if value >= 1000 && value < 1000000 {
                if (floor(thousandNum) == thousandNum) {
                    return "\(Int(thousandNum))K"
                }
                return "\(roundToPlaces(double: thousandNum, places: 1))K"
            } else if value >= 1000000 {
                if (floor(millionNum) == millionNum) {
                    return "\(Int(millionNum))M"
                }
                return "\(roundToPlaces(double: millionNum, places: 1))M"
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
