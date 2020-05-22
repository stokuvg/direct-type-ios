//
//  EditableTableBasicVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class EditableTableBasicVC: EditableBasicVC {
    var item: MdlItemH? = nil
    var arrData: [EditableItemH] = []
    
    @IBOutlet weak var vwHead: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func actBack(_ sender: UIButton) {
        self.dismiss(animated: true) {}
    }
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var tableVW: UITableView!
    @IBOutlet weak var vwFoot: UIView!
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        self.dismiss(animated: true) {}
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //====デザイン適用
        vwHead.backgroundColor = UIColor.init(colorType: .color_main)!
        vwMain.backgroundColor = UIColor.init(colorType: .color_white)!
        vwFoot.backgroundColor = UIColor.init(colorType: .color_main)!
        btnCommit.setTitle(text: "この内容で保存", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
        //=== テーブル初期化
        self.tableVW.estimatedRowHeight = 100
        self.tableVW.rowHeight = UITableView.automaticDimension
        self.tableVW.register(UINib(nibName: "HEditTextTBCell", bundle: nil), forCellReuseIdentifier: "Cell_HEditTextTBCell")
        self.tableVW.register(UINib(nibName: "HEditDrumTBCell", bundle: nil), forCellReuseIdentifier: "Cell_HEditDrumTBCell")
        self.tableVW.register(UINib(nibName: "HEditZipcodeTBCell", bundle: nil), forCellReuseIdentifier: "Cell_HEditZipcodeTBCell")
    }
    func initData(_ item: MdlItemH) {
        self.item = item
        for child in item.childItems { arrData.append(child) }
        //=== IndexPathなどを設定するため
        editableModel.initItemEditable(arrData)
    }
    func dispData() {
        guard let _item = item else { return }
        lblTitle.text(text: _item.type.dispTitle, fontType: .font_L, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //=======================================================================================================
    //EditableBaseを元に、汎用テーブルIFを利用する場合のBaseクラス
    //=== OVerrideして使う
    //func moveNextCell(_ editableItemKey: String) -> Bool { return true } //次の項目へ移動
    //func dispEditableItemAll() {} //すべての項目を表示する
    //func dispEditableItemByKey(_ itemKey: EditableItemKey) {} //指定した項目を表示する （TODO：複数キーの一括指定に拡張予定）
    //=== 表示更新
    @objc override func dispEditableItemAll() {
        self.tableVW.reloadData()//項目の再描画
    }
    override func dispEditableItemByKey(_ itemKey: EditableItemKey) {
        self.tableVW.reloadData()//項目の再描画//!!!
        print(editableModel.dicTextFieldIndexPath.description)
        
        guard let curIdxPath = editableModel.dicTextFieldIndexPath[itemKey] else { return }
        print("🌸[\(#function)]🌸[\(editableModel)]🌸[\(itemKey)]🌸[\(curIdxPath)]")
        tableVW.reloadRows(at: [curIdxPath], with: UITableView.RowAnimation.automatic)
    }
    //=======================================================================================================

}

extension EditableTableBasicVC: UITableViewDataSource, UITableViewDelegate {
    //=== 通常テーブル
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _item = arrData[indexPath.row]
        let (isChange, editTemp) = editableModel.makeTempItem(_item)
        let item: EditableItemH! = isChange ? editTemp : _item
        switch item.editType {
        case .inputText:
            let cell: HEditTextTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditTextTBCell", for: indexPath) as! HEditTextTBCell
            cell.initCell(self, item)
            cell.dispCell()
            return cell
            
        case .inputZipcode:
            let cell: HEditZipcodeTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditZipcodeTBCell", for: indexPath) as! HEditZipcodeTBCell
            cell.initCell(item)
            cell.dispCell()
            return cell

        case .selectDrumYMD:
            let cell: HEditDrumTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditDrumTBCell", for: indexPath) as! HEditDrumTBCell
            cell.initCell(self, item)
            cell.dispCell()
            return cell

        default:
            print("🌸[\(#function)]🌸[\(#line)]🌸🌸")
            let cell: HEditTextTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditTextTBCell", for: indexPath) as! HEditTextTBCell
            cell.initCell(self, item)
            cell.dispCell()
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        if let cell = tableView.cellForRow(at: indexPath) as? HEditTextTBCell {
            cell.tfValue.becomeFirstResponder()
        }
    }
}



