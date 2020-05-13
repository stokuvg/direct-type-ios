//
//  SubSelectMultiVC.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/04/22.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

protocol SubSelectMultiDelegate {
    func actPopupSelect(changeItems: [String: Bool])
    func actPopupCancel()
}

class SubSelectMultiVC: BaseVC {
    var type: SelectItemsManager.TsvMaster!
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
        actPopupSelect(changeItems: ["4" : true])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "項目選択のサブ画面"
    }
    func initData(type: SelectItemsManager.TsvMaster) {
        self.type = type
        self.arrData = SelectItemsManager.getMaster(type)
        print(self.arrData.count, self.arrData.debugDescription)
    }
    func dispData() {
        self.lblTitle.text = "\(self.arrData.count)件"
        print(self.arrData.count, self.arrData.debugDescription)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        dispData()
    }
}

extension SubSelectMultiVC: UITableViewDataSource, UITableViewDelegate {
    //=== 通常テーブル
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = arrData[indexPath.row]
        let cell: SubSelectTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_SubSelectTBCell", for: indexPath) as! SubSelectTBCell
        //選択状態があるかチェックして反映させる
        let vals = "1_3_5".split(separator: "_") //選択状態をバラす
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
        let vals = "1_3_5".split(separator: "_") //選択状態をバラす
        let select0: Bool = vals.contains { (val) -> Bool in val == item.code }//item.valに選択されているもの配列が付いているので、そこにあるかチェック
        let select: Bool = dicChange[item.code] ?? select0  //差分情報優先
        dicChange[item.code] = !select
        //該当セルの描画しなおし
        tableView.reloadRows(at: [indexPath], with: .none)
        print(#line, #function, item.debugDisp)
    }
}

extension SubSelectMultiVC: SubSelectProtocol {
    
}

//=== 複数選択ポップアップで選択させる場合の処理 ===
extension SubSelectMultiVC: SubSelectMultiDelegate {
    func actPopupSelect(changeItems: [String : Bool]) {
        let curCodes = "1_3_5".split(separator: "_").map { (obj) -> String in String(obj) }
        var selCodes: Set<String> = Set(curCodes)
        
        for change in changeItems {
            if change.value {
                selCodes.insert(change.key)
            } else {
                selCodes.remove(change.key)
            }
        }
        //選択されているコードを連結文字列にする
        let codes = selCodes.joined(separator: "/")
        print(codes)//編集中の値の保持（と描画）
        self.navigationController?.popViewController(animated: true)
    }
    func actPopupCancel() {
        self.navigationController?.popViewController(animated: true)
    }
}

