//
//  Int_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 5/28/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

public extension Int {
    
    /// NCanUtils: Bitwise string of integer
    ///
    ///        8.bitwiseString -> "1000"
    ///        9.bitwiseString -> "1001"
    ///
    var bitwiseString: String {
        return String(self, radix: 2)
    }
    
    /// NCanUtils: Bitwise value array of integer
    ///
    ///        8.bitwiseArray -> [false, false, false, true]
    ///        9.bitwiseArray -> [true, false, false, true]
    ///
    var bitwiseArray: [Bool] {
        let array = Array(bitwiseString.reversed())
        var result: [Bool] = []
        for element in array {
            let num = Int(String(element)) ?? 0
            result.append(num > 0)
        }
        return result
    }
    
    /// NCanUtils: Check bitwise at special index
    ///
    ///        8.bitwise(index: 0) -> false
    ///        8.bitwise(index: 1) -> false
    ///        8.bitwise(index: 2) -> false
    ///        8.bitwise(index: 3) -> true
    ///
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
    
    /// NCanUtils: Initilize integer with bitwise value array
    ///
    ///        Int(array: [false, false, false, true]) -> 8
    ///        Int(array: [true, false, false, true]) -> 9
    ///
    init(array: [Bool]) {
        var result: Double = 0
        for (index, value) in array.enumerated() {
            if value {
                result += pow(2, Double(index))
            }
        }
        self = Int(result)
    }
}
