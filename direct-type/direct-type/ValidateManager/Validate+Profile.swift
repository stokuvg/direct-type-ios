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
            //===グループ側のエラー
            switch valid.property { //これで対応する項目に結びつける
            case "familyName", "firstName", "familyNameKana", "firstNameKana":
                dicGrpError.addDicArrVal(key: HPreviewItemType.fullnameH2.itemKey, val: valid.constraintsVal)
            case "birthday", "genderId":
                dicGrpError.addDicArrVal(key: HPreviewItemType.birthGenderH2.itemKey, val: valid.constraintsVal)
            case "zipCode", "prefectureId", "city", "town":
                dicGrpError.addDicArrVal(key: HPreviewItemType.adderssH2.itemKey, val: valid.constraintsVal)
            case "email":
                dicGrpError.addDicArrVal(key: HPreviewItemType.emailH2.itemKey, val: valid.constraintsVal)
            default:
                print("❤️\t[\(valid.property)]\t[\(valid.constraintsKey)] : [\(valid.constraintsVal)]")
            }
            //===個別のエラー
            switch valid.property { //これで対応する項目に結びつける
            case "familyName":
                dicError.addDicArrVal(key: EditItemMdlProfile.familyName.itemKey, val: valid.constraintsVal)
            case "firstName":
                dicError.addDicArrVal(key: EditItemMdlProfile.firstName.itemKey, val: valid.constraintsVal)
            case "familyNameKana":
                dicError.addDicArrVal(key: EditItemMdlProfile.familyNameKana.itemKey, val: valid.constraintsVal)
            case "firstNameKana":
                dicError.addDicArrVal(key: EditItemMdlProfile.firstNameKana.itemKey, val: valid.constraintsVal)
            case "birthday":
                dicError.addDicArrVal(key: EditItemMdlProfile.birthday.itemKey, val: valid.constraintsVal)
            case "genderId":
                dicError.addDicArrVal(key: EditItemMdlProfile.gender.itemKey, val: valid.constraintsVal)
            case "zipCode":
                dicError.addDicArrVal(key: EditItemMdlProfile.zipCode.itemKey, val: valid.constraintsVal)
            case "prefectureId":
                dicError.addDicArrVal(key: EditItemMdlProfile.prefecture.itemKey, val: valid.constraintsVal)
            case "city":
                dicError.addDicArrVal(key: EditItemMdlProfile.address1.itemKey, val: valid.constraintsVal)
            case "town":
                dicError.addDicArrVal(key: EditItemMdlProfile.address2.itemKey, val: valid.constraintsVal)
            case "email":
                dicError.addDicArrVal(key: EditItemMdlProfile.mailAddress.itemKey, val: valid.constraintsVal)
            default:
                print("❤️\t[\(valid.property)]\t[\(valid.constraintsKey)] : [\(valid.constraintsVal)]")
            }
        }
        return (dicGrpError, dicError)
    }
}

extension EditItemMdlProfile {
    var valid: ValidInfo {
        switch self {
        case .familyName:
            return ValidInfo(required: true, min: nil, max: 8, type: .undefine)
        case .firstName:
            return ValidInfo(required: true, min: nil, max: 8, type: .undefine)
        case .familyNameKana:
            return ValidInfo(required: true, min: nil, max: 22, type: .undefine)
        case .firstNameKana:
            return ValidInfo(required: true, min: nil, max: 22, type: .undefine)
        case .birthday:
            return ValidInfo(required: true, min: nil, max: 8, type: .undefine)
        case .gender:
            return ValidInfo(required: true, min: nil, max: 8, type: .undefine)
        case .zipCode:
            return ValidInfo(required: true, min: nil, max: 8, type: .undefine)
        case .prefecture:
            return ValidInfo(required: true, min: nil, max: 8, type: .undefine)
        case .address1:
            return ValidInfo(required: true, min: nil, max: 8, type: .undefine)
        case .address2:
            return ValidInfo(required: true, min: nil, max: 8, type: .undefine)
        case .mailAddress:
            return ValidInfo(required: true, min: nil, max: 8, type: .undefine)
        case .mobilePhoneNo:
            return ValidInfo(required: true, min: nil, max: 8, type: .undefine)
        }
    }

}

extension EditItemMdlResume {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}
extension MdlResumeSchool {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlResumeSkillLanguage {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlResumeLastJobExperiment {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlResumeJobExperiments {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlAppSmoothCareer {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlAppSmoothCareerComponyDescription {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlAppSmoothCareerComponyDescriptionWorkPeriod {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlAppSmoothCareerWorkBackgroundDetail {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}
extension EditItemCareerCardWorkPeriod {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}
extension EditItemReqEntry {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}
extension EditItemCareer {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}
extension EditItemCareerCard {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}
extension EditItemMdlResumeSchool {
    var valid: ValidInfo {
        return ValidInfo(required: true, min: nil, max: nil, type: .undefine)
    }
}


