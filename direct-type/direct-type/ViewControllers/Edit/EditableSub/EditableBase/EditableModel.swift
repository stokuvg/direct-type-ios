//
//  EditableBase.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/03/24.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

//汎用入力画面の種類
enum EditableGamen {
    case profile

    var disp: String {
        switch self {
        case .profile:  return "プロフィール"
        }
    }
}

class EditableModel {
    var editableGamen: EditableGamen! //画面種別の定義（必須）
    //↑PickerやSuggestなどの元となるTextFieldの管理なんかも、必要ならこれで管理しちゃう
    //編集可能項目の定義（グループテーブル利用）
    var arrData: [[EditableItemH]] = [[]]
    var dispSectionTitles: [String] = []//テーブルやコレクション以外では不要だが定義しておく
    //編集中の値の管理
    var editTempCD: [EditableItemKey: EditableItemCurVal] = [:]//String/CodeDispのCodeを入れておく（ItemEditable.curVal)
    //TextField渡り歩き用(これは EditableBaseに持っていくつもり）
    var dicTextFieldIndexPath: [EditableItemKey: IndexPath] = [:]
    var arrTextFieldNextDoneKey: [EditableItemKey] = []
    var lastEditableItemKey: EditableItemKey = "" //項目渡り歩いてのDoneに対応させるため

    //=== 表示項目の設定
    func initItemEditable(_ editableGamen: EditableGamen, _ item: Any) {
        self.editableGamen = editableGamen
        switch editableGamen {
        case .profile:
            guard let (mdlProfile) = item as? (MdlProfile) else { return } //タプルで受けれる!!
            let secDbg: [EditableItemH] = [
                EditableItemH(type: .readonly, editItem: EditItemUser.userId, val: mdlProfile.familyName),
            ]
            arrData = [secDbg]
            dispSectionTitles = ["開発確認項目"]

        }
        chkTableCellAll()//登録項目に応じて、TextFieldを渡り歩かせるための情報を生成しておく
    }
    //=======================================================================================================
    //すべてのテーブルのセルをチェックするとともに、その最後の入力可能TextFieldが存在するものを調べる
    //（フォーカスが当たらないものは、前次移動の対象とならないために除外する）
    func chkTableCellAll() {
        dicTextFieldIndexPath.removeAll()//項目とIndexPathの対応を保持
        arrTextFieldNextDoneKey.removeAll()//前次移動対象の項目を保持
        for (section, sectionItems) in arrData.enumerated() {
            for (row, item) in sectionItems.enumerated() {
                let idxPath: IndexPath = IndexPath(row: row, section: section)
                dicTextFieldIndexPath[item.editableItemKey] = idxPath //対応項目に対応するセルのIndexPathを求めて保持しておく
                var isSelectable: Bool = true
                switch item.editType {
                case .readonly:
                    isSelectable = false
                case .inputText, .inputTextSecret:
                    isSelectable = true
                case .selectDrum:
                    isSelectable = true //これ、どうしようか？（選択適用した後にnextCell処理を入れるなら含めてもOK）
                case .selectSingle, .selectMulti, .selectSpecisl:
                    isSelectable = true
                case .inputZipcode:
                    isSelectable = true
                case .selectDrumYMD:
                    isSelectable = true
                }
                if isSelectable {
                    arrTextFieldNextDoneKey.append(item.editableItemKey) //移動対象のものだけに絞る（ReadOnlyなど選択不可なものは除外
                    print(item.editableItemKey)

                }
            }
        }
        lastEditableItemKey = arrTextFieldNextDoneKey.last ?? "" //最後の項目のキーを保持させとく
    }
    //=== 編集中の値の保持
    func changeTempItem(_ item: EditableItemH, text: String) {
        editTempCD[item.editableItemKey] = text
        if item.orgVal == text {
            editTempCD.removeValue(forKey: item.editableItemKey)
        }
    }
    //=== EditableItemKeyを渡すと、現在の編集適用したEditableItemHを返す
    func getItemByKey(_ itemKey: EditableItemKey) -> EditableItemH? {
        guard let indexPath = dicTextFieldIndexPath[itemKey] else { return nil }
        let item = arrData[indexPath.section][indexPath.row]
        let (_, editTemp) = makeTempItem(item)
        return editTemp
    }
    //変更なければnil返す（変更検知のため）
    func makeTempItem(_ item: EditableItemH) -> (Bool, EditableItemH) {
        if let tempCD = editTempCD[item.editableItemKey] {
            var result = item
            result.curVal = tempCD
            return (true, result)
        } else {
            return (false, item)
        }
    }
    //=== 親子関係選択の対応
    //〔x〕ボタンが押された時、依存先も合わせて、値を空("")にする
    //指定したitemKeyの依存先の値をクリアする
    func clearDependencyItemByKey(_ itemKey: EditableItemKey) -> EditableItemKey? {
        //親子の依存関係がある場合に、親の選択が変わったため、子の選択をクリアし、未選択にする
        let (depKey, _) = SelectItemsManager.shared.chkChild(itemKey, editTempCD: editTempCD)
        if let depKey = depKey { //依存関係あるけど未選択だった場合
            guard let indexPath = dicTextFieldIndexPath[depKey] else { return nil }
            let item = arrData[indexPath.section][indexPath.row]
            changeTempItem(item, text: "")//依存しているものを空に設定（＊UITextField()を渡しても、まったく未使用なので問題ない）
//            dispCellAtItemKey(depKey)//描画しておく
            return depKey //処理したキーを返す
        }
        return nil
    }
    //指定した itemKeyのものに親がいれ、その選択状況も反映させた選択肢一覧データを取得する
    func makePickerItems(itemKey: EditableItemKey) -> [CodeDisp] {
        let selectionItems: [CodeDisp]
        //親子の依存関係がある場合に、親が選択済か調べる。選択済の場合には、それで絞り込んだ一覧データを返す
        let (depKey, depCurSel) = SelectItemsManager.shared.chkParent(itemKey, editTempCD: editTempCD)
        if let depKey = depKey {
            if depCurSel != "" {
                selectionItems = SelectItemsManager.getSelectItemsByKey(itemKey, grpCodeFilter: depCurSel)//しぼりこみがあるばあい
            } else {
                selectionItems = [Constants.SelectItemsUndefine] //「未定義」な値を表示させておく
            }
        } else {
            selectionItems = SelectItemsManager.getSelectItemsByKey(itemKey, grpCodeFilter: nil)//しぼりこみがないばあい
        }
        return selectionItems
    }

}
