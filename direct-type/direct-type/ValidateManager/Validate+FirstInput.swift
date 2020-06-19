//
//  Validate+FirstInput.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension ValidateManager {

    class func convValidErrMsgFirstInput(_ arrValidErrMsg: [SwaValidErrMsg]) -> ([MdlItemHTypeKey: [String]],
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
        case .nickname:             return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
        case .gender:               return ValidInfo(required: false, keta: nil, max: nil, type: .code)//スキップ可能
        case .birthday:             return ValidInfo(required: true, keta: nil, max: nil, type: .code)//誕生日初期値は 96/1/1
        case .hopeArea:             return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .school:               return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .employmentStatus:     return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .lastJobExperiment:    return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .salary:               return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .jobExperiments:       return ValidInfo(required: false, keta: nil, max: nil, type: .code)//スキップ可能
        }
    }
}
extension EditItemMdlFirstInputJobExperiments {
    var valid: ValidInfo {
        return ValidInfo(required: false, keta: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlFirstInputLastJobExperiments {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}

