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
    var editableItem: EditableItemH!
    var arrData: [CodeDisp] = []
    var dicChange: [String: Bool] = [:]  //CodeDisp.code : true

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
        var arr: [CodeDisp] = []
        let tsvMaster = editableItem.editItem.tsvMaster
        for (key, val) in dicChange {
            if let item: CodeDisp = SelectItemsManager.getCodeDisp(tsvMaster, code: key) {
                if val == true { arr.append(item) } //選択状態のもののみ追加
            }
        }
        //2段階のもの、Grpだと選択されないので
        for item in arr {
            print("\t⭐️\(item.debugDisp)⭐️")
        }
        if let selItem = arr.first {
            actPopupSelect(changeItem: selItem) //単一選択のため
        } else {
            actPopupSelect(changeItem: Constants.SelectItemsUndefine) //単一選択のため
        }
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
    func initData(editableItem: EditableItemH) {
        self.editableItem = editableItem
        let cd: [CodeDisp] = SelectItemsManager.getMaster(editableItem.editItem.tsvMaster)
        let (grp, gcd): ([CodeDisp], [GrpCodeDisp]) = SelectItemsManager.getMaster(editableItem.editItem.tsvMaster)
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

//=== 単一選択ポップアップで選択させる場合の処理 ===
extension SubSelectSingleVC: SubSelectSingleDelegate {
    func actPopupSelect(changeItem: CodeDisp) {
        self.dismiss(animated: true) { }
    }
    func actPopupCancel() {
        self.dismiss(animated: true) { }
    }
}


extension SubSelectSingleVC: SubSelectProtocol {
    
}
