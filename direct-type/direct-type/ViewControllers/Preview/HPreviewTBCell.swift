//
//  HPreviewTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

typealias MdlItemHTypeKey = String //EditItemProtocol.itemKey
class MdlItemH {
    var type: HPreviewItemType = .undefine
    var value: String = ""
    var notice: String = ""
    var readonly: Bool = false
    var childItems: [EditableItemH] = []
    
    convenience init(_ type: HPreviewItemType, _ value: String, _ notice: String = "", readonly: Bool = false, childItems: [EditableItemH]) {
        self.init()
        self.type = type
        self.value = value
        self.notice = notice
        self.readonly = readonly
        self.childItems = childItems
    }
        
    var debugDisp: String {
        return "[\(type.dispTitle)] [\(value)]（\(childItems.count)件のサブ項目） [\(readonly ? "変更不可" : "")] [\(notice)]"
    }
}

class HPreviewTBCell: UITableViewCell {
    var item: MdlItemH? = nil
    var errMsg: String = ""
    var editTempCD: [EditableItemKey: EditableItemCurVal] = [:]
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblNotice: UILabel!
    @IBOutlet weak var lblErrorMsg: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initCell(_ item: MdlItemH, editTempCD: [EditableItemKey: EditableItemCurVal], errMsg: String) {
        self.item = item
        self.errMsg = errMsg
        self.editTempCD = editTempCD//表示だけに使用するため横流し
        if item.readonly {
            self.isUserInteractionEnabled = false
            self.accessoryType = .none
        } else {
            self.isUserInteractionEnabled = true
            self.accessoryType = .disclosureIndicator
        }
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
        let bufValue: String = dispCellValue(_item)
        let bufNotice: String = _item.notice
        //===表示させる
        lblTitle.text(text: bufTitle, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        if UITraitCollection.isDarkMode == true {
            lblValue.text(text: bufValue, fontType: .font_S, textColor: UIColor.init(colorType: .color_white)!, alignment: .left)
        } else {
            lblValue.text(text: bufValue, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        }
        lblNotice.text(text: bufNotice, fontType: .font_SS, textColor: UIColor.init(colorType: .color_parts_gray)!, alignment: .left)
        lblNotice.isHidden = (_item.notice == "") ? true : false
        //Validationエラー発生時の表示
        if errMsg != "" {
            lblErrorMsg.text = errMsg
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
