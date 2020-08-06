//
//  Validate+Resume.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension ValidateManager {
    class func convValidErrMsgResume(_ arrValidErrMsg: [SwaValidErrMsg]) -> ([MdlItemHTypeKey: [String]],
        [EditableItemKey: [String]]) {
        var dicGrpError: [MdlItemHTypeKey: [String]] = [:]
        var dicError: [EditableItemKey: [String]] = [:]
        for valid in arrValidErrMsg {
            switch valid.property { //これで対応する項目に結びつける
            default:
                LogManager.appendLog(.validator, "Validate", "[\(valid.property)]\t[\(valid.constraintsKey)] : [\(valid.constraintsVal)]")
            }
        }
        dicGrpError = makeGrpErrByItemErr(dicError)//これだと配列の足し込み非対応なのでメッセージ減る
        return (dicGrpError, dicError)
    }
}

extension EditItemMdlResume {
    var valid: ValidInfo {
        switch self {
        case .employmentStatus:     return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .changeCount:          return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .lastJobExperiment:    return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .jobExperiments:       return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .businessTypes:        return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .school:               return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .skillLanguage:        return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .qualifications:       return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .ownPr:                return ValidInfo(required: false, keta: nil, max: 2000, type: .zenHanNumSym)
        case .currentSalary:        return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .educationId:          return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        }
    }
}
extension EditItemMdlResumeSchool {
    var valid: ValidInfo {
        switch self {
        case .schoolName:       return ValidInfo(required: true, keta: nil, max: 30, type: .zenHanNumSym)
        case .faculty:          return ValidInfo(required: true, keta: nil, max: 30, type: .zenHanNumSym)//別途、併せて30文字チェック
        case .department:       return ValidInfo(required: false, keta: nil, max: 30, type: .zenHanNumSym)//別途、併せて30文字チェック
        case .graduationYear:   return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        }
    }
}

extension EditItemMdlResumeSkillLanguage {
    var valid: ValidInfo {
        switch self {
        case .languageToeicScore:   return ValidInfo(required: false, keta: nil, max: 3, type: .number)
        case .languageToeflScore:   return ValidInfo(required: false, keta: nil, max: 3, type: .number)
        case .languageEnglish:      return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .languageStudySkill:   return ValidInfo(required: false, keta: nil, max: nil, type: .zenHanNumSym)
        }
    }
}
extension EditItemMdlResumeLastJobExperiment {
    var valid: ValidInfo {
        switch self {
        case .jobTypeAndJobExperimentYear:
            return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        }
    }
}
extension EditItemMdlResumeJobExperiments {
    var valid: ValidInfo {
        switch self {
        case .jobTypeAndJobExperimentYear:  return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        }
    }
}
