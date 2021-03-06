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
    /** 現在の年収 */
    var currentSalary: String
    /** すべての必須項目が設定されているか確認する*/
    var requiredComplete: Bool {
        if employmentStatus.isEmpty { return false }
        if currentSalary.isEmpty { return false }
        if changeCount.isEmpty { return false }
        if lastJobExperiment.jobType.isEmpty { return false }
        if lastJobExperiment.jobExperimentYear.isEmpty { return false }
        if school.schoolName.isEmpty { return false }
        if school.faculty.isEmpty { return false }
        if school.graduationYear.isEmpty { return false }
        return true //最後までたどり着ければ、必須項目は定義されているとみなせる
    }
    var isHaveRequired: Bool {
        return !changeCount.isEmpty && (businessTypes.count > 0) && school.isHaveRequired || !ownPr.isEmpty
    }
    /** 履歴書完成度(100=100%) */
    var completeness: Int {
        //===計算ロジック変更あり
        //初期入力完了時点：35%
        //必須項目（転職回数・経験業種・最終学歴）入力で＋25%
        //語学（任意）を1項目以上入力で+10%
        //資格（任意）を1項目以上選択で+15%
        //自己PR（任意）を入力で＋15％
        var result = 35 // MdlProfileが存在している時点で35%としている

        let existsRequiredItem = 25
        if !changeCount.isEmpty && !lastJobExperiment.jobType.isEmpty && !school.schoolName.isEmpty {
            result += existsRequiredItem
        }

        let existsSkillLanguage = 10
        if skillLanguage.isHaveSkill {
            result += existsSkillLanguage
        }

        let existsQualifications = 15
        if !qualifications.isEmpty {
            result += existsQualifications
        }

        let existsOwnPr = 15
        if !ownPr.isEmpty {
            result += existsOwnPr
        }

        return result
    }

    init(employmentStatus: Code, changeCount: Code, lastJobExperiment: MdlJobExperiment, jobExperiments: [MdlJobExperiment], businessTypes: [Code], educationId: Code, school: MdlResumeSchool, skillLanguage: MdlResumeSkillLanguage, qualifications: [Code], ownPr: String, currentSalary: String) {
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
        self.currentSalary = currentSalary
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
            ownPr: "",
            currentSalary: "" )
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
        for (num, workHistory) in dto.workHistory.enumerated() {
            if num == 0 {
                _lastJobExperiments = MdlJobExperiment(jobType: workHistory.job3Id, jobExperimentYear: workHistory.experienceYears)
            } else {
                _jobExperiments.append(MdlJobExperiment(jobType: workHistory.job3Id, jobExperimentYear: workHistory.experienceYears))
            }
        }
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
        let _skillLanguage = MdlResumeSkillLanguage(languageToeicScore: dto.toeic ?? "",
                                                    languageToeflScore: dto.toefl ?? "",
                                                    languageEnglish: dto.englishSkillId ?? "",
                                                    languageStudySkill: dto.otherLanguageSkillId ?? "" )
        var _qualifications: [Code] = []
        if let _licenseIds = dto.licenseIds {
            for item in _licenseIds {
                _qualifications.append("\(item)")
            }
        }
        let _ownPr: String = dto.selfPR ?? ""
        let _currentSalary: String = dto.currentSalary ?? ""

        self.init(employmentStatus: _employment,
                  changeCount: _changeCount,
                  lastJobExperiment: _lastJobExperiments,
                  jobExperiments: _jobExperiments,
                  businessTypes: _businessTypes,
                  educationId: _educationId,
                  school: _school,
                  skillLanguage: _skillLanguage,
                  qualifications: _qualifications,
                  ownPr: _ownPr,
                  currentSalary: _currentSalary )
    }

    var debugDisp: String {
        return "[employmentStatus: \(employmentStatus)] [currentSalary: \(currentSalary)] [changeCount: \(changeCount)] [lastJobExperiment: \(lastJobExperiment.debugDisp)] [jobExperiments: \(jobExperiments.count)件] [businessTypes: \(businessTypes.count)件]  [educationId: \(educationId)] [school: \(school.debugDisp)] [skillLanguage: \(skillLanguage.debugDisp)] [qualifications: \(qualifications.count)件] [ownPr: \(ownPr.count)文字数]"
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
    case currentSalary
    case educationId
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
        case .currentSalary:        return "現在の年収"
        case .educationId:          return "学種"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .employmentStatus: return .employmentStatus
        case .changeCount: return .changeCount
        case .businessTypes: return .businessType
        case .qualifications: return .qualification
        case .currentSalary: return .salarySelect//コードではなく選択数値が入るもの
        case .educationId: return .schoolType
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
        switch self {
        case .ownPr:
            return "自己PRを2000文字以内で入力ください"
        case .jobExperiments:
            return "複数選択可"//これは使われない（jobTypeAndJobExperimentYearとして一括で扱うため）
        case .businessTypes:
            return "複数選択可"
        case .qualifications:
            return "複数選択可"
        default:
            return ""//return "[\(self.itemKey) PlaceHolder]"
        }
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}
