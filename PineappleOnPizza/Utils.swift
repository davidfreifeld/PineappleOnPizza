//
//  Utils.swift
//  App
//
//  Created by David Freifeld on 8/22/23.
//

import Foundation

struct Utils {
    static func formatNumber(value: Double, decimalPlaces: Int = 2) -> String {
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
