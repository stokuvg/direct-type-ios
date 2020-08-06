//
//  EditableBasicVC+Picker.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

//Pickerによる「年」「月」選択に特化したものに変更

//=== 文字入力に伴うTextField関連の通知
extension EditableBasicVC {
    //=== 表示・非表示
    func showPicker(_ textField: IKTextField, _ item: EditableItemH) {
        //Pickerを表示する
        let picker = IKPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.itemKey = textField.itemKey
        picker.parentTF = textField
        textField.inputView = picker //
        //Pickerにボタンをつけておく（Pickerにというか、inputViewに対して付くため、Softwareキーボードなければ最下部に、あればその上につく
        let rect = CGRect(origin: CGPoint.zero, size: CGSize.init(width: 60, height: 45))
        let toolbar = UIToolbar(frame: rect)//Autolayout補正かかるけど、そこそこの横幅指定が必要
        let lbl = UILabel(frame: rect)
        lbl.textAlignment = .center
        lbl.minimumScaleFactor = 0.5
        lbl.adjustsFontSizeToFitWidth = true
        switch item.editableItemKey {
        case EditItemMdlCareerCardWorkPeriod.endDate.itemKey: fallthrough
        case EditItemMdlAppSmoothCareerComponyDescriptionWorkPeriod.workEndDate.itemKey:
            lbl.text = "\(item.dispName)を選択"
        default:
            lbl.text = "\(item.dispName)を選択してください"
        }
        let separator1 = IKBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barLbl = IKBarButtonItem.init(customView: lbl)
        let separator2 = IKBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnClose = IKBarButtonItem.init(title: "閉じる", style: .done, target: self, action: #selector(actPickerCancelButton))
        let btnSelect = IKBarButtonItem.init(title: "選択", style: .done, target: self, action: #selector(actPickerSelectButton))
        let btnReset = IKBarButtonItem.init(title: Constants.DefaultSelectWorkPeriodEndDateJP, style: .done, target: self, action: #selector(actPickerResetButton))
        //=== itemKeyをつけておく
        btnSelect.parentPicker = picker
        btnClose.parentPicker = picker
        btnReset.parentPicker = picker
        switch item.editableItemKey {
        case EditItemMdlCareerCardWorkPeriod.endDate.itemKey:
//            toolbar.setItems([btnClose, separator1, btnReset, btnSelect], animated: true)
            toolbar.setItems([btnClose, separator1, barLbl, separator2, btnReset, btnSelect], animated: true)
        default:
            toolbar.setItems([btnClose, separator1, barLbl, separator2, btnSelect], animated: true)
        }
        textField.inputAccessoryView = toolbar
        //===現在の設定値を反映させる
        guard let item = editableModel.getItemByKey(textField.itemKey) else { return }
        let (_, editTemp) = editableModel.makeTempItem(item)
        var bufYYYY: String = ""
        var bufMM: String = ""
        var date = DateHelper.convStrYM2Date(editTemp.curVal)
        //未設定の振り分けを実施したのち、ドラム選択初期値の決定処理を実施
        if date == Constants.SelectItemsUndefineDate {
            var _date: Date {
                switch editTemp.editItem.itemKey {
                case EditItemMdlResumeSchool.graduationYear.itemKey:
                    return DateHelper.convStrYM2Date("\(Date().dispYear())-03")
                case EditItemMdlCareerCardWorkPeriod.startDate.itemKey: fallthrough
                case EditItemMdlAppSmoothCareerComponyDescriptionWorkPeriod.workStartDate.itemKey:
                    return Constants.DefaultSelectWorkPeriodStartDate
                case EditItemMdlCareerCardWorkPeriod.endDate.itemKey: fallthrough
                case EditItemMdlAppSmoothCareerComponyDescriptionWorkPeriod.workEndDate.itemKey:
                    return Constants.DefaultSelectWorkPeriodEndDate
                default:
                    return DateHelper.convStrYM2Date(editTemp.curVal)
                }
            }
            date = _date
        }
        switch date {
        case Constants.DefaultSelectWorkPeriodEndDate: //終了が就業中の場合にドラムを開いた時の初期値は、「現在の年月」とする
            bufYYYY = Date().dispYear()
            bufMM = Date().dispMonth()
        default:
            bufYYYY = date.dispYear()
            bufMM = date.dispMonth()
        }
        let idxYYYY = Constants.years.firstIndex { (year) -> Bool in
            year == Int(bufYYYY)
        } ?? 0
        let idxMM = Constants.months.firstIndex { (month) -> Bool in
            month == Int(bufMM)
        } ?? 0
        picker.selectRow(idxYYYY, inComponent: 0, animated: true)
        picker.selectRow(idxMM, inComponent: 1, animated: true)
    }
    func hidePicker(_ textField: IKTextField) {
        textField.resignFirstResponder()//???
        textField.inputAccessoryView = nil //ここで、関連つけていたToolbarを殺す
        textField.inputView = nil //ここで、関連つけていたPickerを殺す
    }

    //ピッカーにつけた〔選択〕〔Cancel〕ボタン
    @objc func actPickerSelectButton(_ sender: IKBarButtonItem) {
        guard let picker = sender.parentPicker as? IKPickerView else { return }
        let yyyy: Int = Constants.years[picker.selectedRow(inComponent: 0)]
        let mm: Int = Constants.months[picker.selectedRow(inComponent: 1)]
        let bufDate: String = "\(yyyy.zeroUme(4))-\(mm.zeroUme(2))"
        picker.parentTF?.text = DateHelper.convStrYM2Date(bufDate).dispYmJP()
        guard let item = editableModel.getItemByKey(picker.itemKey) else { return }
        editableModel.changeTempItem(item, text: bufDate)
        self.view.endEditing(false)
    }
    @objc func actPickerCancelButton(_ sender: IKBarButtonItem) {
        self.view.endEditing(true)
    }
    @objc func actPickerResetButton(_ sender: IKBarButtonItem) {
        guard let picker = sender.parentPicker as? IKPickerView else { return }
        picker.parentTF?.text = Constants.DefaultSelectWorkPeriodEndDate.dispYmJP()
        guard let item = editableModel.getItemByKey(picker.itemKey) else { return }
        editableModel.changeTempItem(item, text: Constants.DefaultSelectWorkPeriodEndDate.dispYm())
        self.view.endEditing(false)
    }

}

//################################################################################
//「年」「月」選択特化Picker
extension EditableBasicVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //guard let pickerView = pickerView as? IKPickerView else { return 0 }
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //guard let pickerView = pickerView as? IKPickerView else { return 0 }
        switch component {
        case 0: return Constants.years.count
        case 1: return Constants.months.count
        default: return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard let pickerView = pickerView as? IKPickerView else { return UIView() }
        //let selectionItems = editableModel.makePickerItems(itemKey: pickerView.itemKey)
        var val: Int {
            switch component {
            case 0: return Constants.years[row]
            case 1: return Constants.months[row]
            default: return 0
            }
        }
        let lbl = UILabel.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: pickerView.bounds.size.width - 20, height: 30)))
        lbl.font = UIFont.systemFont(ofSize: 24)
        lbl.text = "\(val)"
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
        guard let parentTF = pickerView.parentTF else { return }//フィードバックさせるため
        parentTF.text = item.disp
    }
}

