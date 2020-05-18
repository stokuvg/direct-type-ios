//
//  MdlAppSmoothCareerComponyDescription.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

/** 在籍企業概要 */

class MdlAppSmoothCareerComponyDescription: Codable {

    /** 勤務先企業名 */
    var companyName: String
    /** 社員数（任意数値：8桁） */
    var employeesCount: String
    var workPeriod: MdlAppSmoothCareerComponyDescriptionWorkPeriod
    /** 雇用形態 */
    var employmentType: Code

    init(companyName: String, employeesCount: String, workPeriod: MdlAppSmoothCareerComponyDescriptionWorkPeriod, employmentType: Code) {
        self.companyName = companyName
        self.employeesCount = employeesCount
        self.workPeriod = workPeriod
        self.employmentType = employmentType
    }
    //ApiモデルをAppモデルに変換して保持させる
    //＊これはアプリ専用モデルを想定しているため不要

    var debugDisp: String {
        return "[companyName: \(companyName)] [employeesCount: \(employeesCount)] [workPeriod: \(workPeriod.debugDisp)] [employmentType: \(employmentType)]"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlAppSmoothCareerComponyDescription: String, EditItemProtocol {
    case companyName
    case employeesCount
    case workPeriod
    case employmentType
    //表示名
    var dispName: String {
        switch self {
        case .companyName:      return "勤務先企業名"
        case .employeesCount:   return "社員数（コードで指定）"
        case .workPeriod:       return "在籍期間"
        case .employmentType:   return "雇用形態"
        }
    }
    //Placeholder Text
    var placeholder: String {
        return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
