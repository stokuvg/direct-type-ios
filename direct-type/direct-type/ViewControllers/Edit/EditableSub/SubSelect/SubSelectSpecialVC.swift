//
//  SubSelectSpecialVC.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/04/23.
//  Copyright © 2020 ms-mb014. All rights reserved.
//
//Mst5_経験年数がサブ選択。

import UIKit

protocol SubSelectSpecialDelegate {
    func actPopupSelect(selectedItemsCode: String)
    func actPopupCancel()
}

class SubSelectSpecialVC: BaseVC {
    var delegate: SubSelectFeedbackDelegate? = nil
    var arrCannotSelectCodes: [Code] = []//Validation的に選択不可能なコード(最近・その他での重複指定を避けるため)
    //年数選択が必要か、即選択できるか
    var selectYearMode: Bool = false
    //選択数のMAX（1つなら即確定して前画面の可能性も？）
    var selectMaxCount: Int = 5
    
    var editableItem: EditableItemH!
    var arrDataGrp: [[CodeDisp]] = []
    var arrSelected: [Bool] = []
    var mainTsvMaster: SelectItemsManager.TsvMaster = .undefine

    //サブ選択用
    var subTsvMaster: SelectItemsManager.TsvMaster = .undefine
    var curSubItem: (String, IndexPath)? = nil
    var arrSubData: [CodeDisp] = []
    var dicSelectedCode: [String: CodeDisp] = [:]//小分類コードに対応する経験年数のCodeDispを設定する
    var cellFocus: IndexPath? = nil //サブ選択中の仮選択表示用
    //大項目内の選択状況の把握用
    //GrpコードではなくセクションNo.をキーとし、そこに含まれる子項目のCode配列で管理とする
    var dicSelItemCode: [Int: [Code]] = [:]

    @IBOutlet weak var vwHead: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfSubDummy: IKTextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func actBack(_ sender: UIButton) {
        actPopupCancel()
    }

    @IBOutlet weak var vwInfoArea: UIView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var vwInfoCountArea: UIView!
    @IBOutlet weak var lblInfoText: UILabel!
    @IBOutlet weak var vwInfoTextArea: UIView!
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var tableVW: UITableView!
    
