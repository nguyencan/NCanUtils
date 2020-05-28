//
//  Int_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 5/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

public extension Int {
    
    var bitwiseString: String {
        return String(self, radix: 2)
    }
    
    var bitwiseArray: [Bool] {
        let array = Array(bitwiseString.reversed())
        var result: [Bool] = []
        for element in array {
            let num = Int(String(element)) ?? 0
            result.append(num > 0)
        }
        return result
    }
    
    func bitwise(index: Int) -> Bool {
        let array = Array(bitwiseString.reversed())
        if index >= 0 && array.count > index {
            let element = array[index]
            let num = Int(String(element)) ?? 0
            if num > 0 {
                return true
            }
        }
        return false
    }
}
