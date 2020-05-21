//
//  EditableBasicVC+Picker.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

//=== 文字入力に伴うTextField関連の通知
extension EditableBasicVC {
    //=== 表示・非表示
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
        print("❤️❤️❤️❤️ Picker 消す ❤️❤️[\(textField.itemKey)]❤️❤️❤️❤️")
        textField.resignFirstResponder()//???
        textField.inputAccessoryView = nil //ここで、関連つけていたToolbarを殺す
        textField.inputView = nil //ここで、関連つけていたPickerを殺す
    }

    //ピッカーにつけた〔選択〕〔Cancel〕ボタン
    @objc func actPickerSelectButton(_ sender: IKBarButtonItem) {
        guard let picker = sender.parentPicker as? IKPickerView else { return }
        self.view.endEditing(true)
    }
    @objc func actPickerCancelButton(_ sender: IKBarButtonItem) {
        self.view.endEditing(true)
    }

}


//################################################################################
extension EditableBasicVC: UIPickerViewDataSource, UIPickerViewDelegate {
    enum PickerType: Int {
        case select = 0
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let pickerView = pickerView as? IKPickerView else { return 0 }
        //guard let editableModel = editableModel else { return 0 }
        let selectionItems = editableModel.makePickerItems(itemKey: pickerView.itemKey)
        guard selectionItems.count > 0 else { return 0 } //選択肢マスタがなければドラムも表示しないため0
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let pickerView = pickerView as? IKPickerView else { return 0 }
        //guard let editableModel = editableModel else { return 0 }
        let selectionItems = editableModel.makePickerItems(itemKey: pickerView.itemKey)
        return selectionItems.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard let pickerView = pickerView as? IKPickerView else { return UIView() }
        //guard let editableModel = editableModel else { return UIView() }
        let selectionItems = editableModel.makePickerItems(itemKey: pickerView.itemKey)
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
        guard let pickerView = pickerView as? IKPickerView else { return }
        //guard let editableModel = editableModel else { return }
        let selectionItems = editableModel.makePickerItems(itemKey: pickerView.itemKey)
        guard selectionItems.count > row else { return }//マスタ配列が取得できていない
        let item = selectionItems[row]
        
        //!!! フィードバックするためにTextFieldが知りたい
        guard let parentTF = pickerView.parentTF as? IKTextField else { return }
        parentTF.text = item.disp
    }
}

