//
//  Validate+Profile.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension ValidateManager {

    class func convValidErrMsgProfile(_ arrValidErrMsg: [SwaValidErrMsg]) -> ([MdlItemHTypeKey: [String]],
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
}

extension EditItemMdlProfile {
    var valid: ValidInfo {
        switch self {
        case .familyName:       return ValidInfo(required: true, keta: nil, max: 8, type: .hiraKataKan)
        case .firstName:        return ValidInfo(required: true, keta: nil, max: 8, type: .hiraKataKan)
        case .familyNameKana:   return ValidInfo(required: true, keta: nil, max: 8, type: .katakana)
        case .firstNameKana:    return ValidInfo(required: true, keta: nil, max: 8, type: .katakana)
        case .birthday:         return ValidInfo(required: true, keta: nil, max: nil, type: .code)//今日以降の誕生日を許容する？（年齢がマイナスになる）
        case .gender:           return ValidInfo(required: true, keta: nil, max: nil, type: .code)//結局、男女の選択のみ？
        case .zipCode:          return ValidInfo(required: true, keta: 7, max: nil, type: .number)
        case .prefecture:       return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .address1:         return ValidInfo(required: true, keta: nil, max: 100, type: .zenkaku)
        case .address2:         return ValidInfo(required: false, keta: nil, max: 100, type: .zenkaku)//必須に変わった（やっぱり任意に戻った）
        case .mailAddress:      return ValidInfo(required: true, keta: nil, max: nil, type: .email)
        case .hopeJobArea:      return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .mobilePhoneNo:    return ValidInfo(required: true, keta: nil, max: nil, type: .number)//編集不可（requiredはtrueの方が良いか）
        }
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
extension EditItemMdlCareerCardWorkPeriod {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}
extension EditItemReqEntry {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}

