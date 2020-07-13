//
//  HEditDrumTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/12.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

// 入力フィードバック
protocol InputItemHDelegate {
    //=== 前次制御
    func textFieldShouldReturn(_ tf: IKTextField, _ item: EditableItemH) -> Bool
    func textFieldShouldClear(_ tf: IKTextField, _ item: EditableItemH) -> Bool
    //=== 入力制御
    func editingDidBegin(_ tf: IKTextField, _ item: EditableItemH)
    func editingDidEnd(_ tf: IKTextField, _ item: EditableItemH)
    func changedItem(_ tf: IKTextField, _ item: EditableItemH, text: String)
}

class HEditDrumTBCell: UITableViewCell {
    var delegate: InputItemHDelegate!
    var item: EditableItemH? = nil
    var errMsg: String = ""

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
        tfValue.tintColor = UIColor(colorType: .color_black)
        tfValue.backgroundColor = UIColor(colorType: .color_white)
        tfValue.borderColor = UIColor(colorType: .color_line)
        tfValue.font = UIFont(fontType: .font_S)
    }

    func initCell(_ delegate: InputItemHDelegate, _ item: EditableItemH, errMsg: String) {
        self.delegate = delegate
        self.item = item
        self.errMsg = errMsg
        tfValue.itemKey = item.editableItemKey
        tfValue.clearButtonMode = .never //クリアボタンの表示制御
        vwRequiredIconArea.isHidden = !item.editItem.valid.required //必須アイコンの表示制御
    }
    
    func dispCell() {
        guard let _item = item else { return }
        let bufTitle = _item.dispName //_item.type.dispTitle
        lblTitle.text(text: bufTitle, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_main)!, alignment: .left)
        let date: Date = DateHelper.convStrYMD2Date(_item.curVal)
        if date == Constants.SelectItemsUndefineDate {
            tfValue.text = Constants.SelectItemsUndefineDateJP
        } else {
            tfValue.text = date.dispYmdJP()
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//=== 文字入力に伴うTextField関連の通知
extension HEditDrumTBCell {
    @IBAction func actEditingDidBegin(_ sender: IKTextField) {
        guard let _item = item else { return }
        delegate?.editingDidBegin(sender, _item)
    }
    @IBAction func actEditingDidEnd(_ sender: IKTextField) {
        guard let _item = item else { return }
        delegate?.editingDidEnd(sender, _item)
    }
}

