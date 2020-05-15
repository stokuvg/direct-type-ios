//
//  MdlResume.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient
/** 履歴書 (H3) */
class MdlResume: Codable {
    /** 就業状況 */
    var employment: Code
    /** 転職回数 */
    var changeCount: Code
    var lastJobExperiment: MdlResumeLastJobExperiment
    var jobExperiments: [MdlResumeJobExperiments]
    var businessTypes: [Code]
    var school: MdlResumeSchool
    var skillLanguage: MdlResumeSkillLanguage
    var qualifications: [Code]
    /** 自己PR */
    var ownPr: String

    init(employment: Code, changeCount: Code, lastJobExperiment: MdlResumeLastJobExperiment, jobExperiments: [MdlResumeJobExperiments], businessTypes: [Code], school: MdlResumeSchool, skillLanguage: MdlResumeSkillLanguage, qualifications: [Code], ownPr: String) {
        self.employment = employment
        self.changeCount = changeCount
        self.lastJobExperiment = lastJobExperiment
        self.jobExperiments = jobExperiments
        self.businessTypes = businessTypes
        self.school = school
        self.skillLanguage = skillLanguage
        self.qualifications = qualifications
        self.ownPr = ownPr
    }
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: Resume) {
        let _employment = "\(dto.employment)"
        let _changeCount = "\(dto.changeCount)"
        var _businessTypes: [Code] = []
        for item in dto.businessTypes {
            _businessTypes.append("\(item)")
        }
        let _lastJobExperiment = MdlResumeLastJobExperiment(dto: dto.lastJobExperiment)
        var _jobExperiments: [MdlResumeJobExperiments] = []
        for item in dto.jobExperiments {
            _jobExperiments.append(MdlResumeJobExperiments(dto: item))
        }
        let _school = MdlResumeSchool(dto: dto.school)
        let _skillLanguage = MdlResumeSkillLanguage(dto: dto.skillLanguage)
        var _qualifications: [Code] = []
        for item in dto.qualifications {
            _qualifications.append("\(item)")
        }

        self.init(employment: _employment, changeCount: _changeCount, lastJobExperiment: _lastJobExperiment, jobExperiments: _jobExperiments, businessTypes: _businessTypes, school: _school, skillLanguage: _skillLanguage, qualifications: _qualifications, ownPr: dto.ownPr)
    }
    var debugDisp: String {
        return "[employment: \(employment)] [changeCount: \(changeCount)]"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlResume: String, EditItemProtocol {
    case employment
    case changeCount
    case lastJobExperiment
    case jobExperiments
    case businessTypes
    case school
    case skillLanguage
    case qualifications
    case ownPr
    //表示名
    var dispName: String {
        switch self {
        case .employment:           return "就業状況"
        case .changeCount:          return "転職回数"
        case .lastJobExperiment:    return "直近の経験職種"
        case .jobExperiments:       return "その他の経験職種"
        case .businessTypes:        return "経験業種"
        case .school:               return "最終学歴"
        case .skillLanguage:        return "語学"
        case .qualifications:       return "資格"
        case .ownPr:                return "自己PR"
        }
    }
    //Placeholder Text
    var placeholder: String {
        return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
