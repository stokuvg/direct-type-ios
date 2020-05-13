//
//  EditableBasicVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SVProgressHUD

//=== 編集可能項目の対応
class EditableBasicVC: TmpBasicVC {
    //編集中の情報
    var editableModel: EditableModel? //画面編集項目のモデルと管理
    //=== OVerrideして使う
    func moveNextCell(_ editableItemKey: String) -> Bool { return true } //次の項目へ移動
    func dispEditableItemAll() {} //すべての項目を表示する
    func dispEditableItemByKey(_ itemKey: EditableItemKey) {} //指定した項目を表示する （TODO：複数キーの一括指定に拡張予定）
    //ValidationError管理
    var dicValidErr: [EditableItemKey: ValidationErrMsg] = [:] //[ItemEditable.item: ErrMsg]　（TODO：これもEditableBaseで管理にするか））
    //====================================================
    //SuggestなどでのActiveなTextFieldを表示するため
    var targetTfArea: TargetAreaVW? = nil//これは触った場所を表すために
    //###======================================================

    //=======================================================================================================
    func actTargetInputTextBegin(_ tf: IKTextField, _ item: EditableItemH) {
        showTargetTF(self.view, tf)
    }
    func showTargetTF(_ parent: UIView, _ tf: IKTextField) {
        let origin: CGPoint = tf.bounds.origin
        let sz: CGSize = tf.bounds.size
        let origin2 = tf.convert(origin, to: parent)
        let rectCurTF = CGRect(origin: origin2, size: sz)
        //元のTextFieldに被せるもの
        if targetTfArea == nil {
            let vw: TargetAreaVW = TargetAreaVW(frame: rectCurTF)
            vw.backgroundColor = .clear
            vw.alpha = 0.1
            vw.isUserInteractionEnabled = false
            parent.addSubview(vw)
            targetTfArea = vw
        } else {
            targetTfArea?.frame = rectCurTF
        }
        targetTfArea?.backgroundColor = .red
    }
    func dissmissTargetTfArea() {
        targetTfArea?.removeFromSuperview()
        targetTfArea = nil
    }
    //=======================================================================================================
}
//セルでのテキスト入力の変更
extension EditableBasicVC: InputItemHDelegate {
    func textFieldShouldReturn(_ textField: IKTextField, _ item: EditableItemH) -> Bool {
        print(#line, #function)
        if textField.returnKeyType == .next {
            return moveNextCell(item.editableItemKey)//次のセルへ遷移
        }
        //現在のTextFieldが最後じゃなければ、次の項目になる項目を取得したい(IndexPath経由にする
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        }
       return true
    }
    func textFieldShouldClear(_ tf: IKTextField, _ item: EditableItemH) -> Bool {
        print(#line, #function)
        guard let editableModel = editableModel else { return true }
        editableModel.changeTempItem(item, text: "")//編集中の値の保持（と描画）
        if let depKey = editableModel.clearDependencyItemByKey(item.editableItemKey) { //依存関係があればクリア
            dispEditableItemByKey(depKey)//依存してた方の表示も更新する
        }
        dispEditableItemByKey(item.editableItemKey)//大正の表示を更新する
        return true
    }
    
    
//    func editingDidBegin(_ tf: IKTextField, _ item: EditableItemH) {
//        showPickerYMD(tf, item)
//    }
    func editingDidBegin(_ tf: IKTextField, _ item: EditableItemH) {
        print(#line, #function)
        actTargetInputTextBegin(tf, item) //元のTextFieldに被せるもの（なくて良い）

        //画面全体での初期状態での値と編集中の値を保持させておくため
//!!!        guard let editableModel = editableModel else { return }
//!!!        let (_, editTemp) = editableModel.makeTempItem(item)
        //=== タイプによって割り込み処理
        switch item.editType {
        case .selectDrum: //Pickerを生成する
            print("Picker開く時の処理 [\(item.editableItemKey): \(item.dispName)]")
            showPicker(tf, item)
        case .selectDrumYMD: //Pickerを生成する
            print("Picker開く時の処理 [\(item.editableItemKey): \(item.dispName)]")
            showPickerYMD(tf, item)
        case .selectSingle:
            //さらに子ナビさせたいので
            let storyboard = UIStoryboard(name: "EditablePopup", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubSelectSingleVC") as? SubSelectSingleVC{
                nvc.initData(editableItem: item, type: .gender)
                print(String(repeating: "=", count: 33))
                //遷移アニメーション関連
                //self.navigationController?.pushViewController(nvc, animated: true)
                nvc.modalTransitionStyle = .crossDissolve
                self.view.endEditing(true)
                hidePicker(tf)
                self.present(nvc, animated: true) {
                }
                tf.resignFirstResponder()//???
            }
        case .selectMulti:
            let storyboard = UIStoryboard(name: "EditablePopup", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubSelectMultiVC") as? SubSelectMultiVC{
                nvc.initData(type: .entryPlace)
                //遷移アニメーション関連
                //self.navigationController?.pushViewController(nvc, animated: true)
                nvc.modalTransitionStyle = .crossDissolve
                self.view.endEditing(true)
                hidePicker(tf)
                self.present(nvc, animated: true) {
                }
                tf.resignFirstResponder()//???
            }
        case .selectSpecisl:
            let storyboard = UIStoryboard(name: "EditablePopup", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubSelectSpecialVC") as? SubSelectSpecialVC{
                nvc.initData(editableItem: item)
                //遷移アニメーション関連
                //self.navigationController?.pushViewController(nvc, animated: true)
                nvc.modalTransitionStyle = .crossDissolve
                self.view.endEditing(true)
                hidePicker(tf)
                self.present(nvc, animated: true) {
                }
                tf.resignFirstResponder()//???
            }
        case .readonly:
            break
        case .inputText:
            break
        case .inputZipcode:
            break
        case .inputTextSecret:
            break
        }
    }
    func editingDidEnd(_ tf: IKTextField, _ item: EditableItemH) {
        dissmissTargetTfArea() //元のTextFieldに被せるもの（なくて良い）
        //=== タイプによって割り込み処理
        switch item.editType {
        case .selectDrum:
            print("Picker閉じる時の処理 [\(item.editableItemKey): \(item.dispName)]")
            hidePicker(tf)
        case .selectDrumYMD:
            print("Picker閉じる時の処理 [\(item.editableItemKey): \(item.dispName)]")
            hidePicker(tf)
        case .readonly:
            break
        case .inputText:
            break
        case .inputTextSecret:
            break
        case .inputZipcode:
            break
        case .selectSingle:
            break
        case .selectMulti:
            break
        case .selectSpecisl:
            break
        }
        print("💛[\(tf.itemKey)] 編集終わり💛「[\(tf.tag)] \(#function)」[\(tf.itemKey)][\(tf.text ?? "")] [\(tf.inputAccessoryView)] [\(tf.inputView)]")
    }
    func changedItem(_ tf: IKTextField, _ item: EditableItemH, text: String) {
        guard let editableModel = editableModel else { return }
        editableModel.changeTempItem(item, text: text)//入力値の反映
    }
}



//=== 文字入力に伴うTextField関連の通知
extension EditableBasicVC {
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




//################################################################################
extension EditableBasicVC: UIPickerViewDataSource, UIPickerViewDelegate {
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

