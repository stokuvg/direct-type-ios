//
//  EditableBasicVC+PickerYMD.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

//=== 文字入力に伴うTextField関連の通知
extension EditableBasicVC {
    //=== 表示・非表示
    func showPickerYMD(_ textField: IKTextField, _ item: EditableItemH) {
        //親子の依存関係がある場合に、親が選択済か調べる。未選択の場合には子は選択できない
        //guard let editableModel = editableModel else { return }
        let (depKey, depCurSel) = SelectItemsManager.shared.chkParent(textField.itemKey, editTempCD: editableModel.editTempCD)
        if let _ = depKey, depCurSel == "" { //依存関係あるけど未選択だった場合
            self.view.endEditing(true)
            return
        }
        let (_, editTemp) = editableModel.makeTempItem(item)
        //Pickerを表示する
        let picker = IKDatePicker()
        let bufDate = editTemp.curVal
        let date = DateHelper.convStrYMD2Date(bufDate)
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
//        textField.inputAccessoryView?.backgroundColor = .green
    }
    
    //ピッカーにつけた〔選択〕〔Cancel〕ボタン
    @objc func actDatePickerSelectButton(_ sender: IKBarButtonItem) {
        guard let picker = sender.parentPicker as? IKDatePicker else { return }
        picker.parentTF?.text = picker.date.dispYmdJP()
        //guard let editableModel = editableModel else { return }
        print(picker.itemKey)
        print(editableModel.arrData.debugDescription)
        guard let item = editableModel.getItemByKey(picker.itemKey) else { return }
        editableModel.changeTempItem(item, text: picker.date.dispYmd())
        self.view.endEditing(false)
    }
    @objc func actDatePickerCancelButton(_ sender: IKBarButtonItem) {
        self.view.endEditing(false)
    }

}
