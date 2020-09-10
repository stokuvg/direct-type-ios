//
//  Date+Extensions.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/12.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

// FIXME: DateUtil にリファクタリングすること
class DateHelper {
    class func dateTimeFormatterRecommendParam() -> DateFormatter {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateTimeFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        dateTimeFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return dateTimeFormatter
    }
    class func dateTimeFormatterFNameShort() -> DateFormatter {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateTimeFormatter.dateFormat = "yyyyMMddHH"
        dateTimeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateTimeFormatter
    }
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
        dateTimeFormatter.dateFormat = "yyyy年M月d日"
        dateTimeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateTimeFormatter
    }
    class func dateTimeFormatterYmJP() -> DateFormatter {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateTimeFormatter.dateFormat = "yyyy年M月"
        dateTimeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateTimeFormatter
    }
    class func dateTimeFormatterMdJP() -> DateFormatter {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateTimeFormatter.dateFormat = "M月d日"
        dateTimeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateTimeFormatter
    }

    class func dateStringChangeFormatString(dateString: String) -> String {
        if dateString.count == 0 {
            return ""
        }
        Log.selectLog(logLevel: .debug, "dateString:\(dateString)")

        var dateCutArr: [String] = []
        if (dateString.components(separatedBy: "-")).count > 1 {
            dateCutArr = dateString.components(separatedBy: "-")
        } else if (dateString.components(separatedBy: "/")).count > 1 {
            dateCutArr = dateString.components(separatedBy: "/")
        } else {
            dateCutArr = []
        }
        if dateCutArr.count == 0 {
            return dateString
        }

        return dateCutArr[0] + "年" + dateCutArr[1] + "月" + dateCutArr[2] + "日"
    }

    // 月,日を表示
    class func mdDateString(date: Date) -> String {
        let dateFormat = dateTimeFormatterMdJP()
        let dateString = dateFormat.string(from: date)
        return dateString
    }

    func makeDateArray(dateString: String) -> [String] {
        return []
    }

    class func newMarkFlagCheck(startDateString: String, nowDate: Date) -> Bool {
        var retInterval: Double!

        let startDate = DateHelper.convStrYMD2Date(startDateString)
        //        Log.selectLog(logLevel: .debug, "startDate:\(startDate)")

        retInterval = nowDate.timeIntervalSince(startDate)

        let ret = retInterval / 86400
//        Log.selectLog(logLevel: .debug, "ret:\(ret)")

        if 0 <= ret && ret <= 7 {
//            Log.selectLog(logLevel: .debug, "新着　７日以内 最新")
            return true
        }
        return false

    }

    class func endFlagHiddenCheck(endDateString: String, nowDate: Date) -> Bool {
        var retInterval: Double!

        let endDate = DateHelper.convStrYMD2Date(endDateString)
        //        Log.selectLog(logLevel: .debug, "endDate:\(endDate)")

        retInterval = endDate.timeIntervalSince(nowDate)

        let ret = retInterval / 86400
//            Log.selectLog(logLevel: .debug, "end ret:\(ret)")
        if 7 >= ret && ret >= 0 {
//                Log.selectLog(logLevel: .debug, "表示終了まで　７日以内")
            return true
        }
        return false
    }

    class func limitedTypeCheck(startFlag: Bool, endFlag: Bool) -> LimitedType {

        var limitedType: LimitedType!

        switch (startFlag, endFlag) {
        case (true, true):
            // 両方とも一致する
            limitedType = .end
        case (true, false):
//                Log.selectLog(logLevel: .debug, "掲載開始から７日以内")
            // NEWマークのみ表示
            limitedType = .new
        case (false, true):
//                Log.selectLog(logLevel: .debug, "掲載終了まで７日以内")
            // 終了マークのみ表示
            limitedType = .end
        default:
//                Log.selectLog(logLevel: .debug, "それ以外")
            limitedType = LimitedType.none
        }

        return limitedType
    }
}

extension Date {
    var RecommendParamOrderID: String {
        let dateFormat = DateHelper.dateTimeFormatterRecommendParam()
        return dateFormat.string(from: self)
    }
    var FName: String {
        let dateFormat = DateHelper.dateTimeFormatterFNameShort()
        return dateFormat.string(from: self)
    }
    var calendarJP: Calendar {
        var calendarJP = Calendar(identifier: .gregorian)
        calendarJP.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        calendarJP.locale = Locale(identifier: "ja_JP")
        return calendarJP
    }
    //日本時刻(localTZ)で表示するようにしておく
    func dispLogTime() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.formatOptions = [.withFullDate, .withFullTime]
        let buf: String = formatter.string(from: self)
        return buf
    }
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

        let formatter: DateFormatter = DateFormatter()
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
