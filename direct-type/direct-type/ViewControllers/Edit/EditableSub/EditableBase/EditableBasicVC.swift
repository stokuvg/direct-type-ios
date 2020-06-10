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
class EditableBasicVC: TmpBasicVC, SubSelectFeedbackDelegate {
    func changedSelect(editItem: EditableItemH, codes: String) {
        switch editItem.editType {
        case .selectSpecial:
            editableModel.changeTempItem(editItem, text: codes)//入力値の反映
            dispEditableItemAll()//対象の表示を更新する
            print("❤️❤️[\(editItem.editType)]]❤️❤️", editItem.debugDisp)
            print(#line, #function, editItem.editType, editItem.debugDisp, codes)
        case .selectSpecialYear:
            editableModel.changeTempItem(editItem, text: codes)//入力値の反映
            dispEditableItemAll()//対象の表示を更新する
            print("❤️❤️[\(editItem.editType)]]❤️❤️", editItem.debugDisp)
            print(#line, #function, editItem.editType, editItem.debugDisp, codes)
        case .inputMemo:
            editableModel.changeTempItem(editItem, text: codes)//入力値の反映
            dispEditableItemByKey(editItem.editableItemKey)//対象の表示を更新する
        default:
            editableModel.changeTempItem(editItem, text: codes)//入力値の反映
            dispEditableItemByKey(editItem.editableItemKey)//対象の表示を更新する
            print("❤️❤️[\(editItem.editType)]]❤️❤️", editItem.debugDisp)
        }
    }
    
    //編集中の情報
    var editableModel: EditableModel = EditableModel() //画面編集項目のモデルと管理
    //=== OVerrideして使う
    func moveNextCell(_ editableItemKey: String) -> Bool { return true } //次の項目へ移動
    func dispEditableItemAll() {} //すべての項目を表示する
    func dispEditableItemByKey(_ itemKey: EditableItemKey) {} //指定した項目を表示する （TODO：複数キーの一括指定に拡張予定）
    //ValidationError管理
    var dicValidErrMsg: [EditableItemKey: [ValidationErrMsg]] = [:] //[ItemEditable.item: ErrMsg]

    //====================================================
    //SuggestなどでのActiveなTextFieldを表示するため
    var targetTfArea: TargetAreaVW? = nil//これは触った場所を表すために
    //###======================================================

    //=======================================================================================================
    func actTargetInputTextBegin(_ tf: IKTextField, _ item: EditableItemH) {
        showTargetTF(self.view, tf)
    }
    func showTargetTF(_ parent: UIView, _ tf: IKTextField) {
        if !Constants.DbgDispStatus { return }
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
        if !Constants.DbgDispStatus { return }
        targetTfArea?.removeFromSuperview()
        targetTfArea = nil
    }
    //=======================================================================================================
}
//セルでのテキスト入力の変更
extension EditableBasicVC: InputItemHDelegate {
    func textFieldShouldReturn(_ textField: IKTextField, _ item: EditableItemH) -> Bool {
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
        editableModel.changeTempItem(item, text: "")//編集中の値の保持（と描画）
        if let depKey = editableModel.clearDependencyItemByKey(item.editableItemKey) { //依存関係があればクリア
            dispEditableItemByKey(depKey)//依存してた方の表示も更新する
        }
        dispEditableItemByKey(item.editableItemKey)//対象の表示を更新する
        return true
    }
    func editingDidBegin(_ tf: IKTextField, _ item: EditableItemH) {
        actTargetInputTextBegin(tf, item) //元のTextFieldに被せるもの（なくて良い）
        //画面全体での初期状態での値と編集中の値を保持させておくため
        //guard let editableModel = editableModel else { return }
        let (_, editTemp) = editableModel.makeTempItem(item)
        //=== タイプによって割り込み処理
        switch item.editType {
        case .selectDrum: //Pickerを生成する
            print("Picker開く時の処理 [\(item.editableItemKey): \(item.dispName)]")
            showPicker(tf, item)
        case .selectDrumYMD: //Pickerを生成する
            print("Picker開く時の処理 [\(item.editableItemKey): \(item.dispName)]")
            showPickerYMD(tf, item)
        case .selectSingle:
            //さらに子ナビさせたいので@objc  
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                tf.resignFirstResponder()//自分を解除しておかないと、戻ってきたときにまた遷移してしまうため
                let storyboard = UIStoryboard(name: "EditablePopup", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubSelectSingleVC") as? SubSelectSingleVC{
                    print("\t🌸🌸[\(item.curVal)] -> [\(editTemp.curVal)]🌸🌸")
                    nvc.initData(self, editableItem: item, selectingCodes: editTemp.curVal)
                    //遷移アニメーション関連
                    nvc.modalTransitionStyle = .crossDissolve
                    self.present(nvc, animated: true) {}
                }
            })
        case .selectMulti:
            //さらに子ナビさせたいので
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                tf.resignFirstResponder()//自分を解除しておかないと、戻ってきたときにまた遷移してしまうため
                let storyboard = UIStoryboard(name: "EditablePopup", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubSelectMultiVC") as? SubSelectMultiVC{
                    print("\t🌸🌸[\(item.curVal)] -> [\(editTemp.curVal)]🌸🌸")
                    nvc.initData(self, editableItem: item, selectingCodes: editTemp.curVal)
                    //遷移アニメーション関連
                    nvc.modalTransitionStyle = .crossDissolve
                    self.present(nvc, animated: true) {}
                }
            })
        case .selectSpecial, .selectSpecialYear:
            //さらに子ナビさせたいので
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                tf.resignFirstResponder()//自分を解除しておかないと、戻ってきたときにまた遷移してしまうため
                let storyboard = UIStoryboard(name: "EditablePopup", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubSelectSpecialVC") as? SubSelectSpecialVC{
                    nvc.initData(self, editableItem: item, selectingCodes: "") // jobType | skill
                    //遷移アニメーション関連
                    nvc.modalTransitionStyle = .crossDissolve
                    self.present(nvc, animated: true) {}
                }
            })
        case .inputMemo:
            //さらに子ナビさせたいので//!!!
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                tf.resignFirstResponder()//自分を解除しておかないと、戻ってきたときにまた遷移してしまうため
                let storyboard = UIStoryboard(name: "Edit", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubInputMemoVC") as? SubInputMemoVC{
                    nvc.initData(self, editableItem: item)
                    //遷移アニメーション関連
                    nvc.modalTransitionStyle = .crossDissolve
                    self.present(nvc, animated: true) {}
                }
            })
            break

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
        case .inputMemo:
            print("テキストビューでの大量文字入力時")
        case .selectDrum:
            print("Picker閉じる時の処理 [\(item.editableItemKey): \(item.dispName)] [\(tf.description)]")
            hidePicker(tf)
        case .selectDrumYMD:
            print("Picker閉じる時の処理 [\(item.editableItemKey): \(item.dispName)] [\(tf.description)]")
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
        case .selectSpecial, .selectSpecialYear:
            break
        }
        print("💛[\(tf.itemKey)] 編集終わり💛「[\(tf.tag)] \(#function)」[\(tf.itemKey)][\(tf.text ?? "")] [\(String(describing: tf.inputAccessoryView))] [\(String(describing: tf.inputView))]")
    }
    func changedItem(_ tf: IKTextField, _ item: EditableItemH, text: String) {
        editableModel.changeTempItem(item, text: text)//入力値の反映
    }
}

