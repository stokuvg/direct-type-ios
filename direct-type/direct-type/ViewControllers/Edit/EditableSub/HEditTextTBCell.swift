//
//  HEditTextTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class HEditTextTBCell: UITableViewCell {
    var item: EditableItemH? = nil
    var delegate: InputItemHDelegate!
    var returnKeyType: UIReturnKeyType = .next

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfValue: IKTextField!
    @IBOutlet weak var lblDebug: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func initCell(_ delegate: InputItemHDelegate, _ item: EditableItemH, _ returnKeyType: UIReturnKeyType) {
        self.delegate = delegate
        self.item = item
        self.returnKeyType = returnKeyType
        tfValue.itemKey = item.editableItemKey
        tfValue.returnKeyType = returnKeyType
    }
    
    func dispCell() {
        guard let _item = item else { return }
        let bufTitle = _item.dispName //_item.type.dispTitle
        lblTitle.text(text: bufTitle, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        var bufVal: String = ""
        switch _item.editType {
        case .selectDrumYMD:
            bufVal = _item.valDisp
        case .selectDrum, .selectSingle:
            bufVal = _item.valDisp
        case .selectMulti:
            bufVal = _item.valDisp
        case .selectSpecisl:
            bufVal = _item.valDisp
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
}




extension HEditTextTBCell: UITextFieldDelegate {
    //=== ピッカーで選択させる場合の処理 ===
    //===元のTextFieldの直接編集は却下したい
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? IKTextField else { return true }
        if let tfiv = textField.inputView as? UIPickerView {
            print("❤️[\(textField.itemKey)] [\(#function)]❤️ ❤️[Pickerのため編集抑止]❤️")
            return false //Pickerに結びついていたら編集却下とする
        }
        return true
    }
    //今はTextField使い捨てなので無理ですが、ちゃんと画面定義してすべて保持するようにしておけば、Nextでの移動も可能になる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textField = textField as? IKTextField else { return true }
        print("❤️[\(textField.itemKey)] [\(#function)]❤️ ❤️[Return押された]❤️")
        if let delegate = delegate {
            return delegate.textFieldShouldReturn(textField, item!)
        }
       return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        guard let textField = textField as? IKTextField else { return true }
        print(item)
        print("❤️[\(textField.itemKey)] [\(#function)]❤️ ❤️[Clear押された]❤️")
        if let delegate = delegate {
            return delegate.textFieldShouldClear(textField, item!)
        }
        return true
    }
    
}
