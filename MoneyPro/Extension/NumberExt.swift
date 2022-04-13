//
//  IntExt.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 11/04/2022.
//

import Foundation

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3
//        numberFormatter.groupingSeparator = ","
        return numberFormatter.string(for: self) ?? ""
    }
}

extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3
//        numberFormatter.groupingSeparator = ","
        return numberFormatter.string(for: self) ?? ""
    }
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