    @IBOutlet weak var vwFoot: UIView!
    @IBOutlet weak var lcFootHeight: NSLayoutConstraint!
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        var arrResult: [String] = []
        for (k, v) in dicSelectedCode {
            if selectYearMode {
                arrResult.append("\(k):\(v.code)")
            } else {
                arrResult.append("\(k)")
            }
        }
        let bufResult: String = arrResult.joined(separator: EditItemTool.JoinMultiCodeSeparator)
        
        
        actPopupSelect(selectedItemsCode: bufResult)
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
        btnCommit.setTitle(text: "この内容で保存", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
        //=== テーブル初期化
        self.tableVW.estimatedRowHeight = 60
        self.tableVW.rowHeight = UITableView.automaticDimension
        self.tableVW.register(UINib(nibName: "SubSelectDaiTBCell", bundle: nil), forCellReuseIdentifier: "Cell_SubSelectDaiTBCell")
        self.tableVW.register(UINib(nibName: "SubSelectSyouTBCell", bundle: nil), forCellReuseIdentifier: "Cell_SubSelectSyouTBCell")
    }
    func initData(_ delegate: SubSelectFeedbackDelegate, editableItem: EditableItemH, selectingCodes: String, _ cannotSelectCodes: [String]) {
        self.arrCannotSelectCodes = cannotSelectCodes
        //=== 2段回目の年数選択を実施するか
        self.delegate = delegate
        switch editableItem.editType {
        case .selectSpecial:        selectYearMode = false
        case .selectSpecialYear:    selectYearMode = true
        default:                    selectYearMode = false
        }
        //=== 選択数の最大数を項目定義に応じて設定する
        switch editableItem.editableItemKey {
        case EditItemMdlResumeLastJobExperiment.jobTypeAndJobExperimentYear.itemKey: fallthrough
        case EditItemMdlFirstInputLastJobExperiments.jobTypeAndJobExperimentYear.itemKey:
            selectMaxCount = 1
        case EditItemMdlResumeJobExperiments.jobTypeAndJobExperimentYear.itemKey: fallthrough
        case EditItemMdlFirstInputJobExperiments.jobTypeAndJobExperimentYear.itemKey:
            selectMaxCount = 9 //10-1 最新と合わせて10件。Validationメッセージがキモくなる...
        default: selectMaxCount = 10
        }
        //=== 使用するマスタを設定する
        self.editableItem = editableItem
        self.mainTsvMaster = editableItem.editItem.tsvMaster //メインは指定されている
        switch editableItem.editItem.tsvMaster { //サブ（2段回目)は、メインにしたがって定義される
        case .jobType:  self.subTsvMaster = .jobExperimentYear
        default:        self.subTsvMaster = .undefine
        }
        //=== 遷移時点での選択情報をばらして保持する
        if selectYearMode {
            for item in selectingCodes.split(separator: "_") {
                let buf = String(item).split(separator: ":")
                guard buf.count == 2 else { continue }
                let tmp0 = String(buf[0])
                let tmp1 = String(buf[1])
                let buf1: String = SelectItemsManager.getCodeDisp(subTsvMaster, code: tmp1)?.disp ?? ""
                dicSelectedCode[tmp0] = CodeDisp(tmp1, buf1)
            }
        } else {
            for item in selectingCodes.split(separator: "_") {
                let tmp = String(item)
                let buf: String = SelectItemsManager.getCodeDisp(mainTsvMaster, code: tmp)?.disp ?? ""
                dicSelectedCode[tmp] = CodeDisp(tmp, buf)
            }
        }
        //=== 表示アイテムを設定する
        self.arrSubData = SelectItemsManager.getMaster(self.subTsvMaster)
        let (dai, syou): ([CodeDisp], [GrpCodeDisp]) = SelectItemsManager.getMaster(self.mainTsvMaster)
        for (sec, itemDai) in dai.enumerated() {
            var hoge: [CodeDisp] = []
            hoge.append(itemDai)
            hoge = hoge + syou.filter { (item) -> Bool in
                item.grp == itemDai.code
            }.map { (item) -> CodeDisp in
                item.codeDisp
            }
            //=== 選択されてるのが含まれたら、それは展開しておく場合：
            var isOpen: Bool = false
            for (n, item) in hoge.enumerated() {
                if dicSelectedCode.keys.contains(item.code) {
                    isOpen = true
                    //===大分類に含まれている子項目の状態を変更（初期）
                    if var arr = dicSelItemCode[sec] {
                        arr.append(item.code)
                        dicSelItemCode[sec] = arr
                    } else {
                        dicSelItemCode[sec] = [item.code]
                    }
                }
            }
            arrDataGrp.append(hoge)
            arrSelected.append(isOpen)//該当セクションが展開されているか否か
        }
    }
    func dispData() {
        let bufTitle: String = "\(editableItem.dispName)"
        lblTitle.text(text: bufTitle, fontType: .font_L, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        vwInfoTextArea.isHidden = true
        vwInfoCountArea.isHidden = true
        if selectMaxCount == 1 {
            lcFootHeight.constant = 0 //選択即反映にするため、下部尾選択ボタンも非表示とする
        }
//        //ヘッダ下部の補足情報エリア
//        let bufInfoText = editableItem.placeholder
//        lblInfoText.text(text: bufInfoText, fontType: .font_S, textColor: UIColor.init(colorType: .color_white)!, alignment: .left)
        dispInfoCount()
    }
    func dispInfoCount() {
//        var bufCount = ""
//        if selectMaxCount > 1 {
//            let count = dicSelectedCode.count
//            bufCount = "\(count)/\(selectMaxCount)"
//        }
//        lblCount.text(text: bufCount, fontType: .font_SSS, textColor: UIColor.init(colorType: .color_white)!, alignment: .right)
        //=== 合わせて表示させる
        switch editableItem.editType {
        case .selectMulti, .selectSpecial, .selectSpecialYear:
            vwInfoTextArea.isHidden = false
            let bufInfoText = editableItem.placeholder
            var bufCount = ""
            if selectMaxCount > 1 {
                let count = dicSelectedCode.count
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
        //大項目内の選択フィードバックのため
        tableVW.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispData()
    }
}

extension SubSelectSpecialVC: UITableViewDataSource, UITableViewDelegate {
    //=== 通常テーブル
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrDataGrp.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard arrSelected.count > 0 else { return 0 }
        //セクションの最初は大分類、2つ目以降はそれに含まれる小分類とするので
        let select: Bool = arrSelected[section]
        if select {
            return arrDataGrp[section].count
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = arrDataGrp[indexPath.section][indexPath.row]
        
        //セクションの最初は大分類、2つ目以降はそれに含まれる小分類とするので
        if indexPath.row == 0 {
            let cell: SubSelectDaiTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_SubSelectDaiTBCell", for: indexPath) as! SubSelectDaiTBCell
            let select: Bool = arrSelected[indexPath.section]
            let arr: [Code] = dicSelItemCode[indexPath.section] ?? []
            cell.initCell(self, item, select, arr)
            cell.dispCell()
            return cell
        } else {
            let cell: SubSelectSyouTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_SubSelectSyouTBCell", for: indexPath) as! SubSelectSyouTBCell
            let isFocus: Bool = (indexPath == cellFocus) //選択状態があるかチェックして反映させる
            let isDisable: Bool = arrCannotSelectCodes.contains(item.code) //関連画面での指定済コードなら指定不可にする
            cell.initCell(self, item, dicSelectedCode[item.code], isFocus, isDisable, selectYearMode)
            cell.dispCell()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        let item = arrDataGrp[indexPath.section][indexPath.row]
        //セクションの最初は大分類、2つ目以降はそれに含まれる小分類とするので
        if indexPath.row == 0 {
            let select: Bool = arrSelected[indexPath.section]
            arrSelected[indexPath.section] = !select
            tableView.reloadData() //該当セルの描画しなおし
        } else {
            //そのセルの選択状態に応じて、経験年数を入れさせるか、解錠するかを選ぶ
            if let _ = dicSelectedCode[item.code] {
                changeFocusItem(nil)//仮選択して、該当セルの描画しなおし
                cellFocus = nil //選択解除
                dicSelectedCode.removeValue(forKey: item.code)//削除する
                //===大分類に含まれている子項目の状態を変更（削除）
                if var arr = dicSelItemCode[indexPath.section] {
                    arr.removeAll { (code) -> Bool in
                        code == item.code
                    }
                    dicSelItemCode[indexPath.section] = arr
                }
                tableView.reloadRows(at: [indexPath], with: .none) //該当セルの描画しなおし
                dispData()
            } else { //選択されてない
                //選択数の最大を超えるかのチェック
                if dicSelectedCode.count >= selectMaxCount {
                    showConfirm(title: "", message: "合計\(selectMaxCount)個までしか選択できません", onlyOK: true)
                    return
                }
                if selectYearMode {//年数選択が必要か、そのまま選択可能か
                    changeFocusItem(indexPath)//仮選択して、該当セルの描画しなおし
                    tfSubDummy.text = item.code
                    curSubItem = (item.code, indexPath)
                    tfSubDummy.becomeFirstResponder()//ダミーを使ってPicker制御
                    showPicker(tfSubDummy)
                } else {
                    dicSelectedCode[item.code] = item
                    //===大分類に含まれている子項目の状態を変更（追加）
                    if var arr = dicSelItemCode[indexPath.section] {
                        arr.append(item.code)
                        dicSelItemCode[indexPath.section] = arr
                    } else {
                        dicSelItemCode[indexPath.section] = [item.code]
                    }
                    tableView.reloadRows(at: [indexPath], with: .none) //該当セルの描画しなおし
                    dispData()
                    selectAndCloseIfSingle()//===選択と同時に閉じて良いかのチェック
                }
            }
        }
    }
    func changeFocusItem(_ indexPath: IndexPath?) { //仮選択時のフォーカ表示の切り替え
        if let ip = cellFocus { //古い箇所の描画更新
            cellFocus = indexPath
            //その大項目が閉じているときには対象がないので描画できずにクラッシュするのでチェックする
            let select: Bool = arrSelected[ip.section]
            if select {
                tableVW.reloadRows(at: [ip], with: .none) //該当セルの描画しなおし
            }
        } else {
            cellFocus = indexPath
        }
        if let ip = indexPath { //新しい箇所の描画更新
            tableVW.reloadRows(at: [ip], with: .none) //該当セルの描画しなおし
        }
    }
    func selectAndCloseIfSingle() {
        if selectMaxCount == 1 {
            actCommit(UIButton())
        }
    }
}
extension SubSelectSpecialVC: SubSelectProtocol {
    
}

//=== 複数選択ポップアップで選択させる場合の処理 ===
extension SubSelectSpecialVC: SubSelectBaseDelegate {
    func actPopupSelect(selectedItemsCode: String) {
        self.delegate?.changedSelect(editItem: self.editableItem, codes: selectedItemsCode) //フィードバックしておく
        self.dismiss(animated: true) { }
    }
    func actPopupCancel() {
        
        self.dismiss(animated: true) { }
    }
}
