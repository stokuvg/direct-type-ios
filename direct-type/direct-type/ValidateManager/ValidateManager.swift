//
//  ValidateManager.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

final public class ValidateManager {
    public static let shared = ValidateManager()
    private init() {
    }
}

//==========================================================================================
extension ValidateManager {
    class func addDicArrVal(dic: [EditableItemKey: [String]], key: EditableItemKey, val: String) -> [EditableItemKey: [String]] {
        var new: [EditableItemKey: [String]] = dic
        if var hoge = dic[key] {
            hoge.append(val)
            new[key] = hoge
        } else {
            new[key] = [val]
        }
        return new
    }
    class func dbgDispCurrentItems(editableModel: EditableModel) {
        return//!!!
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
                dicError = ValidateManager.addDicArrVal(dic: dicError, key: key, val: val)
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
                        dicError = ValidateManager.addDicArrVal(dic: dicError, key: item.editableItemKey, val: "\(item.dispName)は必須項目です")
                    }
                }
            }
        }
        return dicError
    }
    //============================================
    //============================================
    //============================================
    
}
