//
//  Utils.swift
//  App
//
//  Created by David Freifeld on 8/22/23.
//

import Foundation

struct StringUtils {
    static func formatNumber(value: Double, decimalPlaces: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimalPlaces
        return formatter.string(from: NSNumber(value: value))!
    }
    
    static func getSubstringAtEnd(value: String, characters: Int = 6) -> String.SubSequence {
        let index = value.index(value.endIndex, offsetBy: -characters)
        return value[index...]
    }
}
