//
//  SubSelectBaseVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/21.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit


protocol SubSelectBaseDelegate {
    func actPopupSelect(selectedItemsCode: String)
    func actPopupCancel()
}
protocol SubSelectFeedbackDelegate {
    func changedSelect(codes: String)
}
class SubSelectBaseVC: BaseVC {
    var delegate: SubSelectFeedbackDelegate? = nil
    var singleMode: Bool = true
    var selectCodes: String = ""
    
    var editableItem: EditableItemH!
    var arrData: [CodeDisp] = []
    var dicChange: [String: Bool] = [:]  //CodeDisp.code : true
    var mainTsvMaster: SelectItemsManager.TsvMaster = .undefine

    @IBOutlet weak var vwHead: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func actBack(_ sender: UIButton) {
        actPopupCancel()
    }

    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var tableVW: UITableView!
    
    @IBOutlet weak var vwFoot: UIView!
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        var arrResult: [String] = []
        let arr = dicChange.filter { (cb) -> Bool in cb.value }
        for item in arr { arrResult.append(item.key) }
        let bufResult: String = arrResult.joined(separator: "_")
        actPopupSelect(selectedItemsCode: bufResult)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //====デザイン適用
        vwHead.backgroundColor = UIColor.init(colorType: .color_main)!
        vwMain.backgroundColor = UIColor.init(colorType: .color_white)!
        vwFoot.backgroundColor = UIColor.init(colorType: .color_main)!
        btnCommit.setTitle(text: "選択", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
    }
    func initData(_ delegate: SubSelectFeedbackDelegate, editableItem: EditableItemH, selectingCodes: String) {
        self.delegate = delegate
        self.editableItem = editableItem
        self.mainTsvMaster = editableItem.editItem.tsvMaster
        self.selectCodes = selectingCodes
        for key in selectingCodes.split(separator: "_") {
            self.dicChange[String(key)] = true
        }
        //選択肢一覧を取得する（グループタイプはSpecialを利用するため来ない想定ではある）
        let cd: [CodeDisp] = SelectItemsManager.getMaster(self.mainTsvMaster)
        let (grp, _): ([CodeDisp], [GrpCodeDisp]) = SelectItemsManager.getMaster(self.mainTsvMaster)
        //print("[cd: \(cd.count)] / [grp: \(grp.count)] [gcd: \(gcd.count)] ")
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

//=== 単一・複数選択ポップアップで選択させる場合の処理 ===
extension SubSelectBaseVC: SubSelectBaseDelegate {
    func actPopupSelect(selectedItemsCode: String) {
        print("\t🐼[\(selectCodes)]🐼 => [\(selectedItemsCode)]🐼これが選択されました🐼🐼")//編集中の値の保持（と描画）
        for item in SelectItemsManager.convCodeDisp(mainTsvMaster, selectedItemsCode) {
            print(item.debugDisp)
        }
//        self.dismiss(animated: true) { }
    }
    func actPopupCancel() {
        self.dismiss(animated: true) { }
    }
}

extension SubSelectBaseVC: UITableViewDataSource, UITableViewDelegate {
    //=== 通常テーブル
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = arrData[indexPath.row]
        let cell: SubSelectTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_SubSelectTBCell", for: indexPath) as! SubSelectTBCell
        //選択状態があるかチェックして反映させる
        let vals = self.selectCodes.split(separator: "_") //選択状態をバラす
        let select0: Bool = vals.contains { (val) -> Bool in val == item.code }//item.valに選択されているもの配列が付いているので、そこにあるかチェック
        let select: Bool = dicChange[item.code] ?? select0  //差分情報優先
//        let select2: Bool = dicChange[item.code] ?? false
//        if select0 != select {
//            print("[sel0: \(select0)]  [tempSel: \(select2)] => [\(select)]")
//        }
        cell.initCell(self, item, select)
        cell.dispCell()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        let item = arrData[indexPath.row]
        if (singleMode) { //=== Single
            dicChange.removeAll() //Single選択の場合は、まるっと削除してから追加
        }
        let vals = self.selectCodes.split(separator: "_") //選択状態をバラす
        let select0: Bool = vals.contains { (val) -> Bool in val == item.code }//item.valに選択されているもの配列が付いているので、そこにあるかチェック
        let select: Bool = dicChange[item.code] ?? select0  //差分情報優先
        dicChange[item.code] = !select
        //該当セルの描画しなおし
        if (singleMode) { //=== Single
            tableView.reloadData()
            actPopupSelect(selectedItemsCode: item.code)//選択したもの即時反映の場合
        } else {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension SubSelectBaseVC: SubSelectProtocol {
}
