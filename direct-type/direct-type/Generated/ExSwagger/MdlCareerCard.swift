//
//  MdlCareerCard.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

/** 職務経歴書（1社ごと） */
class MdlCareerCard: Codable {

    var workPeriod: MdlCareerCardWorkPeriod
    /** 企業名 */
    var companyName: String
    /** 雇用形態 */
    var employmentType: Code
    /** 従業員数（数値）*これもマスタじゃないのか？ */
    var employeesCount: Code
    /** 年収 */
    var salary: Code
    /** 職務内容本文 */
    var contents: String

    init(workPeriod: MdlCareerCardWorkPeriod, companyName: String, employmentType: Code, employeesCount: Code, salary: Code, contents: String) {
        self.workPeriod = workPeriod
        self.companyName = companyName
        self.employmentType = employmentType
        self.employeesCount = employeesCount
        self.salary = salary
        self.contents = contents
    }
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: CareerCard) {
        let _workPeriod: MdlCareerCardWorkPeriod = MdlCareerCardWorkPeriod.init(dto: dto.workPeriod)
        let _employmentType = "\(dto.employmentType)"
        let _employeesCount = "\(dto.employeesCount)"
        let _salary = "\(dto.salary)"
        self.init(workPeriod: _workPeriod, companyName: dto.companyName, employmentType: _employmentType, employeesCount: _employeesCount, salary: _salary, contents: dto.contents)
    }
    var debugDisp: String {
        return "[workPeriod: \(workPeriod.debugDisp)] [companyName: \(companyName)] [employmentType: \(employmentType)] [employeesCount: \(employeesCount)] [salary: \(salary)] [contents: \(contents)]"
    }
}

//=== 編集用の項目と定義など
enum EditItemCareerCard: String, EditItemProtocol {
    case workPeriod
    case companyName
    case employmentType
    case employeesCount
    case salary
    case contents
    //表示名
    var dispName: String {
        switch self {
        case .workPeriod:       return "勤務期間"
        case .companyName:      return "企業名"
        case .employmentType:   return "雇用形態"
        case .employeesCount:   return "従業員数（数値）"   //*これもマスタじゃないのか？
        case .salary:           return "年収"
        case .contents:         return "職務内容本文"
        }
    }
    //Placeholder Text
    var placeholder: String {
        return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
