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
//    var typeDai: SelectItemsManager.TsvMaster!
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
                tfSubDummy.text = item.code
                curSubItem = (item.code, indexPath)
                tfSubDummy.becomeFirstResponder()//ダミーを使ってPicker制御
                showPicker(tfSubDummy)
            }
        }
    }
    //ピッカーにつけた〔選択〕〔Cancel〕ボタン
    @objc func actPickerSelectButton(_ sender: IKBarButtonItem) {
        guard let picker = sender.parentPicker as? IKPickerView else { return }
        print("❤️[\(picker.itemKey)]❤️ ピッカー〔選択〕ボタン押下❤️")
        let selectionItems = arrSubData
        guard selectionItems.count > 0 else { return }//そもそも項目がない（依存関係ありの時など）
        let num = picker.selectedRow(inComponent: 0)
        guard selectionItems.count > num else { return }//マスタ配列が取得できていない
        let _selectedItem = selectionItems[num]//現時点での選択肢一覧から、実際に選択されたものを取得
        //選択されたものに変更があったか調べる。依存関係がある場合には、関連する項目の値をリセット（未選択：""）にする
        if let (selItemKey, selIdxPath) = curSubItem {
            //print(_selectedItem.debugDisp, "せんたくされたよ！", selItemKey, selIdxPath.description, _selectedItem.debugDisp)
            dicSelectedCode[selItemKey] = _selectedItem
            if _selectedItem.code == "" { //未選択コードは選択しない（仮）
                dicSelectedCode.removeValue(forKey: selItemKey)
            }
            tableVW.reloadRows(at: [selIdxPath], with: .none) //該当セルの描画しなおし
            dispData()
        }
        self.view.endEditing(false) //forceフラグはどこに効いてくるのか？
    }
    @objc func actPickerCancelButton(_ sender: IKBarButtonItem) {
        guard let picker = sender.parentPicker as? IKPickerView else { return }
        print("❤️[\(picker.itemKey)]❤️ ピッカー〔キャンセル〕ボタン押下❤️")
        //=== キャンセルされたら、次のセルへ移動せず閉じる
        self.view.endEditing(false) //forceフラグはどこに効いてくるのか？
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








//Pickerで経験年数(MstK5)を表示させるので...
extension SubSelectSpecialVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard arrSubData.count > 0 else { return 0 } //選択肢マスタがなければドラムも表示しないため0
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrSubData.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let selectionItems = arrSubData
        guard selectionItems.count > row else { return UIView() }//マスタ配列が取得できていない
        let item = selectionItems[row]
        let lbl = UILabel.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: pickerView.bounds.size.width - 20, height: 30)))
        lbl.font = UIFont.systemFont(ofSize: 30)
        lbl.text = item.disp
        lbl.textAlignment = NSTextAlignment.center
        lbl.adjustsFontSizeToFitWidth = true //フォント縮小での自動リサイズ
        lbl.minimumScaleFactor = 0.5 //フォント縮小での自動リサイズ
        return lbl
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectionItems = arrSubData
        guard selectionItems.count > row else { return }//マスタ配列が取得できていない
        let item = selectionItems[row]
    }
}
//セルでのテキスト入力の変更

//=== 文字入力に伴うTextField関連の通知
extension SubSelectSpecialVC {
    @IBAction func actEditingDidBegin(_ sender: IKTextField) {
        showPicker(tfSubDummy)
    }
    @IBAction func actEditingDidEnd(_ sender: IKTextField) {
        hidePicker(tfSubDummy)
    }
    //=== 表示・非表示
    func showPicker(_ textField: IKTextField) {
        //親子の依存関係がある場合に、親が選択済か調べる。未選択の場合には子は選択できない
        //print("❤️❤️ Picker 表示 [\(textField.itemKey)] [\(textField.inputView)] [\(textField.inputAccessoryView)]")
        //Pickerを表示する
        let picker = IKPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.itemKey = textField.itemKey
        picker.parentTF = textField
        textField.inputView = picker //
        //Pickerにボタンをつけておく（Pickerにというか、inputViewに対して付くため、Softwareキーボードなければ最下部に、あればその上につく
        let rect = CGRect(origin: CGPoint.zero, size: CGSize.init(width: 260, height: 45))
        let toolbar = UIToolbar(frame: rect)//Autolayout補正かかるけど、そこそこの横幅指定が必要
        let lbl = UILabel(frame: rect)
        lbl.textAlignment = .center
        lbl.text = "経験年数を選択してください"
        let separator1 = IKBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barLbl = IKBarButtonItem.init(customView: lbl)
        let separator2 = IKBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnClose = IKBarButtonItem.init(title: "閉じる", style: .done, target: self, action: #selector(actPickerCancelButton))
        let btnSelect = IKBarButtonItem.init(title: "選択", style: .done, target: self, action: #selector(actPickerSelectButton))
        //=== itemKeyをつけておく
        btnSelect.parentPicker = picker
        btnClose.parentPicker = picker
        toolbar.setItems([btnClose, separator1, barLbl, separator2, btnSelect], animated: true)
        tfSubDummy.inputAccessoryView = toolbar
        tfSubDummy.inputAccessoryView?.backgroundColor = .green

    }
    func hidePicker(_ textField: IKTextField) {
        //print("❤️❤️ Picker 消す [\(textField.itemKey)]")
        textField.inputAccessoryView = nil //ここで、関連つけていたToolbarを殺す
        textField.inputView = nil //ここで、関連つけていたPickerを殺す
    }
}

