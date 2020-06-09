//
//  Validate+Profile.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension ValidateManager {

    class func canvValidErrMsgProfile(_ arrValidErrMsg: [SwaValidErrMsg]) -> ([MdlItemHTypeKey: [String]],
        [EditableItemKey: [String]]) {
        var dicGrpError: [MdlItemHTypeKey: [String]] = [:]
        var dicError: [EditableItemKey: [String]] = [:]
        for valid in arrValidErrMsg {
            switch valid.property { //これで対応する項目に結びつける
            case "familyName":      dicError.addDicArrVal(key: EditItemMdlProfile.familyName.itemKey, val: valid.constraintsVal)
            case "firstName":       dicError.addDicArrVal(key: EditItemMdlProfile.firstName.itemKey, val: valid.constraintsVal)
            case "familyNameKana":  dicError.addDicArrVal(key: EditItemMdlProfile.familyNameKana.itemKey, val: valid.constraintsVal)
            case "firstNameKana":   dicError.addDicArrVal(key: EditItemMdlProfile.firstNameKana.itemKey, val: valid.constraintsVal)
            case "birthday":        dicError.addDicArrVal(key: EditItemMdlProfile.birthday.itemKey, val: valid.constraintsVal)
            case "genderId":        dicError.addDicArrVal(key: EditItemMdlProfile.gender.itemKey, val: valid.constraintsVal)
            case "zipCode":         dicError.addDicArrVal(key: EditItemMdlProfile.zipCode.itemKey, val: valid.constraintsVal)
            case "prefectureId":    dicError.addDicArrVal(key: EditItemMdlProfile.prefecture.itemKey, val: valid.constraintsVal)
            case "city":            dicError.addDicArrVal(key: EditItemMdlProfile.address1.itemKey, val: valid.constraintsVal)
            case "town":            dicError.addDicArrVal(key: EditItemMdlProfile.address2.itemKey, val: valid.constraintsVal)
            case "email":           dicError.addDicArrVal(key: EditItemMdlProfile.mailAddress.itemKey, val: valid.constraintsVal)
            default:
                print("❤️\t[\(valid.property)]\t[\(valid.constraintsKey)] : [\(valid.constraintsVal)]")
            }
        }
        dicGrpError = makeGrpErrByItemErr(dicError)//これだと配列の足し込み非対応なのでメッセージ減る
        return (dicGrpError, dicError)
    }
        
    class func makeGrpErrByItemErr(_ dicError: [EditableItemKey: [String]]) -> ([MdlItemHTypeKey: [String]]) {
        var dicGrpError: [MdlItemHTypeKey: [String]] = [:]
        for (key, val) in dicError {
            switch key {
            //===プロフィール
            case EditItemMdlProfile.familyName.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.fullnameH2.itemKey, val: val)
            case EditItemMdlProfile.firstName.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.fullnameH2.itemKey, val: val)
            case EditItemMdlProfile.familyNameKana.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.fullnameH2.itemKey, val: val)
            case EditItemMdlProfile.firstNameKana.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.fullnameH2.itemKey, val: val)
            case EditItemMdlProfile.birthday.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.birthGenderH2.itemKey, val: val)
            case EditItemMdlProfile.gender.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.birthGenderH2.itemKey, val: val)
            case EditItemMdlProfile.zipCode.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.adderssH2.itemKey, val: val)
            case EditItemMdlProfile.prefecture.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.adderssH2.itemKey, val: val)
            case EditItemMdlProfile.address1.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.adderssH2.itemKey, val: val)
            case EditItemMdlProfile.address2.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.adderssH2.itemKey, val: val)
            case EditItemMdlProfile.mailAddress.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.emailH2.itemKey, val: val)
            case EditItemMdlProfile.mobilePhoneNo.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.mobilephoneH2.itemKey, val: val)
            //===[A系統]初期入力
            case EditItemMdlFirstInput.nickname.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.nicknameA6.itemKey, val: val)
            case EditItemMdlFirstInput.gender.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.genderA7.itemKey, val: val)
            case EditItemMdlFirstInput.birthday.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.birthdayA8.itemKey, val: val)
            case EditItemMdlFirstInput.hopeArea.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.hopeAreaA9.itemKey, val: val)
            case EditItemMdlFirstInput.school.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.schoolA10.itemKey, val: val)
            case EditItemMdlFirstInput.employmentStatus.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.employmentStatusA21.itemKey, val: val)
            case EditItemMdlFirstInput.lastJobExperiment.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.lastJobExperimentA11.itemKey, val: val)
            case EditItemMdlFirstInputLastJobExperiments.jobType.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.jobExperimentsA14.itemKey, val: val)
            case EditItemMdlFirstInputLastJobExperiments.jobExperimentYear.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.jobExperimentsA14.itemKey, val: val)
            case EditItemMdlFirstInput.salary.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.salaryA13.itemKey, val: val)
            case EditItemMdlFirstInput.jobExperiments.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.jobExperimentsA14.itemKey, val: val)
            case EditItemMdlFirstInputJobExperiments.jobType.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.jobExperimentsA14.itemKey, val: val)
            case EditItemMdlFirstInputJobExperiments.jobExperimentYear.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.jobExperimentsA14.itemKey, val: val)
            default:
                print("\t☠️割り当てエラー☠️[\(key): \(val)]☠️")
            }
        }
        return dicGrpError
    }
}

extension EditItemMdlProfile {
    var valid: ValidInfo {
        switch self {
        case .familyName:       return ValidInfo(required: true, keta: nil, max: 8, type: .hiraKataKan)
        case .firstName:        return ValidInfo(required: true, keta: nil, max: 8, type: .hiraKataKan)
        case .familyNameKana:   return ValidInfo(required: true, keta: nil, max: 8, type: .katakana)
        case .firstNameKana:    return ValidInfo(required: true, keta: nil, max: 8, type: .katakana)
        case .birthday:         return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)//今日以降の誕生日を許容する？（年齢がマイナスになる）
        case .gender:           return ValidInfo(required: false, keta: nil, max: nil, type: .code)//結局、男女の選択のみ？
        case .zipCode:          return ValidInfo(required: false, keta: 7, max: nil, type: .number)
        case .prefecture:       return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .address1:         return ValidInfo(required: false, keta: nil, max: 100, type: .undefine)
        case .address2:         return ValidInfo(required: false, keta: nil, max: 100, type: .undefine)
        case .mailAddress:      return ValidInfo(required: true, keta: nil, max: nil, type: .email)
        case .mobilePhoneNo:    return ValidInfo(required: true, keta: nil, max: nil, type: .number)//編集不可（requiredはtrueの方が良いか）
        }
    }
}

extension EditItemMdlResume {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}
extension MdlResumeSchool {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlResumeSkillLanguage {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlResumeLastJobExperiment {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlResumeJobExperiments {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlAppSmoothCareer {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlAppSmoothCareerComponyDescription {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlAppSmoothCareerComponyDescriptionWorkPeriod {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlAppSmoothCareerWorkBackgroundDetail {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}
extension EditItemCareerCardWorkPeriod {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}
extension EditItemReqEntry {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlResumeSchool {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}


