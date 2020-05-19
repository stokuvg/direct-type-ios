//
//  Date+Extensions.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/12.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class DateHelper {
    class func convStr2Date(_ buf: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let date = formatter.date(from: buf) ?? Date(timeIntervalSince1970: 0)
        return date
    }
    class func convDate2Str(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let buf = formatter.string(from: date)
        return buf
    }
    class func dateTimeFormatterYmdJP() -> DateFormatter {
         let dateTimeFormatter = DateFormatter()
         dateTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
         dateTimeFormatter.dateFormat = "YYYY年M月d日"
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
        print("\t[\(self.description)]\t[\(buf)]")
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
