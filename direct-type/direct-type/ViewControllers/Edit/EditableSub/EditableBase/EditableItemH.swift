//
//  EditableItemH.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/11.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

struct EditableItemH {
    var editableItemKey: String //全項目を通してUniqueになるように設定しておきたい項目キー（画面内Unique必須）
    var editItem: EditItemProtocol//編集可能項目定義（基本的にはAPIモデルと対応させる）
    var editType: EditType  //項目の編集タイプ（直接入力やマスタ選択など）
    var dispName: String { //項目表示名
        get { return editItem.dispName }
    }
    var placeholder: String {
        get { return editItem.placeholder }
    }
    var dispUnit: String {
        get { return editItem.dispUnit }
    }
    var exQuestion: String
    var exModel: Any? = nil   //拡張情報
    let orgVal: String!     //String/CodeDisp/[CodeDisp]が入る（更新前の値）
    var curVal: String     //String/CodeDisp/[CodeDisp]が入る（現在の選択値）    
    var valDisp: String {
        let _val = curVal
        switch editType {
        //=== モデル一塊のもの
        case .model:
            return "**モデルひとかたまり表示**"
        //=== そのまま値を表示してよいもの
        case .readonly, .inputText, .inputTextSecret:
            return "\(_val)"
        case .inputMemo://改行コードの扱いの考慮が必要か？
            return "\(_val)"
        case .inputZipcode:
            return "\(_val)"
        //=== 選択肢一覧を取得し、指定項目の表示名を求めて表示するもの
        case .selectDrumYMD:
            let date = DateHelper.convStrYMD2Date(_val)
            if date == Constants.SelectItemsUndefineDate {
                return Constants.SelectItemsUndefineDateJP
            }
            let buf = date.dispYmJP()
            return "\(buf)"
        //=== 選択肢一覧を取得し、指定項目の表示名を求めて表示するもの
        case .selectDrumYM:
            let date = DateHelper.convStrYM2Date(_val)
            if date == Constants.SelectItemsUndefineDate {
                return Constants.SelectItemsUndefineDateJP
            }
            let buf = date.dispYmJP()
            return "\(buf)"

        case .selectSingle:
            let buf: String = SelectItemsManager.getCodeDisp(self.editItem.tsvMaster, code: _val)?.disp ?? Constants.SelectItemsUndefine.disp
            return "\(buf)"

        case .selectMulti:
            let tmp0: String = _val
            var arr0: [String] = []
            for cd in SelectItemsManager.convCodeDisp(.entryPlace, tmp0) { //マスタ順ソートしておく
                arr0.append(cd.disp)
            }
            let buf0: String = arr0.joined(separator: " ")
            return "\(buf0)"
            
        case .selectSpecial:
            return "selectSpecial表示確認: [\(_val)]"

        case .selectSpecialYear:
            return "selectSpecialYear表示確認: [\(_val)]"
        }
    }
    var debugDisp: String {
        let selectionItems: [CodeDisp] = SelectItemsManager.getMaster(self.editItem.tsvMaster)
        let cnt = selectionItems.count
        return "[\(editableItemKey)]\t[\(editType)] [\(dispName)] ... [\(orgVal!)] -> [\(curVal)]\(dispUnit) / (\(cnt)件) : [\(exQuestion)]"
    }
    
    //=== 初期化 ===
    init(type: EditType, editItem: EditItemProtocol, val code: Code, exQuestion: String = "", exModel: Any? = nil) {
        self.editType = type
        self.editItem = editItem
        self.editableItemKey = editItem.itemKey
        self.orgVal = code
        self.curVal = code
        self.exQuestion = exQuestion
        self.exModel = exModel
    }
}
