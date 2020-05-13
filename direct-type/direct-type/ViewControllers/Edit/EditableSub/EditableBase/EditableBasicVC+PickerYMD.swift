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
    
    //ピッカーにつけた〔選択〕〔Cancel〕ボタン
    @objc func actDatePickerSelectButton(_ sender: IKBarButtonItem) {
        guard let picker = sender.parentPicker as? IKDatePicker else { return }
        picker.parentTF?.text = picker.date.dispYmdJP()
        self.view.endEditing(false)
    }
    @objc func actDatePickerCancelButton(_ sender: IKBarButtonItem) {
        guard let picker = sender.parentPicker as? IKDatePicker else { return }
        self.view.endEditing(false)
    }

}
