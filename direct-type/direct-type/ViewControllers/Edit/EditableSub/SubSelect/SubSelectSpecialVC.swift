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

    @IBOutlet weak var vwHead: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfSubDummy: IKTextField!
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
        for (k, v) in dicSelectedCode {
            if selectYearMode {
                arrResult.append("\(k):\(v.code)")
            } else {
                arrResult.append("\(k)")
            }
        }
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
        //=== テーブル初期化
        self.tableVW.estimatedRowHeight = 60
        self.tableVW.rowHeight = UITableView.automaticDimension
        self.tableVW.register(UINib(nibName: "SubSelectDaiTBCell", bundle: nil), forCellReuseIdentifier: "Cell_SubSelectDaiTBCell")
        self.tableVW.register(UINib(nibName: "SubSelectSyouTBCell", bundle: nil), forCellReuseIdentifier: "Cell_SubSelectSyouTBCell")
    }
    func initData(_ delegate: SubSelectFeedbackDelegate, editableItem: EditableItemH, selectingCodes: String) {
        print(#line, #function, "\t💜初期化💜[selectingCodes: \(selectingCodes)]💜\(editableItem.editableItemKey)")
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
        case .skill:    self.subTsvMaster = .skillYear
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
        for itemDai in dai {
            var hoge: [CodeDisp] = []
            hoge.append(itemDai)
            hoge = hoge + syou.filter { (item) -> Bool in
                item.grp == itemDai.code
            }.map { (item) -> CodeDisp in
                item.codeDisp
            }
            //=== 選択されてるのが含まれたら、それは展開しておく場合：
            var isOpen: Bool = false
            for item in hoge {
                if dicSelectedCode.keys.contains(item.code) { isOpen = true }
            }
            arrDataGrp.append(hoge)
            arrSelected.append(isOpen)//該当セクションが展開されているか否か
        }
    }
    func dispData() {
//        let bufTitle: String = "\(editableItem.dispName) \(dicSelectedCode.count)件選択"
        let bufTitle: String = "\(editableItem.dispName)"
        lblTitle.text(text: bufTitle, fontType: .font_L, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
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
            cell.initCell(self, item, select)
            cell.dispCell()
            return cell
        } else {
            let cell: SubSelectSyouTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_SubSelectSyouTBCell", for: indexPath) as! SubSelectSyouTBCell
            //選択状態があるかチェックして反映させる
            cell.initCell(self, item, dicSelectedCode[item.code])
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
                dicSelectedCode.removeValue(forKey: item.code)//削除する
                tableView.reloadRows(at: [indexPath], with: .none) //該当セルの描画しなおし
                dispData()
            } else { //選択されてない
                //選択数の最大を超えるかのチェック
                if dicSelectedCode.count >= selectMaxCount {
                    showConfirm(title: "", message: "合計\(selectMaxCount)個までしか選択できません", onlyOK: true)
                    return
                }
                if selectYearMode {//年数選択が必要か、そのまま選択可能か
                    tfSubDummy.text = item.code
                    curSubItem = (item.code, indexPath)
                    tfSubDummy.becomeFirstResponder()//ダミーを使ってPicker制御
                    showPicker(tfSubDummy)
                } else {
                    dicSelectedCode[item.code] = item
                    tableView.reloadRows(at: [indexPath], with: .none) //該当セルの描画しなおし
                    dispData()
                    selectAndCloseIfSingle()//===選択と同時に閉じて良いかのチェック
                }
            }
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
//        //___選択状態の確認
//        print("\t🐼1🐼[\(selectedItemsCode)]🐼これが選択されました🐼Special🐼")//編集中の値の保持（と描画）
//        if selectYearMode {
//            for item in SelectItemsManager.convCodeDisp(mainTsvMaster, subTsvMaster, selectedItemsCode) {
//                print(#line, "\t🐼1a🐼\t", item.0.debugDisp, item.1.debugDisp)
//            }
//        } else {
//            for item in SelectItemsManager.convCodeDisp(mainTsvMaster, selectedItemsCode) {
//                print(#line, "\t🐼1b🐼\t", item.debugDisp)
//            }
//        }
//        //^^^選択状態の確認
        self.delegate?.changedSelect(editItem: self.editableItem, codes: selectedItemsCode) //フィードバックしておく
        self.dismiss(animated: true) { }
    }
    func actPopupCancel() {
        self.dismiss(animated: true) { }
    }
}
