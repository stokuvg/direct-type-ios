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
    let orgVal: String!     //String/CodeDisp/[CodeDisp]が入る（更新前の値）
    var curVal: String     //String/CodeDisp/[CodeDisp]が入る（現在の選択値）
    var valDisp: String {
        let _val = curVal
        switch editType {
        //=== そのまま値を表示してよいもの
        case .readonly, .inputText, .inputTextSecret:
            return "\(_val)"
        case .inputMemo://改行コードの扱いの考慮が必要か？
            return "\(_val)"
        case .inputZipcode:
            return "\(_val)"
        //=== 選択肢一覧を取得し、指定項目の表示名を求めて表示するもの
        case .selectDrumYMD:
            let buf = _val//???Dateを表示ように変換
            return "\(buf)"
        //=== 選択肢一覧を取得し、指定項目の表示名を求めて表示するもの
        case .selectDrum:
            let buf: String = SelectItemsManager.getCodeDisp(self.editItem.tsvMaster, code: _val)?.disp ?? Constants.SelectItemsUndefine.disp
            return "\(buf)"

        case .selectSingle:
            let buf: String = SelectItemsManager.getCodeDisp(self.editItem.tsvMaster, code: _val)?.disp ?? Constants.SelectItemsUndefine.disp
            return "\(buf)"

        case .selectMulti:
            let tmp0: String = _val
            var arr0: [String] = []
            for code in tmp0.split(separator: "_").sorted() { //コード順ソートしておく
                let buf: String = SelectItemsManager.getCodeDisp(self.editItem.tsvMaster, code: String(code))?.disp ?? Constants.SelectItemsUndefine.disp
                arr0.append(buf)
            }
            let buf0: String = arr0.joined(separator: " ")
            return "\(buf0)"
            
        case .selectSpecial:
            let tmp0: String = _val
            var arr0: [String] = []
            for code in tmp0.split(separator: "_").sorted() { //コード順ソートしておく
                let buf: String = SelectItemsManager.getCodeDispSyou(self.editItem.tsvMaster, code: String(code))?.disp ?? Constants.SelectItemsUndefine.disp
                arr0.append(buf)
            }
            let buf0: String = arr0.joined(separator: " ")
            return "\(buf0)"
            
        case .selectSpecialYear:
            let tmp0: String = _val
            var arr0: [String] = []
            print("\t🐼[\(tmp0)]🐼これが選択されました🐼🐼")//編集中の値の保持（と描画）
            for item in SelectItemsManager.convCodeDisp(editItem.tsvMaster, tmp0) {
                print(item.debugDisp)
            }


            print(#line, #function, "✳️✳️✳️✳️ [_val: \(_val)] ✳️✳️✳️✳️ 複数種類を結合して保持させるお程")
            let (dai, syou): ([CodeDisp], [GrpCodeDisp]) = SelectItemsManager.getMaster(editItem.tsvMaster)
            let buf = dai.description

            return "\(buf)"

        }
    }
    var debugDisp: String {
//        let selectionItems = SelectItemsManager.getSelectItems(type: self.editItem, grpCodeFilter: nil)
        let selectionItems: [CodeDisp] = SelectItemsManager.getMaster(self.editItem.tsvMaster)
        let cnt = selectionItems.count
        return "[\(editableItemKey)]\t[\(editType)] [\(dispName)] ... [\(orgVal!)] -> [\(curVal)] / (\(cnt)件)"
    }
    
    //=== 初期化 ===
    init(type: EditType, editItem: EditItemProtocol, val code: Code) {
        self.editType = type
        self.editItem = editItem
        self.editableItemKey = editItem.itemKey
        self.orgVal = code
        self.curVal = code
    }
}
