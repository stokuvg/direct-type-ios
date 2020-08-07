//
//  HEditMemoTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/07/17.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class HEditMemoTBCell: UITableViewCell {
    var delegate: InputItemHDelegate!
    var item: EditableItemH? = nil
    var errMsg: String = ""
    var returnKeyType: UIReturnKeyType = .next
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var vwRequiredIconArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: ExItemLabel!
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
    }

    func initCell(_ delegate: InputItemHDelegate, _ item: EditableItemH, errMsg: String, _ returnKeyType: UIReturnKeyType) {
        self.delegate = delegate
        self.item = item
        self.errMsg = errMsg
        self.returnKeyType = returnKeyType
        vwRequiredIconArea.isHidden = !item.editItem.valid.required //必須アイコンの表示制御
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
        let bufVal: String = _item.curVal
        //PlaceHolder表示
        if bufVal.isEmpty {
            lblValue.numberOfLines = 1
            lblValue.text(text: _item.placeholder, fontType: .font_S, textColor: UIColor.init(colorType: .color_light_gray)!, alignment: .left)
        } else {
            lblValue.numberOfLines = 0
            lblValue.text(text: bufVal, fontType: .font_S, textColor: UIColor.init(colorType: .color_main)!, alignment: .left)
        }
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
    func active() {
        guard let _item = item else { return }
        let sender: IKTextField = IKTextField()
        sender.itemKey = _item.editableItemKey
        delegate?.editingDidBegin(sender, _item)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

