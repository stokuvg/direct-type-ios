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
    func actPopupSelect(changeItems1: [CodeDisp], changeItems2: [CodeDisp])
    func actPopupCancel()
}

class SubSelectSpecialVC: BaseVC {
    let selectYearMode: Bool = false
    var editableItem: EditableItemH!
    var arrDataGrp: [[CodeDisp]] = []
    var arrSelected: [Bool] = []

    //サブ選択用
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
        actPopupSelect(changeItems1: [CodeDisp("2", "hogehoge1")], changeItems2: [CodeDisp("3", "hogehoge2")])
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
    func initData(editableItem: EditableItemH) {
        self.editableItem = editableItem
        self.arrSubData = SelectItemsManager.getMaster(.jobExperimentYear)
        //大項目の一覧のみ作成
        //guard let tsvMaster = SelectItemsManager.getTsvMasterByKey(editableItem.editableItemKey) else { return }
        //let dai = SelectItemsManager.getMaster(tsvMaster).0
        //let syou = SelectItemsManager.getMaster(tsvMaster).1
        let (dai, syou): ([CodeDisp], [GrpCodeDisp]) = SelectItemsManager.getMaster(editableItem.editItem.tsvMaster)
        for itemDai in dai {
            var hoge: [CodeDisp] = []
            hoge.append(itemDai)
            hoge = hoge + syou.filter { (item) -> Bool in
                item.grp == itemDai.code
            }.map { (item) -> CodeDisp in
                item.codeDisp
            }
            print(" * \(itemDai.debugDisp) - \(hoge.count)件")
            arrDataGrp.append(hoge)
            arrSelected.append(false)//該当セクションが展開されているか否か
        }
    }
    func dispData() {
        let bufTitle: String = "\(editableItem.dispName) \(dicSelectedCode.count)件選択"
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
            if let selITem = dicSelectedCode[item.code] {
                dicSelectedCode.removeValue(forKey: item.code)//削除する
                tableView.reloadRows(at: [indexPath], with: .none) //該当セルの描画しなおし
                dispData()
            } else { //選択されてない
                if selectYearMode {//年数選択が必要か、そのまま選択可能か
                    tfSubDummy.text = item.code
                    curSubItem = (item.code, indexPath)
                    tfSubDummy.becomeFirstResponder()//ダミーを使ってPicker制御
                    showPicker(tfSubDummy)
                } else {
                    dicSelectedCode[item.code] = item
                    tableView.reloadRows(at: [indexPath], with: .none) //該当セルの描画しなおし
                    dispData()
                }
            }
        }
    }
}
extension SubSelectSpecialVC: SubSelectProtocol {
    
}

//=== 複数選択ポップアップで選択させる場合の処理 ===
extension SubSelectSpecialVC: SubSelectSpecialDelegate {
    func actPopupSelect(changeItems1: [CodeDisp], changeItems2: [CodeDisp]) {
        print(changeItems1.debugDescription, changeItems2.debugDescription)//編集中の値の保持（と描画）
        self.dismiss(animated: true) { }
    }
    func actPopupCancel() {
        self.dismiss(animated: true) { }
    }
}

