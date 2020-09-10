//
//  DateUtil.swift
//  direct-type
//
//  Created by ms-mb010 on 2020/09/10.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

/// 日付変換シングルトンクラスh
class DateUtil {
    /// フォーマッタータイプ
    enum FormatterType {
        case iSO8601(style: ISOStyle)
        case nolmal(style: Style, locale: localeoooo)
        /// ISO表示形式
        enum ISOStyle {
            case ymd
            case ym
            case year
            case month

            var formatOptions: ISO8601DateFormatter.Options {
                switch self {
                case .ymd:
                    return [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]
                case .ym:
                    return [.withYear, .withMonth, .withDashSeparatorInDate]
                case .year:
                    return [.withYear, .withDashSeparatorInDate]
                case .month:
                    return [.withMonth, .withDashSeparatorInDate]
                }
            }
        }
        /// 形式
        enum Style: String {
            case yyyyMMddHHmmssSSS = "yyyyMMddHHmmssSSS"
            case yyyyMMddHH = "yyyyMMddHH"
            case yyyyMdJP = "yyyy年M月d日"
            case yyyyMJP = "yyyy年M月"
            case mdJP = "M月d日"
        }
        /// 地域
        enum localeoooo: String {
            case enUSPosix = "en_US_POSIX"
            case jp = "ja_JP"
        }
    }

    static let shared = DateUtil()

    private init() { }

    /// 通常フォーマッター
    ///
    /// * インスタンスコストが高いため、これを使い回すこと!
    private lazy var formatter = DateFormatter()
    /// ISO8601スタイル
    ///
    /// * インスタンスコストが高いため、これを使い回すこと!
    private lazy var iSO8601Formatter = ISO8601DateFormatter()

    /// フォーマッター初期化処理
    /// - Parameter type: どのスタイルに初期化するか
    private func initializeFormatter(type: DateUtil.FormatterType) {
        switch type {
        case .iSO8601(let style):
            self.iSO8601Formatter.formatOptions = style.formatOptions
            self.iSO8601Formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        case .nolmal(let style, let locale):
            self.formatter.calendar = Calendar(identifier: .gregorian)
            self.formatter.dateFormat = style.rawValue
            self.formatter.locale = Locale(identifier: locale.rawValue)
            self.formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        }
    }

    /// 文字列を Date 型に変換
    ///
    /// * 変換失敗時は nil
    ///
    /// - Parameters:
    ///   - dateString: 日付(文字列)
    ///   - type: フォーマッタータイプ
    /// - Returns: Date 型
    func convStrToDate(_ dateString: String, type: DateUtil.FormatterType) -> Date? {
        self.initializeFormatter(type: type)
        let date = self.iSO8601Formatter.date(from: dateString)
        return date
    }

    /// Date型 を文字列に変換
    /// - Parameters:
    ///   - date: Date
    ///   - type: フォーマッタータイプ
    /// - Returns: 文字列
    func convertDateToStr(date: Date, type: DateUtil.FormatterType) -> String {
        self.initializeFormatter(type: type)
        let dateString = formatter.string(from: date)
        return dateString
    }
}
