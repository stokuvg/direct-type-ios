//
//  MdlCareerCard.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
//import SwaggerClient
import TudApi

/** 職務経歴書（1社ごと） */
class MdlCareerCard: Codable {

    var workPeriod: MdlCareerCardWorkPeriod
    /** 企業名 */
    var companyName: String
    /** 雇用形態 */
    var employmentType: Code
    /** 従業員数（数値）*任意数値、8桁で良い？ */
    var employeesCount: String
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
    convenience init() {
        self.init(workPeriod: MdlCareerCardWorkPeriod(startDate: Constants.DefaultSelectWorkPeriodStartDate, endDate: Constants.DefaultSelectWorkPeriodEndDate), companyName: "", employmentType: "", employeesCount: "", salary: "", contents: "")
    }

    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: CareerHistoryDTO) {
        let _workPeriod: MdlCareerCardWorkPeriod =
            MdlCareerCardWorkPeriod(startDate: DateHelper.convStrYM2Date(dto.startWorkPeriod),
                                    endDate: DateHelper.convStrYM2Date(dto.endWorkPeriod) )
        let _employmentType = dto.employmentId
        let _employeesCount = "\(dto.employees)"
        let _salary = "\(dto.salary)"
        self.init(workPeriod: _workPeriod,
                  companyName: dto.companyName,
                  employmentType: _employmentType,
                  employeesCount: _employeesCount,
                  salary: _salary,
                  contents: dto.workNote)
    }
//    convenience init(dto: CareerCard) {
//        let _workPeriod: MdlCareerCardWorkPeriod = MdlCareerCardWorkPeriod.init(dto: dto.workPeriod)
//        let _employmentType = "\(dto.employmentType)"
//        let _employeesCount = "\(dto.employeesCount)"
//        let _salary = "\(dto.salary)"
//        self.init(workPeriod: _workPeriod, companyName: dto.companyName, employmentType: _employmentType, employeesCount: _employeesCount, salary: _salary, contents: dto.contents)
//    }
    var debugDisp: String {
        let _workPeriod: String = workPeriod.debugDisp
        return "[workPeriod: \(_workPeriod)] [companyName: \(companyName)] [employmentType: \(employmentType)] [employeesCount: \(employeesCount)] [salary: \(salary)] [contents: \(contents)]"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlCareerCard: String, EditItemProtocol {
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
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .employmentType: return .employmentType
        case .salary: return .salary
        default: return .undefine
        }
    }
    var dispUnit: String { //入力項目の単位表示
        switch self {
        case .employeesCount: return "名"
        default: return ""
        }
    }
    //Placeholder Text
    var placeholder: String {
        return ""//return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
