//
//  MdlAppSmoothCareer.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

/** サクサク職歴書で利用（これはアプリでのみ使われ、サーバ登録時には Resume に加工されて登録となるはず） */

class MdlAppSmoothCareer: Codable {

    var componyDescription: MdlAppSmoothCareerComponyDescription
    var workBackgroundDetail: MdlAppSmoothCareerWorkBackgroundDetail
    /** 年収（＊初回登録必須、ここでは非表示） */
    var salary: Code

    init(componyDescription: MdlAppSmoothCareerComponyDescription, workBackgroundDetail: MdlAppSmoothCareerWorkBackgroundDetail, salary: Code) {
        self.componyDescription = componyDescription
        self.workBackgroundDetail = workBackgroundDetail
        self.salary = salary
    }
    //ApiモデルをAppモデルに変換して保持させる
    //＊これはアプリ専用モデルを想定しているため不要

    var debugDisp: String {
        return "[componyDescription: \(componyDescription.debugDisp)] [workBackgroundDetail: \(workBackgroundDetail.debugDisp)] [salary: \(salary)]"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlAppSmoothCareer: String, EditItemProtocol {
    case componyDescription
    case workBackgroundDetail
    case salary
    //表示名
    var dispName: String {
        switch self {
        case .componyDescription:   return "在籍企業概要"
        case .workBackgroundDetail: return "職務経歴詳細"
        case .salary:               return "年収（＊初回登録必須、ここでは非表示）"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .componyDescription:   return .undefine
        case .workBackgroundDetail: return .undefine
        case .salary:               return .undefine
        }
    }
    //Placeholder Text
    var placeholder: String {
        return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
