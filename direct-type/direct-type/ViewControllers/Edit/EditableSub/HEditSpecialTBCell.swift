//
//  HEditSpecialTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/03.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class HEditSpecialTBCell: UITableViewCell {
    var delegate: InputItemHDelegate!
    var item: EditableItemH? = nil
    var item2: EditableItemH? = nil
    var errMsg: String = ""
    var returnKeyType: UIReturnKeyType = .next
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var vwRequiredIconArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfValue: IKTextField!
    @IBOutlet weak var lblDebug: UILabel!
    @IBOutlet weak var lblErrorMsg: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)
        tfValue.textColor = UIColor(colorType: .color_black)
    }

    func initCell(_ delegate: InputItemHDelegate, _ item: EditableItemH, _ item2: EditableItemH?,  errMsg: String, _ returnKeyType: UIReturnKeyType) {
        self.delegate = delegate
        self.item = item
        self.item2 = item2
        self.errMsg = errMsg
        self.returnKeyType = returnKeyType
        tfValue.itemKey = item.editableItemKey
        tfValue.returnKeyType = returnKeyType
        tfValue.placeholder = item.placeholder
        tfValue.clearButtonMode = .never //クリアボタンの表示制御
        vwRequiredIconArea.isHidden = !item.editItem.valid.required //必須アイコンの表示制御
    }
    
    func dispCell() {
        guard let _item = item else { return }
        let bufTitle = _item.dispName //_item.type.dispTitle
        lblTitle.text(text: bufTitle, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_main)!, alignment: .left)
        var bufVal: String = ""
        switch _item.editType {
        case .selectSpecial:
            bufVal = _item.valDisp
        case .selectSpecialYear:
            if _item.curVal.isEmpty {
                bufVal = ""
            } else {
                if let _item2 = item2 {
                    bufVal = "\(_item.valDisp)：\(_item2.valDisp)"
                }
            }
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
            lblErrorMsg.text(text: errMsg, fontType: .font_SSS, textColor: UIColor(colorType: .color_sub)!, alignment: .left)
            if UITraitCollection.isDarkMode == true {
                vwMainArea.backgroundColor = UIColor.init(red: 0.3, green: 0.1, blue: 0.1, alpha: 1.0)
            } else {
                vwMainArea.backgroundColor = UIColor.init(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
            }
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
extension HEditSpecialTBCell {
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
