//
//  MdlCareerCardWorkPeriod.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class MdlCareerCardWorkPeriod: Codable {
    /** 勤務開始年月 */
    var startDate: Date = Constants.DefaultSelectWorkPeriodStartDate
    /** 勤務終了年月 */
    var endDate: Date = Constants.DefaultSelectWorkPeriodEndDate

    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: CareerCardWorkPeriod) {
        let bufStart: String = "\(dto.startYear.zeroUme(4))-\(dto.endMonth.zeroUme(2))"
        let _start = DateHelper.convStrYM2Date(bufStart)
        let bufEnd: String = "\(dto.endYear.zeroUme(4))-\(dto.endMonth.zeroUme(2))"
        let _end = DateHelper.convStrYM2Date(bufEnd)
        self.init(startDate: _start, endDate: _end)
    }
    var debugDisp: String {
        var _startDate: String {
            if startDate == Constants.SelectItemsUndefineDate {
                return Constants.SelectItemsUndefineDateJP
            }
            return startDate.dispYmJP()
        }
        var _endDate: String {
            if startDate == Constants.SelectItemsUndefineDate {
                return Constants.SelectItemsUndefineDateJP
            }
            return endDate.dispYmJP()
        }
        return "[\(_startDate) 〜 \(_endDate)]"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlCareerCardWorkPeriod: String, EditItemProtocol {
    case startDate
    case endDate
    //表示名
    var dispName: String {
        switch self {
        case .startDate:    return "入社"
        case .endDate:      return "退社"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        default: return .undefine
        }
    }
    var dispUnit: String { //入力項目の単位表示
        switch self {
        default: return ""
        }
    }
    //Placeholder Text
    var placeholder: String {
        return ""//return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
