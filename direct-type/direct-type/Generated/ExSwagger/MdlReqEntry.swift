//
//  MdlReqEntry.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class ReqEntry: Codable {

    var profileModel: Profile
    var resumeModel: Resume
    var careerModel: Career
    /** 自己PR */
    var selfPr: String
    var hopeWorkPlace: [Code]
    /** 希望年収 */
    var hopeSalary: Code
    /** 独自質問① */
    var exAnswer1: String
    /** 独自質問② */
    var exAnswer2: String
    /** 独自質問③ */
    var exAnswer3: String

    init(profileModel: Profile, resumeModel: Resume, careerModel: Career, selfPr: String, hopeWorkPlace: [Code], hopeSalary: Code, exAnswer1: String, exAnswer2: String, exAnswer3: String) {
        self.profileModel = profileModel
        self.resumeModel = resumeModel
        self.careerModel = careerModel
        self.selfPr = selfPr
        self.hopeWorkPlace = hopeWorkPlace
        self.hopeSalary = hopeSalary
        self.exAnswer1 = exAnswer1
        self.exAnswer2 = exAnswer2
        self.exAnswer3 = exAnswer3
    }
    enum CodingKeys: String, CodingKey {
        case profileModel = "profile_model"
        case resumeModel = "resume_model"
        case careerModel = "career_model"
        case selfPr = "self_pr"
        case hopeWorkPlace = "hope_work_place"
        case hopeSalary = "hope_salary"
        case exAnswer1 = "ex_answer1"
        case exAnswer2 = "ex_answer2"
        case exAnswer3 = "ex_answer3"
    }

    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: ReqEntry) {
        let _hopeSalary = "\(dto.hopeSalary)"
        var _hopeWorkPlace: [Code] = []
        for item in dto.hopeWorkPlace {
            _hopeWorkPlace.append("\(item)")
        }
        self.init(profileModel: dto.profileModel, resumeModel: dto.resumeModel, careerModel: dto.careerModel, selfPr: dto.selfPr, hopeWorkPlace: _hopeWorkPlace, hopeSalary: _hopeSalary, exAnswer1: dto.exAnswer1, exAnswer2: dto.exAnswer2, exAnswer3: dto.exAnswer3)
    }

    var debugDisp: String {
        return "[\(selfPr)] [\(hopeWorkPlace)] [\(hopeSalary)]\n[\(exAnswer1)][\(exAnswer2)][\(exAnswer2)]"
    }
}

//=== 編集用の項目と定義など
enum EditItemReqEntry: String, EditItemProtocol {
    case profileModel
    case resumeModel
    case careerModel
    case selfPr
    case hopeWorkPlace
    case hopeSalary
    case exAnswer1
    case exAnswer2
    case exAnswer3
    //表示名
    var dispName: String {
        switch self {
        case .profileModel:     return "プロフィール"
        case .resumeModel:      return "履歴書"
        case .careerModel:      return "職務経歴書・スキルシート"
        case .selfPr:           return "自己PR"
        case .hopeWorkPlace:    return "希望勤務地"
        case .hopeSalary:       return "希望年収（下限）"
        case .exAnswer1:        return "企業からの質問項目"
        case .exAnswer2:        return "企業からの質問項目"
        case .exAnswer3:        return "企業からの質問項目"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .hopeWorkPlace: return .entryPlace
        case .hopeSalary: return .salaryCode
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

