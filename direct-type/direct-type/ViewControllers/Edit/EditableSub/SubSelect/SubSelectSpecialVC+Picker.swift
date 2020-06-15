//
//  SubSelectSpecialVC+Picker.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/20.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit



//################################################################################


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
//        tfSubDummy.inputAccessoryView?.backgroundColor = .green

    }
    func hidePicker(_ textField: IKTextField) {
        //print("❤️❤️ Picker 消す [\(textField.itemKey)]")
        textField.inputAccessoryView = nil //ここで、関連つけていたToolbarを殺す
        textField.inputView = nil //ここで、関連つけていたPickerを殺す
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
        if Constants.DbgDispStatus { lbl.text = item.debugDisp } //[Dbg: コードも表示しておく]
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
        //let item = selectionItems[row]
    }
}


extension SubSelectSpecialVC {
    //ピッカーにつけた〔選択〕〔Cancel〕ボタン
    @objc func actPickerSelectButton(_ sender: IKBarButtonItem) {
        guard let picker = sender.parentPicker as? IKPickerView else { return }
        //print("❤️[\(picker.itemKey)]❤️ ピッカー〔選択〕ボタン押下❤️")
        let selectionItems = arrSubData
        guard selectionItems.count > 0 else { return }//そもそも項目がない（依存関係ありの時など）
        let num = picker.selectedRow(inComponent: 0)
        guard selectionItems.count > num else { return }//マスタ配列が取得できていない
        let _selectedItem = selectionItems[num]//現時点での選択肢一覧から、実際に選択されたものを取得
        //選択されたものに変更があったか調べる。依存関係がある場合には、関連する項目の値をリセット（未選択：""）にする
        if let (selItemKey, selIdxPath) = curSubItem {
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
        //print("❤️[\(picker.itemKey)]❤️ ピッカー〔キャンセル〕ボタン押下❤️")
        //=== キャンセルされたら、次のセルへ移動せず閉じる
        self.view.endEditing(false) //forceフラグはどこに効いてくるのか？
    }
}
