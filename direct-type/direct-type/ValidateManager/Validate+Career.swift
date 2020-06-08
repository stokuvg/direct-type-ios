//
//  Validate+Career.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension ValidateManager {

    class func canvValidErrMsgCareer(_ arrValidErrMsg: [SwaValidErrMsg]) -> ([MdlItemHTypeKey: [String]],
        [EditableItemKey: [String]]) {
        var dicGrpError: [MdlItemHTypeKey: [String]] = [:]
        var dicError: [EditableItemKey: [String]] = [:]
        for valid in arrValidErrMsg {
            //===グループ側のエラー
            switch valid.property { //これで対応する項目に結びつける
            case "startWorkPeriod", "endWorkPeriod":
                dicGrpError.addDicArrVal(key: HPreviewItemType.workPeriodC15.itemKey, val: valid.constraintsVal)
            case "companyName":
                dicGrpError.addDicArrVal(key: HPreviewItemType.companyNameC15.itemKey, val: valid.constraintsVal)
            case "employmentId":
                dicGrpError.addDicArrVal(key: HPreviewItemType.employmentTypeC15.itemKey, val: valid.constraintsVal)
            case "employees":
                dicGrpError.addDicArrVal(key: HPreviewItemType.employeesCountC15.itemKey, val: valid.constraintsVal)
            case "salary":
                dicGrpError.addDicArrVal(key: HPreviewItemType.salaryC15.itemKey, val: valid.constraintsVal)
            case "workNote":
                dicGrpError.addDicArrVal(key: HPreviewItemType.contentsC15.itemKey, val: valid.constraintsVal)
            default:
                print("❤️\t[\(valid.property)]\t[\(valid.constraintsKey)] : [\(valid.constraintsVal)]")
            }
            //===個別のエラー
            switch valid.property { //これで対応する項目に結びつける
            case "startWorkPeriod":
                dicError.addDicArrVal(key: EditItemCareerCardWorkPeriod.startDate.itemKey, val: valid.constraintsVal)
            case "endWorkPeriod":
                dicError.addDicArrVal(key: EditItemCareerCardWorkPeriod.endDate.itemKey, val: valid.constraintsVal)
            case "companyName":
                dicError.addDicArrVal(key: EditItemCareerCard.companyName.itemKey, val: valid.constraintsVal)
            case "employmentId":
                dicError.addDicArrVal(key: EditItemCareerCard.employmentType.itemKey, val: valid.constraintsVal)
            case "employees":
                dicError.addDicArrVal(key: EditItemCareerCard.employeesCount.itemKey, val: valid.constraintsVal)
            case "salary":
                dicError.addDicArrVal(key: EditItemCareerCard.salary.itemKey, val: valid.constraintsVal)
            case "workNote":
                dicError.addDicArrVal(key: EditItemCareerCard.contents.itemKey, val: valid.constraintsVal)
            default:
                print("❤️\t[\(valid.property)]\t[\(valid.constraintsKey)] : [\(valid.constraintsVal)]")
            }
        }
        return (dicGrpError, dicError)
    }
}

extension EditItemCareer {
    var valid: ValidInfo {
        return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
    }
}
extension EditItemCareerCard {
    var valid: ValidInfo {
        switch self {
        case .workPeriod:       return ValidInfo(required: true, keta: nil, max: nil, type: .undefine)
        case .companyName:      return ValidInfo(required: true, keta: nil, max: 50, type: .zenkaku)
        case .employmentType:   return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .employeesCount:   return ValidInfo(required: true, keta: nil, max: nil, type: .number)
        case .salary:           return ValidInfo(required: true, keta: nil, max: nil, type: .code)
        case .contents:         return ValidInfo(required: true, keta: nil, max: 2000, type: .zenkaku)
        }
    }
}
