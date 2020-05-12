//
//  SubSelectSingleVC.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/04/22.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

protocol SubSelectSingleDelegate {
    func actPopupSelect(changeItem: CodeDisp)
    func actPopupCancel()
}

class SubSelectSingleVC: BaseVC {
    var type: SelectItemsManager.TsvMaster!
    var editableItem: EditableItemH!
    var arrData: [CodeDisp] = []
//    var dicSelectedCode: Set<CodeDisp> = []
    var dicChange: [String: Bool] = [:]  //CodeDisp.code : true

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableVW: UITableView!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBAction func actCancel(_ sender: UIButton) {
        actPopupCancel()
    }
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        actPopupSelect(changeItem: CodeDisp("2", "hogehoge"))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "項目選択のサブ画面"
    }
    func initData(editableItem: EditableItemH, type: SelectItemsManager.TsvMaster) {
        self.type = type
        self.editableItem = editableItem
        self.arrData = SelectItemsManager.getMaster(type)
    }
    func dispData() {
        self.lblTitle.text = "\(editableItem.dispName) \(arrData.count)件"
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
        dicChange.removeAll() //Single選択の場合は、まるっと削除して仕舞えば良い
        let vals = "".split(separator: "_") //選択状態をバラす
        let select0: Bool = vals.contains { (val) -> Bool in val == item.code }//item.valに選択されているもの配列が付いているので、そこにあるかチェック
        let select: Bool = dicChange[item.code] ?? select0  //差分情報優先
        dicChange[item.code] = !select
        //該当セルの描画しなおし
//        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.reloadData()
        print(#line, #function, item.debugDisp, dicChange.count, dicChange.description)
//        actPopupSelect(changeItem: item)
    }
}

extension SubSelectSingleVC: SubSelectProtocol {
    
}

//=== 複数選択ポップアップで選択させる場合の処理 ===
extension SubSelectSingleVC: SubSelectSingleDelegate {
    func actPopupSelect(changeItem: CodeDisp) {
        print(changeItem.debugDisp)//編集中の値の保持（と描画）
        self.navigationController?.popViewController(animated: true)
    }
    func actPopupCancel() {
        self.navigationController?.popViewController(animated: true)
    }
}

