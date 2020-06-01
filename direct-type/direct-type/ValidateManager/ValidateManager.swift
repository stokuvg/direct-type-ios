//
//  ValidateManager.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

enum ValidType {
    case undefine   //全角（特にチェックなし）
    case katakana   //全角カタカナ
    case email      //メールアドレス
    case number     //半角数字
    case ascii      //半角英数字
    case code       //コード選択のもの
}

struct ValidInfo {
    var required: Bool = false //true: 必須, false: 任意
    var keta: Int? = nil //桁数指定（一致のみOK）
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
        //桁数チェック
        for (key, vals) in subValidateKetaLengtyByKey(editableModel) {
            for val in vals {
                dicError.addDicArrVal(key: key, val: val)
            }
        }
        //文字種チェック
        for (key, vals) in subValidateTypeLengtyByKey(editableModel) {
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
                let validInfo = editTemp.editItem.valid
                guard validInfo.required == true else { continue }
                if isChange {
                    if editTemp.curVal == "" {
                        if validInfo.type == .code {
                            dicError.addDicArrVal(key: item.editableItemKey, val: "選択してください")
                        } else {
                            dicError.addDicArrVal(key: item.editableItemKey, val: "未入力です。入力してください")
                        }
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
                let validInfo = editTemp.editItem.valid
                guard let max = validInfo.max else { continue }
                if isChange {
                    if editTemp.curVal.count > max {
                        dicError.addDicArrVal(key: item.editableItemKey, val: "入力文字数が超過しています")
                    }
                }
            }
        }
        return dicError
    }
    //============================================
    class func subValidateKetaLengtyByKey(_ editableModel: EditableModel) -> [EditableItemKey: [String]] {
        var dicError: [EditableItemKey: [String]] = [:]
        //桁数チェック（指定桁数のみOKとする）
        for itemKey in editableModel.arrTextFieldNextDoneKey {
            if let item = editableModel.getItemByKey(itemKey) {
                let (isChange, editTemp) = editableModel.makeTempItem(item)
                let validInfo = editTemp.editItem.valid
                guard let keta = validInfo.keta else { continue }
                if isChange {
                    if editTemp.curVal.count != keta {
                        dicError.addDicArrVal(key: item.editableItemKey, val: "\(keta)桁の数字で入力してください")
                    }
                }
            }
        }
        return dicError
    }
    //============================================
    class func subValidateTypeLengtyByKey(_ editableModel: EditableModel) -> [EditableItemKey: [String]] {
        var dicError: [EditableItemKey: [String]] = [:]
        //文字種チェック
        for itemKey in editableModel.arrTextFieldNextDoneKey {
            if let item = editableModel.getItemByKey(itemKey) {
                let (isChange, editTemp) = editableModel.makeTempItem(item)
                let validInfo = editTemp.editItem.valid
                let type = validInfo.type
                if isChange {
                    switch type {
                    case .undefine:
                        continue
                    case .katakana:
                        dicError.addDicArrVal(key: item.editableItemKey, val: "katakanaで入力してください")
                    case .email:
                        if let errMsg = chkValidTypeEmail(item) {
                            dicError.addDicArrVal(key: item.editableItemKey, val: errMsg)
                        }
                    case .number:
                        dicError.addDicArrVal(key: item.editableItemKey, val: "numberで入力してください")
                    case .ascii:
                        dicError.addDicArrVal(key: item.editableItemKey, val: "asciiで入力してください")
                    case .code:
                        dicError.addDicArrVal(key: item.editableItemKey, val: "codeで入力してください")
                    }
                }
            }
        }
        return dicError
    }
    //============================================
    //============================================
    class func chkValidTypeEmail(_ item: EditableItemH) -> String? {
        let text = item.curVal
        //var pattern = #"^\d{\#(keta)}$"#
        let pattern = #"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
        return (matches.count > 0) ? nil : "メールアドレスが間違っています"
    }
    //============================================
    //============================================
    //============================================
}
