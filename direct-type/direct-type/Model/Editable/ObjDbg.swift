//
//  ObjDbg.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/03/11.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import Foundation

struct ObjDbg: EditableObj {
    var textCompany: String = ""
    var textHyakunin: String = ""
    var textAlphabet: String = ""
    var textKatakana: String = ""
    var password: String = ""
    var prefecture: String = "13" //都道府県（マスタありサンプル）：初期選択コードを入れておくべき!
    var jobType: String = ""
    var occupation: String = ""

    var debugDisp: String {
        return "[\(textAlphabet)] [\(textKatakana)] [\(password)]"
    }
    enum CodingKeys: String, CodingKey {
        case textCompany = "text_company"
        case textHyakunin = "text_hyakunin"
        case textAlphabet = "text_alphabet"
        case textKatakana = "text_katakana"
        case password
        case prefecture
        case jobType = "job_type"
        case occupation
    }
}

//=== 開発用の項目と定義など
//ObjDbgと対応させる
enum EditItemDbg: String, EditItemProtocol {
    case suggestCompany
    case suggestHyakunin
    case textAlphabet
    case textKatakana
    case password
    case prefecture
    case jobType
    case occupation
    //表示名
    var dispName: String {
        switch self {
        case .suggestCompany:   return "企業名（Suggest可能）"
        case .suggestHyakunin:  return "百人一首（Suggest可能）"
        case .textAlphabet:     return "半角英数字"
        case .textKatakana:     return "全角カタカナ"
        case .password:         return "パスワード"
        case .prefecture:       return "都道府県"
        case .jobType:          return "職種（大分類）"
        case .occupation:       return "職種（小分類）"
        }
    }
    //Placeholder Text
    var placeholder: String {
        switch self {
        case .suggestCompany:   return "サジェスト可能になっています"
        case .suggestHyakunin:  return "サジェスト可能になっています"
        case .textAlphabet:     return "半角英数字を入力してください（制御はしていません）"
        case .textKatakana:     return "全角カタカナを入力してください（制御はしていません）"
        case .password:         return "パスワードを入力してください"
        case .prefecture:       return "都道府県を選択してください"
        case .jobType:          return "職種（大分類）"
        case .occupation:       return "職種（小分類）"
        }
    }
    var itemKey: String {
        return "Dbg_\(self.rawValue)" //ここでUniqになるようにしておく
    }
}
extension ObjDbg {
    var jsonObj: [String: Codable] {
        var item: [String: Codable] = [:]
        item[EditItemDbg.textAlphabet.rawValue] = self.textAlphabet
        item[EditItemDbg.textKatakana.rawValue] = self.textKatakana
        item[EditItemDbg.password.rawValue] = self.password
        item[EditItemDbg.prefecture.rawValue] = self.prefecture
        return item
    }
}

