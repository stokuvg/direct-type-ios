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
    var item: EditableItemH? = nil
    var delegate: InputItemHDelegate!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfValue: IKTextField!
    @IBOutlet weak var lblDebug: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func initCell(_ delegate: InputItemHDelegate, _ item: EditableItemH) {
        self.delegate = delegate
        self.item = item
        tfValue.itemKey = item.editableItemKey
    }
    
    func dispCell() {
        guard let _item = item else { return }
        let bufTitle = _item.dispName //_item.type.dispTitle
        lblTitle.text(text: bufTitle, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        let date: Date = DateHelper.convStr2Date(_item.curVal)
        tfValue.text = date.dispYmdJP()
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

