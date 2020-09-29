//
//  TimeZone_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 9/29/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

public extension TimeZone {
    
    /// NCanUtils: Get offset of GMT TimeZone
    ///
    var offsetIntFromGMT: Int {
        let offsetSeconds = secondsFromGMT()
        let offsetHours = Int(offsetSeconds / 3600)
        
        return offsetHours
    }
    
    /// NCanUtils: Get offset of GMT TimeZone. Such as: "+07:00"
    ///
    var offsetStringFromGMT: String {
        var offsetSeconds = secondsFromGMT()
        var offsetString = "+00:00"
        var offsetSymbol = "+"
        var offsetHoursLeadString = "0"
        var offsetMinutesLeadString = "0"
        if offsetSeconds < 0 {
            offsetSymbol = "-"
            offsetSeconds = (-1)*offsetSeconds
        }
        let offsetHours = Int(offsetSeconds / 3600)
        let offsetMinutes = offsetSeconds - (offsetHours * 3600)
        if offsetHours > 10 {
            offsetHoursLeadString = ""
        }
        if offsetMinutes > 10 {
            offsetMinutesLeadString = ""
        }
        offsetString = String(format: "%@%@%i:%@%i", offsetSymbol, offsetHoursLeadString, offsetHours, offsetMinutesLeadString, offsetMinutes)
        return offsetString
    }
}
