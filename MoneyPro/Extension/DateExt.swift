//
//  DateExt.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 03/04/2022.
//

import Foundation
import SwiftUI

extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
    static let iso8601UTC: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
    
    static let gregorianUTC: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
}

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
        return Calendar.gregorianUTC.date(from: Calendar.gregorianUTC.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfWeek() -> Date {
        return Calendar.gregorianUTC.date(byAdding: DateComponents(day: 6), to: self.startOfWeek())!
    }
}
