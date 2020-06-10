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
    var startDate: Date = Constants.SelectItemsUndefineDate
    /** 勤務終了年月 */
    var endDate: Date = Constants.SelectItemsUndefineDate

    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: CareerCardWorkPeriod) {
        let bufStart: String = "\(dto.startYear.zeroUme(4))-\(dto.endMonth.zeroUme(2))-01"
        let _start = DateHelper.convStr2Date(bufStart)
        let bufEnd: String = "\(dto.endYear.zeroUme(4))-\(dto.endMonth.zeroUme(2))-01"
        let _end = DateHelper.convStr2Date(bufEnd)
        self.init(startDate: _start, endDate: _end)
    }
    var debugDisp: String {
        return "[start: \(String(describing: startDate.dispYmdJP))] [end: \(String(describing: endDate.dispYmdJP))]"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlCareerCardWorkPeriod: String, EditItemProtocol {
    case startDate
    case endDate
    //表示名
    var dispName: String {
        switch self {
        case .startDate:    return "勤務開始年月"
        case .endDate:      return "勤務終了年月"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        default: return .undefine
        }
    }
    //Placeholder Text
    var placeholder: String {
        return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
