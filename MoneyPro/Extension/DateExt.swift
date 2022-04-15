//
//  DateExt.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 03/04/2022.
//

import Foundation
import SwiftUI

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Y"
        return dateFormatter.string(from: self)
    }
    
    func startOfWeek() -> Date {
       let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
       let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
       return date.addingTimeInterval(dslTimeOffset)
    }

    func endOfWeek() -> Date {
       return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek())!
    }
}
