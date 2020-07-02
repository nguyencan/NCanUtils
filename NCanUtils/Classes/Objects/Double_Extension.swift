//
//  Double_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/29/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

public extension Double {
    
    /// NCanUtils: To string without unvalue characters
    ///
    ///        let a: Double = 1.0
    ///        a.clean -> "1"
    ///
    ///        let b: Double = 1.05
    ///        b.clean -> "1.05"
    ///
    ///        let c: Double = 1.050
    ///        c.clean -> "1.05"
    ///
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

