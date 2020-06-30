//
//  MdlEntry.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/23.
//  Copyright © 2020 ms-mb015. All rights reserved.
//
//アプリ用のモデル<MdlHoge>と、入力編集用のモデル<EditItemHoge>

import UIKit
import SwaggerClient
//import TudApi

class MdlEntry: Codable {
    //=== [C-9]応募フォーム
    //    case jobCardC9      //４．応募先求人
    //    case profileC9      //５．プロフィール（一部必須）
    //    case resumeC9       //６．履歴書（一部必須）
    //    case careerC9       //７．職務経歴書（一部必須）
    var ownPR: String = ""          //９．自己PR文字カウント
    var hopeArea: [Code] = []       //１０．希望勤務地（任意）
    var hopeSalary: Code = ""       //１１．希望年収（任意）
    var exQuestion1: String? = nil  //１２．独自質問（必須）
    var exQuestion2: String? = nil  //１２．独自質問（必須）
    var exQuestion3: String? = nil  //１２．独自質問（必須）
    var exAnswer1: String = ""      //１２．独自質問（必須）
    var exAnswer2: String = ""      //１２．独自質問（必須）
    var exAnswer3: String = ""      //１２．独自質問（必須）

    init(ownPR: String, hopeArea: [Code], hopeSalary: Code,
        exQuestion1: String? = nil, exQuestion2: String? = nil, exQuestion3: String? = nil,
        exAnswer1: String, exAnswer2: String, exAnswer3: String ) {
        self.ownPR = ownPR
        self.hopeArea = hopeArea
        self.hopeSalary = hopeSalary
        self.exQuestion1 = exQuestion1
        self.exQuestion2 = exQuestion2
        self.exQuestion3 = exQuestion3
        self.exAnswer1 = exAnswer1
        self.exAnswer2 = exAnswer2
        self.exAnswer3 = exAnswer3
    }
    convenience init() {
        self.init(ownPR: "", hopeArea: [], hopeSalary: "", exAnswer1: "", exAnswer2: "", exAnswer3: "" )
    }
    //ApiモデルをAppモデルに変換して保持させる
    //=== 作成・更新のモデルは、アプリ=>APIなので不要だな ===

    var debugDisp: String {
       return "[hopeArea:\(hopeArea)] [hopeSalary: \(hopeSalary)] [ownPR: \(ownPR)]"
        + "#1:[\(exQuestion1)]=[\(exAnswer1)] #2:[\(exQuestion2)]=[\(exAnswer2)]  #2:[\(exQuestion3)]=[\(exAnswer3)]"
    }
}
//=== 編集用の項目と定義など
enum EditItemMdlEntry: String, EditItemProtocol {
//=== [C-9]応募フォーム
case jobCard            //４．応募先求人
case profile            //５．プロフィール（一部必須）
case resume             //６．履歴書（一部必須）
case career             //７．職務経歴書（一部必須）
case exQuestionAnswer1  //１２．独自質問（必須）
case exQuestionAnswer2  //１２．独自質問（必須）
case exQuestionAnswer3  //１２．独自質問（必須）
case ownPR              //９．自己PR文字カウント
case hopeArea           //１０．希望勤務地（任意）
case hopeSalary         //１１．希望年収（任意）
    //表示名
    var dispName: String {
        switch self {
        case .jobCard:      return "応募先求人"
        case .profile:      return "プロフィール"
        case .resume:       return "履歴書"
        case .career:       return "職務経歴書"
        case .ownPR:        return "自己PR"
        case .hopeArea:     return "希望勤務地"
        case .hopeSalary:   return "希望年収"
        case .exQuestionAnswer1:   return "独自質問 1（必須）"
        case .exQuestionAnswer2:   return "独自質問 2（必須）"
        case .exQuestionAnswer3:   return "独自質問 3（必須）"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .hopeArea: return .entryPlace
        case .hopeSalary: return .salary
        default: return .undefine
        }
    }
    //Placeholder Text
    var placeholder: String {
        switch self {
        case .exQuestionAnswer1: return "回答を入力してください"
        case .exQuestionAnswer2: return "回答を入力してください"
        case .exQuestionAnswer3: return "回答を入力してください"
        case .ownPR: return "回答を入力してください"
        default:
            return ""//return "[\(self.itemKey) PlaceHolder]"
        }
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）

}
