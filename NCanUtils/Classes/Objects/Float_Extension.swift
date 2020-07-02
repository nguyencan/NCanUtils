//
//  Float_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/29/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

public extension Float {
    
    /// NCanUtils: To string without unvalue characters
    ///
    ///        let a: Float = 1.0
    ///        a.clean -> "1"
    ///
    ///        let b: Float = 1.05
    ///        b.clean -> "1.05"
    ///
    ///        let c: Float = 1.050
    ///        c.clean -> "1.05"
    ///
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
