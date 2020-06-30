//
//  MdlResume.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
//import SwaggerClient
import TudApi
/** 履歴書 (H3) */
class MdlResume: Codable {
    /** 就業状況 */
    var employmentStatus: Code
    /** 転職回数 */
    var changeCount: Code
    var lastJobExperiment: MdlJobExperiment
    var jobExperiments: [MdlJobExperiment]
    var businessTypes: [Code]
    var educationId: Code//学種コード
    var school: MdlResumeSchool
    var skillLanguage: MdlResumeSkillLanguage
    var qualifications: [Code]
    /** 自己PR */
    var ownPr: String

    init(employmentStatus: Code, changeCount: Code, lastJobExperiment: MdlJobExperiment, jobExperiments: [MdlJobExperiment], businessTypes: [Code], educationId: Code, school: MdlResumeSchool, skillLanguage: MdlResumeSkillLanguage, qualifications: [Code], ownPr: String) {
        self.employmentStatus = employmentStatus
        self.changeCount = changeCount
        self.lastJobExperiment = lastJobExperiment
        self.jobExperiments = jobExperiments
        self.businessTypes = businessTypes
        self.educationId = educationId
        self.school = school
        self.skillLanguage = skillLanguage
        self.qualifications = qualifications
        self.ownPr = ownPr
    }
    //===空モデルを生成する
    convenience init() {
        self.init(
            employmentStatus: "",
            changeCount: "",
            lastJobExperiment: MdlJobExperiment(jobType: "", jobExperimentYear: ""),
            jobExperiments: [],
            businessTypes: [],
            educationId: "",
            school: MdlResumeSchool(schoolName: "", faculty: "", department: "", graduationYear: ""),
            skillLanguage: MdlResumeSkillLanguage(languageToeicScore: "", languageToeflScore: "", languageEnglish: "", languageStudySkill: ""),
            qualifications: [],
            ownPr: "" )
    }
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: GetResumeResponseDTO) {
        let _employment = (dto.isEmployed == true) ? "1" : "0" // 1: 就業中, 0: 就業していない
        let _changeCount: String!
        if let tmp = dto.changeJobCount {
            _changeCount = "\(tmp)"
        } else {
            _changeCount = ""
        }
        var _lastJobExperiments: MdlJobExperiment = MdlJobExperiment(jobType: "", jobExperimentYear: "")
        var _jobExperiments: [MdlJobExperiment] = []
        if let workHistorys = dto.workHistory {
            for (num, workHistory) in workHistorys.enumerated() {
                if num == 0 {
                    _lastJobExperiments = MdlJobExperiment(jobType: workHistory.job3Id, jobExperimentYear: workHistory.experienceYears)
                } else {
                    _jobExperiments.append(MdlJobExperiment(jobType: workHistory.job3Id, jobExperimentYear: workHistory.experienceYears))
                }
            }
        }
        //___experienceIndustryId ???
        var _businessTypes: [Code] = []
        if let codes = dto.experienceIndustryIds {
            for code in codes {
                _businessTypes.append(code)
            }
        }

        let _educationId = dto.educationId ?? ""
        let _school = MdlResumeSchool(schoolName: dto.finalEducation?.schoolName ?? "",
                                      faculty: dto.finalEducation?.faculty ?? "",
                                      department: dto.finalEducation?.department ?? "",
                                      graduationYear: dto.finalEducation?.guraduationYearMonth ?? Constants.SelectItemsUndefineDate.dispYm())
        let _skillLanguage = MdlResumeSkillLanguage(languageToeicScore: "\(dto.toeic ?? 0)",
                                                    languageToeflScore: "\(dto.toefl ?? 0)",
                                                    languageEnglish: dto.englishSkillId ?? "",
                                                    languageStudySkill: dto.otherLanguageSkillId ?? "" )
        var _qualifications: [Code] = []
        if let _licenseIds = dto.licenseIds {
            for item in _licenseIds {
                _qualifications.append("\(item)")
            }
        }
        let _ownPr: String = ""//!!!いま、存在していない
        self.init(employmentStatus: _employment,
                  changeCount: _changeCount,
                  lastJobExperiment: _lastJobExperiments,
                  jobExperiments: _jobExperiments,
                  businessTypes: _businessTypes,
                  educationId: _educationId,
                  school: _school,
                  skillLanguage: _skillLanguage,
                  qualifications: _qualifications,
                  ownPr: _ownPr)
    }
//    //ApiモデルをAppモデルに変換して保持させる
//    convenience init(dto: Resume) {
//        let _employment = "\(dto.employment)"
//        let _changeCount = "\(dto.changeCount)"
//        var _businessTypes: [Code] = []
//        for item in dto.businessTypes {
//            _businessTypes.append("\(item)")
//        }
//        let _lastJobExperiment = MdlResumeLastJobExperiment(dto: dto.lastJobExperiment)
//        var _jobExperiments: [MdlResumeJobExperiments] = []
//        for item in dto.jobExperiments {
//            _jobExperiments.append(MdlResumeJobExperiments(dto: item))
//        }
//        let _school = MdlResumeSchool(dto: dto.school)
//        let _skillLanguage = MdlResumeSkillLanguage(dto: dto.skillLanguage)
//        var _qualifications: [Code] = []
//        for item in dto.qualifications {
//            _qualifications.append("\(item)")
//        }
//
//        self.init(employmentStatus: _employment, changeCount: _changeCount, lastJobExperiment: _lastJobExperiment, jobExperiments: _jobExperiments, businessTypes: _businessTypes, school: _school, skillLanguage: _skillLanguage, qualifications: _qualifications, ownPr: dto.ownPr)
//    }
    var debugDisp: String {
        return "[employmentStatus: \(employmentStatus)] [changeCount: \(changeCount)] [lastJobExperiment: \(lastJobExperiment.debugDisp)] [jobExperiments: \(jobExperiments.count)件] [businessTypes: \(businessTypes.count)件]  [educationId: \(educationId)] [school: \(school.debugDisp)] [skillLanguage: \(skillLanguage.debugDisp)] [qualifications: \(qualifications.count)件] [ownPr: \(ownPr.count)文字数]"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlResume: String, EditItemProtocol {
    case employmentStatus
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
        case .employmentStatus:     return "就業状況"
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
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .employmentStatus: return .employmentStatus
        case .changeCount: return .changeCount
        case .businessTypes: return .businessType
        case .qualifications: return .qualification
        default: return .undefine
        }
    }
    //Placeholder Text
    var placeholder: String {
        return ""//return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
