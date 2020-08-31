//
//  HPreviewTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class HPreviewTBCell: UITableViewCell {
    var item: MdlItemH? = nil
    var errMsg: String = ""
    var editTempCD: [EditableItemKey: EditableItemCurVal] = [:]
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var vwRequiredIconArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: ExItemLabel!
    @IBOutlet weak var lblNotice: UILabel!
    @IBOutlet weak var lblErrorMsg: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)
    }

    func initCell(_ item: MdlItemH, editTempCD: [EditableItemKey: EditableItemCurVal], errMsg: String) {
        self.item = item
        self.errMsg = errMsg
        self.editTempCD = editTempCD//表示だけに使用するため横流し
        if item.readonly {
            self.isUserInteractionEnabled = false
            self.accessoryType = .none
            self.lblValue.isReadonly = true
        } else {
            self.isUserInteractionEnabled = true
            self.accessoryType = .none // .disclosureIndicator 遷移マーク不要
            self.lblValue.isReadonly = false
        }
        //必須アイコンの表示制御（子項目に1つでも必須があれば、そのグループは必須）
        var isRequired: Bool = false
        for childItem in item.childItems {
            if childItem.editItem.valid.required == true {
                isRequired = true
            }
        }
        vwRequiredIconArea.isHidden = !isRequired //必須アイコンの表示制御
    }
    
    func dispCell() {
        guard let _item = item else { return }
        //子項目に値を適用させておく必要ありだ
        for (n, item) in _item.childItems.enumerated() {
            if let temp = editTempCD[item.editableItemKey] {
                _item.childItems[n].curVal = temp
            }
        }
        //===表示用文字列の生成
        let bufTitle: String = _item.type.dispTitle
        let bufValue: String!
        var colValue: UIColor!
        if let buf = dispCellValue2(_item) {
            bufValue = buf
            colValue = UIColor(colorType: .color_black)!
        } else {
            bufValue = "未入力"
            colValue = UIColor(colorType: .color_parts_gray)!
        }
        let bufNotice: String = _item.notice
        //===表示させる
        lblTitle.text(text: bufTitle, fontType: .font_Sb, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        lblValue.setProperties(fontType: .PV_font_S)
        lblValue.text(text: bufValue, fontType: .PV_font_S, textColor: colValue, alignment: .left, lineBreakMode: .byCharWrapping)
        lblNotice.text(text: bufNotice, fontType: .font_SS, textColor: UIColor(colorType: .color_parts_gray)!, alignment: .left)
        lblNotice.isHidden = (_item.notice == "") ? true : false
        //Validationエラー発生時の表示
        if errMsg != "" {
            //lblErrorMsg.text = errMsg
            lblErrorMsg.text(text: errMsg, fontType: .font_SS, textColor: UIColor(colorType: .color_sub)!, alignment: .left)
            vwMainArea.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        } else {
            lblErrorMsg.text = ""
            vwMainArea.backgroundColor = self.backgroundColor
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
