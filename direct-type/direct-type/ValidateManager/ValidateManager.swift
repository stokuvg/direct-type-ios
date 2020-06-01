//
//  ValidateManager.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//
enum ValidType {
    case undefine
    case number
    case ascii
}

struct ValidInfo {
    var required: Bool = false //true: 必須, false: 任意
    var min: Int? = nil //最小文字長
    var max: Int? = nil //最大文字長
    var type: ValidType = .undefine
}

final public class ValidateManager {
    public static let shared = ValidateManager()
    private init() {
    }
}

//==========================================================================================
extension ValidateManager {
    class func dbgDispCurrentItems(editableModel: EditableModel) {
//        return//!!!
        //===変更内容の確認
        print(#line, String(repeating: "=", count: 44))
        for (y, items) in editableModel.arrData.enumerated() {
            for (x, _item) in items.enumerated() {
                let (isChange, editTemp) = editableModel.makeTempItem(_item)
                let item: EditableItemH! = isChange ? editTemp : _item
                if isChange {
                    print("\t(\(y)-\(x)) ✍️ [\(item.debugDisp)]")
                } else {
                    print("\t(\(y)-\(x)) 　 [\(item.debugDisp)]")
                }
            }
        }
        print(#line, String(repeating: "=", count: 44))
    }
}
//==========================================================================================
extension ValidateManager {
    class func chkValidationErr(_ editableModel: EditableModel) -> [EditableItemKey: [String]] {
        var dicError: [EditableItemKey: [String]] = [:]
        //必須チェック
        for (key, vals) in subValidateNotEmntyByKey(editableModel) {
            for val in vals {
                dicError.addDicArrVal(key: key, val: val)
            }
        }
        //最大文字長チェック
        for (key, vals) in subValidateMaxLengtyByKey(editableModel) {
            for val in vals {
                dicError.addDicArrVal(key: key, val: val)
            }
        }
        return dicError
    }
    //============================================
    class func subValidateNotEmntyByKey(_ editableModel: EditableModel) -> [EditableItemKey: [String]] {
        var dicError: [EditableItemKey: [String]] = [:]
        //必須チェック
        for itemKey in editableModel.arrTextFieldNextDoneKey {
            if let item = editableModel.getItemByKey(itemKey) {
                let (isChange, editTemp) = editableModel.makeTempItem(item)
                if isChange {
                    if editTemp.curVal == "" {
                        dicError.addDicArrVal(key: item.editableItemKey, val: "「\(item.dispName)」は必須項目です")
                    }
                }
            }
        }
        return dicError
    }
    //============================================
    class func subValidateMaxLengtyByKey(_ editableModel: EditableModel) -> [EditableItemKey: [String]] {
        var dicError: [EditableItemKey: [String]] = [:]
        //最大文字長チェック
        for itemKey in editableModel.arrTextFieldNextDoneKey {
            if let item = editableModel.getItemByKey(itemKey) {
                let (isChange, editTemp) = editableModel.makeTempItem(item)
                if isChange {
                    let max: Int = 8
                    if editTemp.curVal.count > max {
                        dicError.addDicArrVal(key: item.editableItemKey, val: "「\(item.dispName)」は\(max)文字までです")
                    }
                }
            }
        }
        return dicError
    }
    //============================================
    //============================================
    
}
