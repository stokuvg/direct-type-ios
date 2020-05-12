//
//  ProfileEditVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class ProfileEditVC: TmpBasicVC {
    var item: MdlItemH? = nil
    var arrData: [EditableItemH] = [] //???EditableItemにする予定

    //編集中の情報
    var editableModel: EditableBase? //画面編集項目のモデルと管理
    
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
        //=== 編集アイテムの設定
        guard let _item = self.item else { return }
        for child in _item.childItems {
            arrData.append(child)
        }
    }
    func dispData() {
        guard let _item = item else { return }
        lblTitle.text(text: _item.type.dispTitle, fontType: .font_L, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispData()
    }

}


extension ProfileEditVC: UITableViewDataSource, UITableViewDelegate {
    //=== 通常テーブル
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = arrData[indexPath.row]
        
        switch item.editType {
        case .inputText:
            let cell: HEditTextTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditTextTBCell", for: indexPath) as! HEditTextTBCell
            cell.initCell(item)
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
            let cell: HEditTextTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditTextTBCell", for: indexPath) as! HEditTextTBCell
            cell.initCell(item)
            cell.dispCell()
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        let item = arrData[indexPath.row]
        print(item.debugDisp)
        
        if item.editType == .selectDrumYMD {
            print("年月日指定するドラム")
        }
        if let cell = tableView.cellForRow(at: indexPath) as? HEditTextTBCell {
            cell.tfValue.becomeFirstResponder()
        }
    }
}


