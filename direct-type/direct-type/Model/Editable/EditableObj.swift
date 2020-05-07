//
//  EditableObj.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/03/11.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import Foundation

typealias EditableItemCurVal = String
typealias EditableItemKey = String //EditItemProtocol.itemKey
typealias ValidationErrMsg = String

protocol EditItemProtocol {
    var itemKey: String { get }
    var dispName: String { get }
    var placeholder: String { get }
}

enum EditType {
    case readonly           //String
    case inputText          //String
    case inputTextSecret    //String
    case suggestInputText   //String
    case selectDrum         //一覧からの選択（Drumで表示）
    case selectSingle       //一覧からの選択（単体選択）
    case selectMulti        //一覧からの選択（複数選択）
    case selectSpecisl      //一覧からの選択（大分類→小分類→年数）
}
struct EditableItem {
    var editableItemKey: String //全項目を通してUniqueになるように設定しておきたい項目キー（画面内Unique必須）
    var editItem: EditItemProtocol//編集可能項目定義（基本的にはAPIモデルと対応させる）
    var editType: EditType  //項目の編集タイプ（直接入力やマスタ選択など）
    var dispName: String { //項目表示名
        get { return editItem.dispName }
    }
    var placeholder: String {
        get { return editItem.placeholder }
    }
    let orgVal: String!     //String/CodeDisp/[CodeDisp]が入る（更新前の値）
    var curVal: String     //String/CodeDisp/[CodeDisp]が入る（現在の選択値）
    var valDisp: String {
        let _val = curVal
        switch editType {
        //=== そのまま値を表示してよいもの
        case .readonly, .inputText, .inputTextSecret:
            return "\(_val)"
        //=== 選択肢一覧を取得し、指定項目の表示名を求めて表示するもの
        case .selectDrum:
            let selectionItems = SelectItemsManager.getSelectItems(type: self.editItem, grpCodeFilter: nil)
            let buf = selectionItems.filter { (obj) -> Bool in
                obj.code == _val
            }.first?.disp ?? Constants.SelectItemsUndefine.disp
            return "\(buf)"
        case .suggestInputText:
            return "\(_val)"

        case .selectSingle, .selectMulti, .selectSpecisl:
            let selectionItems = SelectItemsManager.getSelectItems(type: self.editItem, grpCodeFilter: nil)
            let buf = selectionItems.filter { (obj) -> Bool in
                obj.code == _val
            }.first?.disp ?? Constants.SelectItemsUndefine.disp
            return "\(buf)(仮)"
        }
    }
    var debugDisp: String {
        let selectionItems = SelectItemsManager.getSelectItems(type: self.editItem, grpCodeFilter: nil)
        let cnt = selectionItems.count
        return "[\(editableItemKey)]\t[\(editType)] [\(dispName)] ... [\(orgVal!)] -> [\(curVal)] / (\(cnt)件)"
    }
    
    //=== 初期化 ===
    init(type: EditType, editItem: EditItemProtocol, val code: String) {
        self.editType = type
        self.editItem = editItem
        self.editableItemKey = editItem.itemKey
        self.orgVal = code
        self.curVal = code
    }
}


protocol EditableObj: Codable {
    //JSON変換して保存など
    var jsonObj: [String: Codable] { get }
    var jsonStr: String { get }
    static func fromJsonStr(_ jsonStr: String) -> Self
}
extension EditableObj {
    var jsonStr: String {
        do {
            let model = jsonObj
            let jsonData = try JSONSerialization.data(withJSONObject: model, options: [.prettyPrinted])
            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
            return jsonStr
        } catch let error {
            print(error)
            return ""
        }
    }
    static func fromJsonStr(_ jsonStr: String) -> Self {
        let jsonData = jsonStr.data(using: .utf8)
        let obj = try! JSONDecoder().decode(Self.self, from: jsonData!)
        return obj
    }
}

//=== 選択項目で、内部用Codeとユーザ表示用Dispを扱えるようにするもの（内部用CodeはAPI指定に使うものと同一だと管理が楽）
class CodeDisp: Codable {
    var code: String
    var disp: String
    
    var debugDisp: String {
        return "[\(code)]: [\(disp)]"
    }
    init(_ code: String = "", _ disp: String) {
        self.code = code
        self.disp = disp
    }
}
//ハッシュ(Set)対応させておく
extension CodeDisp: Hashable {
    public func hash(into hasher: inout Hasher) {
        code.hash(into: &hasher)
        disp.hash(into: &hasher)
    }
    static func == (lhs: CodeDisp, rhs: CodeDisp) -> Bool {
        return lhs.code == rhs.code && lhs.disp == rhs.disp
    }
}

//=== 「大分類」「小分類」なものに対応できるように拡張
//選択項目の管理
class GrpCodeDisp: Codable {
    var grp: String
    var codeDisp: CodeDisp
    
    var debugDisp: String {
        return "<\(grp)> [\(codeDisp.code)]: [\(codeDisp.disp)]"
    }
    init(_ grp: String = "", _ code: String = "", _ disp: String) {
        self.grp = grp
        self.codeDisp = CodeDisp(code, disp)
    }
}

//======
class SortCodeDisp: Codable {
    var sortNum: Int
    var code: String
    var disp: String
    
    var debugDisp: String {
        return "[\(sortNum)]\t [\(code)]: [\(disp)]"
    }
    init(_ sortNum: String, _ code: String = "", _ disp: String) {
        self.sortNum = Int(sortNum) ?? 0
        self.code = code
        self.disp = disp
    }
}
//ハッシュ(Set)対応させておく
extension SortCodeDisp: Hashable {
    public func hash(into hasher: inout Hasher) {
        sortNum.hash(into: &hasher)
        disp.hash(into: &hasher)
        disp.hash(into: &hasher)
    }
    static func == (lhs: SortCodeDisp, rhs: SortCodeDisp) -> Bool {
        return lhs.sortNum == rhs.sortNum && lhs.code == rhs.code && lhs.disp == rhs.disp
    }
}
class SortGrpCodeDisp: Codable {
    var sortNum: Int
    var grp: String
    var codeDisp: CodeDisp
    
    var debugDisp: String {
        return "[\(sortNum)]\t <\(grp)> [\(codeDisp.code)]: [\(codeDisp.disp)]"
    }
    init(_ grp: String = "", _ sortNum: String, _ code: String = "", _ disp: String) {
        self.grp = grp
        self.sortNum = Int(sortNum) ?? 0
        self.codeDisp = CodeDisp(code, disp)
    }
}



//let grp = ""
//var arrFilter: [CodeDisp] = []
//for item in arr {
//    if item.grp == grp {
//        arrFilter.append(item.codeDisp)
//    }
//}

