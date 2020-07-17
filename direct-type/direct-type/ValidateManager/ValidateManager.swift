//
//  ValidateManager.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

enum ValidType {
    case undefine       //特にチェックなし
    case zenkaku        //全角(改行などOK)
    case hiraKataKan    //ひらカタ漢字
    case katakana       //全角カタカナ
    case email          //メールアドレス
    case number         //半角数字
    case password       //type用パスワード（＊半角英数4~20文字）
    case code           //コード選択のもの
    case model          //モデルなもの（Validate何もしない)
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
                dicError.addDicArrVal(key: key, val: val)
            }
        }
        //文字種＆桁数・最小〜最大文字数チェック
        for (key, vals) in subValidateTypeLengtyByKey(editableModel) {
            for val in vals {
                dicError.addDicArrVal(key: key, val: val)
            }
        }
        //追加の特殊チェック（複数項目での関連あり）
        for (key, vals) in subValidateSpecialCheck(editableModel) {
            for val in vals {
                dicError.addDicArrVal(key: key, val: val)
            }
        }

        return dicError
    }
    //============================================
    class func subValidateSpecialCheck(_ editableModel: EditableModel) -> [EditableItemKey: [String]] {
        var dicError: [EditableItemKey: [String]] = [:]
        //===「学部」「学科・専攻」は、併せて全角30文字
        if let item1 = editableModel.getItemByKey(EditItemMdlResumeSchool.faculty.itemKey),
            let item2 = editableModel.getItemByKey(EditItemMdlResumeSchool.department.itemKey) {
            let buf = "\(item1.curVal)\(item2.curVal)"
            if buf.count > 30 {
                dicError.addDicArrVal(key: item1.editableItemKey, val: "入力文字数が超過しています")
                dicError.addDicArrVal(key: item2.editableItemKey, val: "入力文字数が超過しています")
            }
        }
        return dicError
    }
    //============================================
    class func subValidateNotEmntyByKey(_ editableModel: EditableModel) -> [EditableItemKey: [String]] {
        var dicError: [EditableItemKey: [String]] = [:]
        //必須チェック
        for itemKey in editableModel.dicTextFieldIndexPath.keys {
            if let item = editableModel.getItemByKey(itemKey) {
                let validInfo = item.editItem.valid
                guard validInfo.required == true else { continue }
                let (_, editTemp) = editableModel.makeTempItem(item)
                //日付タイプの特例
                switch editTemp.editType {
                case .selectDrumYM:
                    let date: Date = DateHelper.convStrYM2Date(editTemp.curVal)
                    if date == Constants.SelectItemsUndefineDate {
                        dicError.addDicArrVal(key: item.editableItemKey, val: "選択してください")
                    }
                case .selectDrumYMD:
                    let date: Date = DateHelper.convStrYMD2Date(editTemp.curVal)
                    if date == Constants.SelectItemsUndefineDate {
                        dicError.addDicArrVal(key: item.editableItemKey, val: "選択してください")
                    }
                default:
                    if editTemp.curVal == "" {
                        dicError.addDicArrVal(key: item.editableItemKey, val: (validInfo.type == .code) ? "選択してください" : "未入力です。入力してください")
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
        for itemKey in editableModel.dicTextFieldIndexPath.keys {
            if let item = editableModel.getItemByKey(itemKey) {
                let validInfo = item.editItem.valid
                let (_, editTemp) = editableModel.makeTempItem(item)
                let type = validInfo.type
                var regexp: String = ""
                var errMsg: String = ""

                switch type {
                case .model: break // 何もチェックしない

                case .undefine:
                    regexp = #"^.*$"#
                    if let bufMatch = getRegexMatchString(editTemp, regexp) {
                        if let keta = validInfo.keta, bufMatch.count != keta {
                            if bufMatch.isEmpty && validInfo.required == false { continue } //桁指定あっても必須じゃなければ0桁は許される
                            errMsg = "\(keta)桁の文字で入力してください"
                        }
                        if let max = validInfo.max, bufMatch.count > max {
                            errMsg = "入力文字数が超過しています (\(max))"
                        }
                    } else {//正規表現にマッチしない（＝形式エラー）
                        errMsg = Constants.DbgDispStatus ? "入力してください [\(regexp)]" : "入力してください"
                    }

                case .zenkaku:
                    //regexp = #"^[ー\p{Hiragana}\p{Katakana}\p{Han}\n]*$"#
                    regexp = #"^[[^\x01-\x7E]\n]*$"#
                    if let bufMatch = getRegexMatchString(editTemp, regexp) {
                        if let keta = validInfo.keta, bufMatch.count != keta {
                            if bufMatch.isEmpty && validInfo.required == false { continue } //桁指定あっても必須じゃなければ0桁は許される
                            errMsg = "\(keta)桁の全角文字で入力してください"
                        }
                        if let max = validInfo.max, bufMatch.count > max {
                            errMsg = "入力文字数が超過しています (\(max))"
                        }
                    } else {//正規表現にマッチしない（＝形式エラー）
                        errMsg = Constants.DbgDispStatus ? "全角文字で入力してください [\(regexp)]" : "全角文字で入力してください"
                    }

                case .hiraKataKan:
                    regexp = #"^[\p{Hiragana}\p{Katakana}\p{Han}]*$"#
                    if let bufMatch = getRegexMatchString(editTemp, regexp) {
                        if let keta = validInfo.keta, bufMatch.count != keta {
                            if bufMatch.isEmpty && validInfo.required == false { continue } //桁指定あっても必須じゃなければ0桁は許される
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
                        if let keta = validInfo.keta, bufMatch.count != keta {
                            if bufMatch.isEmpty && validInfo.required == false { continue } //桁指定あっても必須じゃなければ0桁は許される
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
                        if let keta = validInfo.keta, bufMatch.count != keta {
                            if bufMatch.isEmpty && validInfo.required == false { continue } //桁指定あっても必須じゃなければ0桁は許される
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

                if errMsg.count > 0 {
                    dicError.addDicArrVal(key: item.editableItemKey, val: errMsg)
                }
            }
        }
        return dicError
    }
    //============================================
    //マッチングした文字列を返却し、それを使って戻り先でチェックする
    class func getRegexMatchString(_ item: EditableItemH, _ pattern: String) -> String? {
        let text = item.curVal
        let regex = try! NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
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


