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
    func changedSelect(editItem: EditableItemH, codes: String)
}
class SubSelectBaseVC: BaseVC {
    var delegate: SubSelectFeedbackDelegate? = nil
    var singleMode: Bool = true
    //選択数のMAX（1つなら即確定して前画面の可能性も？）
    var selectMaxCount: Int = 5
    var editableModel: EditableModel = EditableModel() //画面編集項目のモデルと管理//???

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
    @IBOutlet weak var lcFootHeight: NSLayoutConstraint!

    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        var arrResult: [String] = []
        let arr = dicChange.filter { (cb) -> Bool in cb.value }
        for item in arr { arrResult.append(item.key) }
        let bufResult: String = arrResult.joined(separator: EditItemTool.JoinMultiCodeSeparator)
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
        for key in selectingCodes.split(separator: "_") {
            self.dicChange[String(key)] = true
        }
        //=== 選択数の最大数を項目定義に応じて設定する
        switch editableItem.editableItemKey {
        case EditItemMdlFirstInput.hopeArea.itemKey:
            selectMaxCount = 5
        case EditItemMdlResume.qualifications.itemKey:
            selectMaxCount = 9999 //選択上限なし？
        default:
            selectMaxCount = 1
        }
        //選択肢一覧を取得する（グループタイプはSpecialを利用するため来ない想定ではある）
        let cd: [CodeDisp] = SelectItemsManager.getMaster(self.mainTsvMaster)
        let (grp, _): ([CodeDisp], [GrpCodeDisp]) = SelectItemsManager.getMaster(self.mainTsvMaster)
        //print("[cd: \(cd.count)] / [grp: \(grp.count)] [gcd: \(gcd.count)] ")
        self.arrData = (grp.count != 0) ? grp : cd
        //=== IndexPathなどを設定するため
        editableModel.initItemEditable([editableItem])//単独だけど共通化のため
    }
    func dispData() {
//        let bufTitle: String = "\(editableItem.dispName) \(arrData.count)件"
        let bufTitle: String = "\(editableItem.dispName)"
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
        self.delegate?.changedSelect(editItem: self.editableItem, codes: selectedItemsCode) //フィードバックしておく
        self.dismiss(animated: true) {}
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
        let select: Bool = dicChange[item.code] ?? false  //差分情報優先
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
        let select: Bool = dicChange[item.code] ?? false  //差分情報優先
        if select {
            //選択解除の時には最大チェックは不要
        } else {
            //選択数の最大を超えるかのチェック
            if dicChange.filter { (dic) -> Bool in
                dic.value == true
            }.count >= selectMaxCount {
                showConfirm(title: "", message: "合計\(selectMaxCount)個までしか選択できません", onlyOK: true)
                return
            }
        }
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
