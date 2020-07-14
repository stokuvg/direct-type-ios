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
    //先頭項目に排他選択肢をつけて利用するか
    var exclusiveSelectMode: Bool = false
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

    @IBOutlet weak var vwInfoArea: UIView!
    @IBOutlet weak var stackInfo: UIStackView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var vwInfoCountArea: UIView!
    @IBOutlet weak var lblInfoText: UILabel!
    @IBOutlet weak var vwInfoTextArea: UIView!
    var subSelectEnable: SubSelectEnableVW? = nil //stackInfoに場合によって付け足すもの

    @IBOutlet weak var vwSelectEnableArea: UIView!
    @IBOutlet weak var lblSelectEnableTitle: UILabel!
    @IBOutlet weak var btnSelectEnable: UILabel!

    @IBOutlet weak var vwMain: UIView!
    @IBOutlet private weak var tableVW: UITableView!
    @IBOutlet weak var lcMainFootSpace: NSLayoutConstraint!

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
    
    var cellHeight: CGFloat {
        return 70
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //====デザイン適用
        view.backgroundColor = UIColor(colorType: .color_base)!
        let colHead = UIColor.black //UIColor(colorType: .color_main)!
        vwHead.backgroundColor = colHead
        vwInfoArea.backgroundColor = colHead
        vwInfoTextArea.backgroundColor = colHead
        vwInfoCountArea.backgroundColor = colHead
        
        vwMain.backgroundColor = UIColor(colorType: .color_base)!
        vwFoot.backgroundColor = UIColor(colorType: .color_base)!
        tableVW.backgroundColor = UIColor(colorType: .color_base)!
        btnCommit.setTitle(text: "この内容で保存", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
        tableVW.register(UINib(nibName: "SubSelectTBCell", bundle: nil), forCellReuseIdentifier: "SubSelectTBCell")
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
        case EditItemMdlFirstInput.hopeArea.itemKey: fallthrough
        case EditItemMdlProfile.hopeJobArea.itemKey: fallthrough
        case EditItemMdlEntry.hopeArea.itemKey:
            selectMaxCount = 5
        case EditItemMdlResume.qualifications.itemKey:
            selectMaxCount = Constants.SelectMultidMaxUndefine //選択上限なし？
        default:
            selectMaxCount = 1
        }
        self.arrData.removeAll()
        //選択肢一覧を取得する（グループタイプはSpecialを利用するため来ない想定ではある）
        let cd: [CodeDisp] = SelectItemsManager.getMaster(self.mainTsvMaster)
        let (grp, _): ([CodeDisp], [GrpCodeDisp]) = SelectItemsManager.getMaster(self.mainTsvMaster)
        //print("[cd: \(cd.count)] / [grp: \(grp.count)] [gcd: \(gcd.count)] ")
        self.arrData = (grp.count != 0) ? grp : cd
        //=== 希望勤務地の場合の得例：先頭に「勤務地にはこだわらない」を付与し、排他選択を実施する
        switch editableItem.editableItemKey {
        case EditItemMdlFirstInput.hopeArea.itemKey: fallthrough
        case EditItemMdlProfile.hopeJobArea.itemKey: fallthrough
        case EditItemMdlEntry.hopeArea.itemKey:
            exclusiveSelectMode = true
            arrData.insert(Constants.ExclusiveSelectCodeDisp, at: 0)
        default:
            exclusiveSelectMode = false
            break
        }
        //=== IndexPathなどを設定するため
        editableModel.initItemEditable([editableItem])//単独だけど共通化のため
    }
    func dispData() {
        let bufTitle: String = "\(editableItem.dispName)"
        lblTitle.text(text: bufTitle, fontType: .font_M, textColor: UIColor(colorType: .color_white)!, alignment: .center)
        vwInfoTextArea.isHidden = true
        vwInfoCountArea.isHidden = true
//        //ヘッダ下部の補足情報エリア
//        let bufInfoText = editableItem.placeholder
//        lblInfoText.text(text: bufInfoText, fontType: .font_S, textColor: UIColor.init(colorType: .color_white)!, alignment: .left)
        dispInfoCount()
    }
    func dispInfoCount() {
//        var bufCount = ""
//        if selectMaxCount > 1 {
//            let count = self.dicChange.filter { (k, v) -> Bool in v == true }.count
//            bufCount = "\(count)/\(selectMaxCount)"
//        }
//        lblCount.text(text: bufCount, fontType: .font_SSS, textColor: UIColor.init(colorType: .color_white)!, alignment: .right)
        //=== 合わせて表示させる
        switch editableItem.editType {
        case .inputMemo:
            vwInfoTextArea.isHidden = false
            let bufInfoText = editableItem.placeholder
            lblInfoText.text(text: "\(bufInfoText)", fontType: .font_S, textColor: UIColor.init(colorType: .color_white)!, alignment: .left)
        case .selectMulti, .selectSpecial, .selectSpecialYear:
            vwInfoTextArea.isHidden = false
            let bufInfoText = editableItem.placeholder
            var bufCount = ""
            if selectMaxCount > 1 {
                //let count = self.dicChange.filter { (k, v) -> Bool in v == true }.count
                let count = self.dicChange.filter { (k, v) -> Bool in
                    v == true && k != Constants.ExclusiveSelectCodeDisp.code
                }.count
                if selectMaxCount == Constants.SelectMultidMaxUndefine {
                    bufCount = " (\(count))"
                } else {
                    bufCount = " (\(count)/\(selectMaxCount))"
                }
            }
            lblInfoText.text(text: "\(bufInfoText)\(bufCount)", fontType: .font_S, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        default:
            vwInfoTextArea.isHidden = true
        }

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
        let cell: SubSelectTBCell = tableView.dequeueReusableCell(withIdentifier: "SubSelectTBCell") as! SubSelectTBCell
        //選択状態があるかチェックして反映させる
        let select: Bool = dicChange[item.code] ?? false  //差分情報優先
        let exclusive: Bool = exclusiveSelectMode && dicChange.contains { (k,v) -> Bool in v == true && k == Constants.ExclusiveSelectCodeDisp.code }
        cell.initCell(self, item, select, exclusive)
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
        //===排他的選択モード「勤務地にはこだわらない」を選んだ場合の特殊処理
        if exclusiveSelectMode {
            if item.code == Constants.ExclusiveSelectCodeDisp.code {
                if select {
                   //特になにもしない（後続処理で、普通に解除される）
                } else {
                    dicChange.removeAll()//まるっと選択解除
                    dicChange[Constants.ExclusiveSelectCodeDisp.code] = true//この項目のみ選択状態
                    dispInfoCount()
                }
            }
        }
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
        dispInfoCount()
        //該当セルの描画しなおし
        if (singleMode) { //=== Single
            tableView.reloadData()
            actPopupSelect(selectedItemsCode: item.code)//選択したもの即時反映の場合
        } else {
            if exclusiveSelectMode {
                tableView.reloadData()//まるっと全部を表示更新しないとダメです
            } else {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}



extension SubSelectBaseVC: SubSelectProtocol {
}

extension SubSelectBaseVC: SubSelectEnableDelegate {
    func actSelectChange(isEnable: Bool) {
        print("\t[isEnable: \(isEnable)]")
    }
}
