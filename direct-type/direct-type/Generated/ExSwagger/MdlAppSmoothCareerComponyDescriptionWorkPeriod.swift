//
//  MdlAppSmoothCareerComponyDescriptionWorkPeriod.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class MdlAppSmoothCareerComponyDescriptionWorkPeriod: Codable {

    /** 在籍期間：開始年月 */
    var workStartDate: Date = Constants.DefaultSelectWorkPeriodStartDate
    /** 在籍期間：終了年月 */
    var workEndDate: Date = Constants.DefaultSelectWorkPeriodEndDate

    init(workStartDate: Date, workEndDate: Date) {
        self.workStartDate = workStartDate
        self.workEndDate = workEndDate
    }
    //ApiモデルをAppモデルに変換して保持させる
    //＊これはアプリ専用モデルを想定しているため不要

    var debugDisp: String {
        return "[start: \(String(describing: workStartDate.dispYmdJP))] [end: \(String(describing: workEndDate.dispYmdJP))]"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlAppSmoothCareerComponyDescriptionWorkPeriod: String, EditItemProtocol {
    case workStartDate
    case workEndDate
    //表示名
    var dispName: String {
        switch self {
        case .workStartDate:    return "在籍期間：開始年月"
        case .workEndDate:      return "在籍期間：終了年月"
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