//=== 文字入力に伴うTextField関連の通知
extension ProfileEditVC {
    //=== 表示・非表示
    func showPickerYMD(_ textField: IKTextField, _ item: EditableItemH) {
        print("❤️❤️ 日時変更Picker 表示 [\(textField.itemKey)] [\(item.debugDisp)]")
        //Pickerを表示する
        let picker = IKDatePicker()
        let bufDate = item.curVal
        let date = DateHelper.convStr2Date(bufDate)
        picker.date = date
        picker.datePickerMode = .date
        picker.calendar = date.calendarJP
        picker.locale = Locale(identifier: "ja_JP")
        picker.itemKey = textField.itemKey
        picker.parentTF = textField
        textField.inputView = picker //
        //Pickerにボタンをつけておく（Pickerにというか、inputViewに対して付くため、Softwareキーボードなければ最下部に、あればその上につく
        let rect = CGRect(origin: CGPoint.zero, size: CGSize.init(width: 260, height: 45))
        let toolbar = UIToolbar(frame: rect)//Autolayout補正かかるけど、そこそこの横幅指定が必要
        let lbl = UILabel(frame: rect)
        lbl.textAlignment = .center
        lbl.text = "\(item.dispName)を選択してください"
        let separator1 = IKBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barLbl = IKBarButtonItem.init(customView: lbl)
        let separator2 = IKBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnClose = IKBarButtonItem.init(title: "閉じる", style: .done, target: self, action: #selector(actDatePickerCancelButton))
        let btnSelect = IKBarButtonItem.init(title: "選択", style: .done, target: self, action: #selector(actDatePickerSelectButton))
        //=== itemKeyをつけておく
        btnSelect.parentPicker = picker
        btnClose.parentPicker = picker
        toolbar.setItems([btnClose, separator1, barLbl, separator2, btnSelect], animated: true)
        textField.inputAccessoryView = toolbar
        textField.inputAccessoryView?.backgroundColor = .green
    }
    
    func showPicker(_ textField: IKTextField, _ item: EditableItemH) {
        print("❤️❤️ Picker 表示 [\(textField.itemKey)] [\(item.debugDisp)]")
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
        lbl.text = "\(item.dispName)を選択してください"
        let separator1 = IKBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barLbl = IKBarButtonItem.init(customView: lbl)
        let separator2 = IKBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnClose = IKBarButtonItem.init(title: "閉じる", style: .done, target: self, action: #selector(actPickerCancelButton))
        let btnSelect = IKBarButtonItem.init(title: "選択", style: .done, target: self, action: #selector(actPickerSelectButton))
        //=== itemKeyをつけておく
        btnSelect.parentPicker = picker
        btnClose.parentPicker = picker
        toolbar.setItems([btnClose, separator1, barLbl, separator2, btnSelect], animated: true)
        textField.inputAccessoryView = toolbar
        textField.inputAccessoryView?.backgroundColor = .green
    }
    func hidePicker(_ textField: IKTextField) {
        print("❤️❤️ Picker 消す [\(textField.itemKey)]")
        textField.inputAccessoryView = nil //ここで、関連つけていたToolbarを殺す
        textField.inputView = nil //ここで、関連つけていたPickerを殺す
    }

    //ピッカーにつけた〔選択〕〔Cancel〕ボタン
    @objc func actDatePickerSelectButton(_ sender: IKBarButtonItem) {
        guard let picker = sender.parentPicker as? IKDatePicker else { return }
        picker.parentTF?.text = picker.date.dispYmdJP()
        //TODO: 値も反映したい
        self.view.endEditing(false)
    }
    @objc func actDatePickerCancelButton(_ sender: IKBarButtonItem) {
        guard let picker = sender.parentPicker as? IKDatePicker else { return }
        print("❤️[\(picker.itemKey)]❤️ 年月日ピッカー〔キャンセル〕ボタン押下❤️")
        self.view.endEditing(false)
    }

    //ピッカーにつけた〔選択〕〔Cancel〕ボタン
    @objc func actPickerSelectButton(_ sender: IKBarButtonItem) {
        guard let picker = sender.parentPicker as? IKPickerView else { return }
        print("❤️[\(picker.itemKey)]❤️ ピッカー〔選択〕ボタン押下❤️")
//        let selectionItems = arrSubData
//        guard selectionItems.count > 0 else { return }//そもそも項目がない（依存関係ありの時など）
//        let num = picker.selectedRow(inComponent: 0)
//        guard selectionItems.count > num else { return }//マスタ配列が取得できていない
//        let _selectedItem = selectionItems[num]//現時点での選択肢一覧から、実際に選択されたものを取得
//        //選択されたものに変更があったか調べる。依存関係がある場合には、関連する項目の値をリセット（未選択：""）にする
//        if let (selItemKey, selIdxPath) = curSubItem {
//            //print(_selectedItem.debugDisp, "せんたくされたよ！", selItemKey, selIdxPath.description, _selectedItem.debugDisp)
//            dicSelectedCode[selItemKey] = _selectedItem
//            if _selectedItem.code == "" { //未選択コードは選択しない（仮）
//                dicSelectedCode.removeValue(forKey: selItemKey)
//            }
//            tableVW.reloadRows(at: [selIdxPath], with: .none) //該当セルの描画しなおし
//            dispData()
//        }
        self.view.endEditing(false) //forceフラグはどこに効いてくるのか？
    }
    @objc func actPickerCancelButton(_ sender: IKBarButtonItem) {
        guard let picker = sender.parentPicker as? IKPickerView else { return }
        print("❤️[\(picker.itemKey)]❤️ ピッカー〔キャンセル〕ボタン押下❤️")
        //=== キャンセルされたら、次のセルへ移動せず閉じる
        self.view.endEditing(false) //forceフラグはどこに効いてくるのか？
    }

}


extension ProfileEditVC: UIPickerViewDataSource, UIPickerViewDelegate {
    enum PickerType: Int {
        case select = 0
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let pickerView = pickerView as? IKPickerView else { return 0 }
        guard let editableModel = editableModel else { return 0 }
        let selectionItems = editableModel.makePickerItems(itemKey: pickerView.itemKey)
        guard selectionItems.count > 0 else { return 0 } //選択肢マスタがなければドラムも表示しないため0
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let pickerView = pickerView as? IKPickerView else { return 0 }
        guard let editableModel = editableModel else { return 0 }
        let selectionItems = editableModel.makePickerItems(itemKey: pickerView.itemKey)
        return selectionItems.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard let pickerView = pickerView as? IKPickerView else { return UIView() }
        guard let editableModel = editableModel else { return UIView() }
        let selectionItems = editableModel.makePickerItems(itemKey: pickerView.itemKey)
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
        guard let pickerView = pickerView as? IKPickerView else { return }
        guard let editableModel = editableModel else { return }
        let selectionItems = editableModel.makePickerItems(itemKey: pickerView.itemKey)
        guard selectionItems.count > row else { return }//マスタ配列が取得できていない
        let item = selectionItems[row]
        
        //!!! フィードバックするためにTextFieldが知りたい
        guard let parentTF = pickerView.parentTF as? IKTextField else { return }
        parentTF.text = item.disp
    }
}



extension ProfileEditVC: InputItemHDelegate {
    func textFieldShouldReturn(_ tf: IKTextField, _ item: EditableItemH) -> Bool {
        print(#line, #function)
        return true
    }
    
    func textFieldShouldClear(_ tf: IKTextField, _ item: EditableItemH) -> Bool {
        print(#line, #function)
        return true
    }
    
    func editingDidBegin(_ tf: IKTextField, _ item: EditableItemH) {
        print(#line, #function)
//        actTargetInputTextBegin(tf, item) //元のTextFieldに被せるもの（なくて良い）
        //画面全体での初期状態での値と編集中の値を保持させておくため
//        guard let editableModel = editableModel else { return }
//        let (_, editTemp) = editableModel.makeTempItem(item)
        //=== タイプによって割り込み処理
        switch item.editType {
        case .selectDrum: //Pickerを生成する
            showPicker(tf, item)
        case .selectDrumYMD: //Pickerを生成する
            showPickerYMD(tf, item)
        default:
            break
        }
    }
    
    func editingDidEnd(_ tf: IKTextField, _ item: EditableItemH) {
        print(#line, #function)
    }
    
}

