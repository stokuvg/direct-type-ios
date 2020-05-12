//
//  Date+Extensions.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/12.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class DateHelper {
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
}



