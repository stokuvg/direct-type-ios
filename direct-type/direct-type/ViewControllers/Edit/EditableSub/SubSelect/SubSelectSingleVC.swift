//
//  SubSelectSingleVC.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/04/22.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

class SubSelectSingleVC: SubSelectBaseVC {
    func initData(editableItem: EditableItemH, selectingCodes: String) {
        self.editableItem = editableItem
        self.mainTsvMaster = editableItem.editItem.tsvMaster
        //選択肢一覧を取得する（グループタイプはSpecialを利用するため来ない想定）
        let cd: [CodeDisp] = SelectItemsManager.getMaster(self.mainTsvMaster)
        let (grp, gcd): ([CodeDisp], [GrpCodeDisp]) = SelectItemsManager.getMaster(self.mainTsvMaster)
        if grp.count != 0 {
            print("*** （グループタイプはSpecialを利用するため、本番では来ない想定）")
            print("[cd: \(cd.count)] / [grp: \(grp.count)] [gcd: \(gcd.count)] ")
        }
        self.arrData = (grp.count != 0) ? grp : cd
    }
    func dispData() {
        let bufTitle: String = "\(editableItem.dispName) \(arrData.count)件"
        lblTitle.text(text: bufTitle, fontType: .font_L, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispData()
    }
}

extension SubSelectSingleVC: UITableViewDataSource, UITableViewDelegate {
    //=== 通常テーブル
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = arrData[indexPath.row]
        let cell: SubSelectTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_SubSelectTBCell", for: indexPath) as! SubSelectTBCell
        //選択状態があるかチェックして反映させる
        let vals = "".split(separator: "_") //選択状態をバラす
        let select0: Bool = vals.contains { (val) -> Bool in val == item.code }//item.valに選択されているもの配列が付いているので、そこにあるかチェック
        let select: Bool = dicChange[item.code] ?? select0  //差分情報優先
        let select2: Bool = dicChange[item.code] ?? false
        if select0 != select {
            print("[sel0: \(select0)]  [tempSel: \(select2)] => [\(select)]")
        }
        cell.initCell(self, item, select)
        cell.dispCell()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        let item = arrData[indexPath.row]
        dicChange.removeAll() //Single選択の場合は、まるっと削除してから追加
        let vals = "".split(separator: "_") //選択状態をバラす
        let select0: Bool = vals.contains { (val) -> Bool in val == item.code }//item.valに選択されているもの配列が付いているので、そこにあるかチェック
        let select: Bool = dicChange[item.code] ?? select0  //差分情報優先
        dicChange[item.code] = !select
        //該当セルの描画しなおし
        tableView.reloadData()
        //actPopupSelect(changeItem: item)//選択したもの即時反映の場合
    }
}

extension SubSelectSingleVC: SubSelectProtocol {    
}
