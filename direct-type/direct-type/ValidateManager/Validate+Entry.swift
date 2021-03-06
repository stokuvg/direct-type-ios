//
//  Validate+Entry.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/23.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension ValidateManager {

    class func convValidErrMsgEntry(_ arrValidErrMsg: [SwaValidErrMsg]) -> ([MdlItemHTypeKey: [String]],
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

extension EditItemMdlEntry {
    var valid: ValidInfo {
        switch self {
        case .jobCard:              return ValidInfo(required: false, keta: nil, max: nil, type: .model)
        case .profile:              return ValidInfo(required: false, keta: nil, max: nil, type: .model)
        case .resume:               return ValidInfo(required: false, keta: nil, max: nil, type: .model)
        case .career:               return ValidInfo(required: false, keta: nil, max: nil, type: .model)
        case .exQuestionAnswer1:    return ValidInfo(required: true, keta: nil, max: 2000, type: .zenHanNumSym)
        case .exQuestionAnswer2:    return ValidInfo(required: true, keta: nil, max: 2000, type: .zenHanNumSym)
        case .exQuestionAnswer3:    return ValidInfo(required: true, keta: nil, max: 2000, type: .zenHanNumSym)
        case .ownPR:                return ValidInfo(required: false, keta: nil, max: 2000, type: .zenHanNumSym)
        case .hopeArea:             return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .hopeSalary:           return ValidInfo(required: false, keta: nil, max: nil, type: .code)
        case .entryItems:           return ValidInfo(required: false, keta: nil, max: nil, type: .model)
        }
    }
}
