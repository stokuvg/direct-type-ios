//
//  ValidateManager.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

enum ValidType {
    case undefine       //全角（特にチェックなし）
    case hiraKataKan    //ひらカタ漢字
    case katakana       //全角カタカナ
    case email          //メールアドレス
    case number         //半角数字
    case password       //type用パスワード（＊半角英数4~20文字）
    case code           //コード選択のもの
}

struct ValidInfo {
    var required: Bool = false //true: 必須, false: 任意
    var keta: Int? = nil //桁数指定（一致のみOK）＊桁指定、min/max指定の両方は不可
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
        //文字種＆桁数・最小〜最大文字数チェック
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
    class func subValidateTypeLengtyByKey(_ editableModel: EditableModel) -> [EditableItemKey: [String]] {
        var dicError: [EditableItemKey: [String]] = [:]
        //文字種チェック
        for itemKey in editableModel.arrTextFieldNextDoneKey {
            if let item = editableModel.getItemByKey(itemKey) {
                let (isChange, editTemp) = editableModel.makeTempItem(item)
                let validInfo = editTemp.editItem.valid
                let type = validInfo.type
                if isChange {
                    var regexp: String = ""
                    var errMsg: String = ""

                    switch type {

                    case .undefine:
                        continue

                    case .hiraKataKan:
                        regexp = #"^[\p{Hiragana}\p{Katakana}\p{Han}]*$"#
                        if let bufMatch = getRegexMatchString(editTemp, regexp) {
                            if let keta = validInfo.keta {
                                errMsg = "\(keta)桁の漢字・カナ・かなで入力してください"
                            }
                            if let max = validInfo.max, bufMatch.count > max {
                                errMsg = "入力文字数が超過しています (\(max))"
                            }
                        } else {//正規表現にマッチしない（＝形式エラー）
                            errMsg = "漢字・カナ・かなで入力してください"
                        }

                    case .katakana:
                        regexp = #"^\p{Katakana}*$"#
                        if let bufMatch = getRegexMatchString(editTemp, regexp) {
                            if let keta = validInfo.keta {
                                errMsg = "\(keta)桁のカタカナで入力してください"
                            }
                            if let max = validInfo.max, bufMatch.count > max {
                                errMsg = "入力文字数が超過しています (\(max))"
                            }
                        } else {//正規表現にマッチしない（＝形式エラー）
                            errMsg = "カタカナで入力してください"
                        }

                    case .email:
                        regexp = #"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"#
                        if let bufMatch = getRegexMatchString(editTemp, regexp) {
                        } else {//正規表現にマッチしない（＝形式エラー）
                            errMsg = "メールアドレスが間違っています"
                        }

                    case .number:
                        regexp = #"^\d*$"#
                        if let bufMatch = getRegexMatchString(editTemp, regexp) {
                            if let keta = validInfo.keta {
                                errMsg = "\(keta)桁の数字で入力してください"
                            }
                            if let max = validInfo.max, bufMatch.count > max {
                                errMsg = "入力文字数が超過しています (\(max))"
                            }
                        } else {//正規表現にマッチしない（＝形式エラー）
                            errMsg = "数字で入力してください"
                        }

                    case .password: //type用パスワード（＊半角英数4~20文字）///^[0-9a-zA-Z]*$/
                        regexp = #"^[0-9a-zA-Z]{4,20}$"#
                        if let bufMatch = getRegexMatchString(editTemp, regexp) {
                        } else {//正規表現にマッチしない（＝形式エラー）
                            errMsg = "ログインできません。入力内容をご確認ください"
                        }

                    case .code: //「コード」なものはチェック不要　（＊""or数値かどうかをチェックしえとく？？）
                        continue

                    } //switch type {

                    print(#line, editTemp.debugDisp, regexp)
                    if errMsg.count > 0 {
                        dicError.addDicArrVal(key: item.editableItemKey, val: errMsg)
                    }
                }
            }
        }
        return dicError
    }
    //============================================
    //============================================
//    class func chkValidErrRegex(_ item: EditableItemH, _ pattern: String) -> Bool { //エラーあったらTrue
//        let text = item.curVal
//        //var pattern = #"^\d{\#(keta)}$"#
//        let regex = try! NSRegularExpression(pattern: pattern, options: [])
//        let matches = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
//        print(#line, #function, matches.count)
//        for ma in matches {
//            print(#line, #function, ma)
//        }
//
//        return (matches.count > 0) ? false : true
//    }
    //============================================
    //マッチングした文字列を返却し、それを使って戻り先でチェックする
    class func getRegexMatchString(_ item: EditableItemH, _ pattern: String) -> String? {
        let text = item.curVal
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
        if matches.count == 0 { return nil }
        //基本的に ^$　マッチングさせるので、matchesは 1つとして処理する
        for match in matches {
            for index in 0 ..< match.numberOfRanges {
                let nsRange = match.range(at: index)
                if let range = Range(nsRange, in: text) {
                    return String(text[range])
                }
            }
        }
        return ""
    }
    //============================================
}
