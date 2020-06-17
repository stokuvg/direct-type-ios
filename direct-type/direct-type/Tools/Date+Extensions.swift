//
//  Date+Extensions.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/12.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class DateHelper {
    class func convStrYMD2Date(_ buf: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let date = formatter.date(from: buf) ?? Constants.SelectItemsUndefineDate
        return date
    }
    class func convStrYM2Date(_ buf: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDashSeparatorInDate]
        let date = formatter.date(from: buf) ?? Constants.SelectItemsUndefineDate
        return date
    }
    class func dateTimeFormatterYmdJP() -> DateFormatter {
         let dateTimeFormatter = DateFormatter()
         dateTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
         dateTimeFormatter.dateFormat = "YYYY年M月d日"
         dateTimeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
         return dateTimeFormatter
     }
    class func dateTimeFormatterYmJP() -> DateFormatter {
         let dateTimeFormatter = DateFormatter()
         dateTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
         dateTimeFormatter.dateFormat = "YYYY年M月"
         dateTimeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
         return dateTimeFormatter
     }
}

extension Date {
    var calendarJP: Calendar {
        var calendarJP = Calendar(identifier: .gregorian)
        calendarJP.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        calendarJP.locale   = Locale(identifier: "ja_JP")
        return calendarJP
    }
    //日本時刻(localTZ)で表示するようにしておく
    func dispYmdJP() -> String {
        let dateFormat = DateHelper.dateTimeFormatterYmdJP()
        let buf = dateFormat.string(from: self)
        return buf
    }
    func dispYmd() -> String {
        let formatter = ISO8601DateFormatter()
        //formatter.formatOptions = [.withFullDate]
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]
        let buf: String = formatter.string(from: self)
        return buf
    }
    func dispYmJP() -> String {
        if self == Constants.DefaultSelectWorkPeriodEndDate {
            return Constants.DefaultSelectWorkPeriodEndDateJP
        }
        let dateFormat = DateHelper.dateTimeFormatterYmJP()
        let buf = dateFormat.string(from: self)
        return buf
    }
    func dispYm() -> String {
        let formatter = ISO8601DateFormatter()
        //formatter.formatOptions = [.withFullDate]
        formatter.formatOptions = [.withYear, .withMonth, .withDashSeparatorInDate]
        let buf: String = formatter.string(from: self)
        return buf
    }
    func dispYear() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withDashSeparatorInDate]
        let buf: String = formatter.string(from: self)
        return buf
    }
    func dispMonth() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withMonth, .withDashSeparatorInDate]
        let buf: String = formatter.string(from: self)
        return buf
    }

    func dispHomeDate() -> String {
        
        let formatter:DateFormatter = DateFormatter()
        // 曜日を漢字で出すために、設定
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "M月d日 EEE曜日 HH:mm"
        
        return formatter.string(from: self)
    }
}

extension Date {
    var age: Int {
        if let _age = Calendar.current.dateComponents([.year], from: self, to: Date()).year {
            return _age
        }
        return 0
    }
}
