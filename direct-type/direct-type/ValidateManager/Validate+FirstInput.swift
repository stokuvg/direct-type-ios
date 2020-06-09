//
//  Validate+FirstInput.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension ValidateManager {

    class func canvValidErrMsgFirstInput(_ arrValidErrMsg: [SwaValidErrMsg]) -> ([MdlItemHTypeKey: [String]],
        [EditableItemKey: [String]]) {
        var dicGrpError: [MdlItemHTypeKey: [String]] = [:]
        var dicError: [EditableItemKey: [String]] = [:]
        for valid in arrValidErrMsg {
            switch valid.property { //これで対応する項目に結びつける
            default:
                print("❤️\t[\(valid.property)]\t[\(valid.constraintsKey)] : [\(valid.constraintsVal)]")
            }
        }
        dicGrpError = makeGrpErrByItemErr(dicError)//これだと配列の足し込み非対応なのでメッセージ減る
        return (dicGrpError, dicError)
    }
}

extension EditItemMdlFirstInput {
    var valid: ValidInfo {
        switch self {
        case .nickname:             return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .gender:               return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .birthday:             return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .hopeArea:             return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .school:               return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .employmentStatus:     return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .lastJobExperiment:    return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .salary:               return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .jobExperiments:       return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        }
    }
}
extension EditItemMdlFirstInputJobExperiments {
    var valid: ValidInfo {
        switch self {
        case .jobType:              return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .jobExperimentYear:    return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        }
    }
}
extension EditItemMdlFirstInputLastJobExperiments {
    var valid: ValidInfo {
        switch self {
        case .jobType:              return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .jobExperimentYear:    return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        }
    }
}

