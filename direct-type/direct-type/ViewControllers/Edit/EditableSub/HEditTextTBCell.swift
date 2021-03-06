//
//  HEditTextTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class HEditTextTBCell: UITableViewCell {
    var delegate: InputItemHDelegate!
    var item: EditableItemH? = nil
    var errMsg: String = ""
    var returnKeyType: UIReturnKeyType = .next
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var vwRequiredIconArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfValue: IKTextField!
    @IBOutlet weak var vwExUnitArea: UIView!
    @IBOutlet weak var lblExUnit: UILabel!
    @IBOutlet weak var lblDebug: UILabel!
    @IBOutlet weak var lblErrorMsg: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        selectionStyle = .none
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)
        tfValue.textColor = UIColor(colorType: .color_black)
        tfValue.tintColor = UIColor(colorType: .color_black)
        tfValue.backgroundColor = UIColor(colorType: .color_white)
        tfValue.borderColor = UIColor(colorType: .color_line)
        tfValue.font = UIFont(fontType: .font_S)
    }

    func initCell(_ delegate: InputItemHDelegate, _ item: EditableItemH, errMsg: String, _ returnKeyType: UIReturnKeyType) {
        self.delegate = delegate
        self.item = item
        self.errMsg = errMsg
        self.returnKeyType = returnKeyType
        tfValue.itemKey = item.editableItemKey
        tfValue.returnKeyType = returnKeyType
        tfValue.placeholder = item.placeholder
        //==キーボードタイプを設定する
        switch item.editItem.valid.type {
        case .password:
            tfValue.keyboardType = UIKeyboardType.asciiCapable
        case .email:
            tfValue.keyboardType = UIKeyboardType.emailAddress
        case .number:
            tfValue.keyboardType = UIKeyboardType.numberPad
        default:
            tfValue.keyboardType = UIKeyboardType.default
        }
        //クリアボタンの表示制御
        switch item.editType {
        case .inputText, .inputTextSecret:
            tfValue.clearButtonMode = .always
        default:
            tfValue.clearButtonMode = .never
        }
        vwRequiredIconArea.isHidden = !item.editItem.valid.required //必須アイコンの表示制御
        //===ソフトウェアキーボードに〔閉じる〕ボタン付与
        let rect = CGRect(origin: CGPoint.zero, size: CGSize.init(width: 60, height: 45))
        let toolbar = UIToolbar(frame: rect)//Autolayout補正かかるけど、そこそこの横幅指定が必要
        let separator1 = IKBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnClose = IKBarButtonItem.init(title: "閉じる", style: .done, target: self, action: #selector(actInputCancelButton))
        toolbar.setItems([btnClose, separator1], animated: true)
        tfValue.inputAccessoryView = toolbar
    }
    @objc func actInputCancelButton(_ sender: IKBarButtonItem) {
        self.endEditing(true)
    }

    func dispCell() {
        guard let _item = item else { return }
        if _item.dispUnit.isEmpty { //単位の追加表示
            vwExUnitArea.isHidden = true
        } else {
            vwExUnitArea.isHidden = false
            lblExUnit.text(text: _item.dispUnit, fontType: .font_S, textColor: UIColor.init(colorType: .color_main)!, alignment: .left)
        }
        let bufTitle = _item.dispName //_item.type.dispTitle
        lblTitle.text(text: bufTitle, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_main)!, alignment: .left)
        var bufVal: String = ""
        switch _item.editType {
        case .selectDrumYMD:
            bufVal = _item.valDisp
        case .selectDrumYM:
            bufVal = _item.valDisp
        case .selectSingle:
            bufVal = _item.valDisp
        case .selectMulti:
            bufVal = _item.valDisp
        case .selectSpecial:
            bufVal = _item.valDisp
        case .inputText:
            if _item.editItem.valid.type == .number {
                if _item.curVal == "0" {
                    bufVal = ""
                    break
                }
            }
            bufVal = _item.curVal
        default:
            bufVal = _item.curVal
        }
        tfValue.text = bufVal
        tfValue.returnKeyType = returnKeyType
        lblDebug.text = ""
        if Constants.DbgDispStatus {
            let bufDebug = _item.debugDisp
            lblDebug.text = bufDebug
        }
        //Validationエラー発生時の表示
        if errMsg != "" {
            //lblErrorMsg.text = errMsg
            lblErrorMsg.text(text: errMsg, fontType: .font_SS, textColor: UIColor(colorType: .color_sub)!, alignment: .left)
            vwMainArea.backgroundColor = UIColor.init(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        } else {
            lblErrorMsg.text = ""
            vwMainArea.backgroundColor = self.backgroundColor
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


//=== 文字入力に伴うTextField関連の通知
extension HEditTextTBCell {
    @IBAction func actEditingDidBegin(_ sender: IKTextField) {
        guard let _item = item else { return }
        delegate?.editingDidBegin(sender, _item)
    }
    @IBAction func actEditingDidEnd(_ sender: IKTextField) {
        guard let _item = item else { return }
        delegate?.editingDidEnd(sender, _item)
    }
    @IBAction func actEditingChanged(_ sender: IKTextField) {
        guard let _item = item else { return }
        delegate?.changedItem(sender, _item, text: sender.text ?? "")
    }
}


extension HEditTextTBCell: UITextFieldDelegate {
    //=== ピッカーで選択させる場合の処理 ===
    //===元のTextFieldの直接編集は却下したい
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? IKTextField else { return true }
        if let tfiv = textField.inputView as? UIPickerView {
            return false //Pickerに結びついていたら編集却下とする
        }
        return true
    }
    //今はTextField使い捨てなので無理ですが、ちゃんと画面定義してすべて保持するようにしておけば、Nextでの移動も可能になる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textField = textField as? IKTextField else { return true }
        if let delegate = delegate {
            return delegate.textFieldShouldReturn(textField, item!)
        }
       return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        guard let textField = textField as? IKTextField else { return true }
        if let delegate = delegate {
            return delegate.textFieldShouldClear(textField, item!)
        }
        return true
    }
}
