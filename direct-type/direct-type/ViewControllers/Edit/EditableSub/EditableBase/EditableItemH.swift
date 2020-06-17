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
//            let buf = _val//???Dateを表示ように変換
            let date = DateHelper.convStrYMD2Date(_val)
            let buf = date.dispYmJP()
            return "\(buf)"
        //=== 選択肢一覧を取得し、指定項目の表示名を求めて表示するもの
        case .selectDrumYM:
            switch editableItemKey {
            case EditItemMdlCareerCardWorkPeriod.startDate.itemKey: fallthrough
            case EditItemMdlAppSmoothCareerComponyDescriptionWorkPeriod.workStartDate.itemKey:
                return Constants.DefaultSelectWorkPeriodStartDate.dispYmJP()
            case EditItemMdlCareerCardWorkPeriod.endDate.itemKey: fallthrough
            case EditItemMdlAppSmoothCareerComponyDescriptionWorkPeriod.workEndDate.itemKey:
                return Constants.DefaultSelectWorkPeriodEndDate.dispYmJP()
            default:
                let date = DateHelper.convStrYM2Date(_val)
                let buf = date.dispYmJP()
                return "\(buf)"
            }

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
            var disp: [String] = []
            for job in _val.split(separator: "_") {
                let buf = String(job).split(separator: ":")
                guard buf.count == 2 else { continue }
                let tmp0 = String(buf[0])
                let tmp1 = String(buf[1])
                let buf0: String = SelectItemsManager.getCodeDispSyou(.jobType, code: tmp0)?.disp ?? ""
                let buf1: String = SelectItemsManager.getCodeDisp(.jobExperimentYear, code: tmp1)?.disp ?? ""
                let bufExperiment: String = "[\(buf0) \(buf1)]"
                disp.append(bufExperiment)
            }
            return disp.count == 0 ? Constants.SelectItemsValEmpty.disp : disp.joined(separator: "\n")
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
