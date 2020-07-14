//
//  EntryFormExQuestionsItemTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/29.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class EntryFormExQuestionsItemTBCell: UITableViewCell {
    var item: MdlItemH? = nil
    var errMsg: String = ""
    var editTempCD: [EditableItemKey: EditableItemCurVal] = [:]
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var vwQuestionArea: UIView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var vwAnswerArea: UIView!
    @IBOutlet weak var lblAnswaer: ExItemLabel!
    @IBOutlet weak var lblErrorMsg: UILabel!
    @IBOutlet weak var vwCountArea: UIView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblCountMax: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initCell(_ item: MdlItemH, editTempCD: [EditableItemKey: EditableItemCurVal], errMsg: String) {
        self.item = item
        self.errMsg = errMsg
        self.editTempCD = editTempCD//表示だけに使用するため横流し
        self.isUserInteractionEnabled = true
        self.accessoryType = .none // .disclosureIndicator 遷移マーク不要
    }
    func dispCell() {
        guard let _item = self.item else { return }
        //子項目に値を適用させておく必要ありだ
        for (n, item) in _item.childItems.enumerated() {
            if let temp = editTempCD[item.editableItemKey] {
                _item.childItems[n].curVal = temp
            }
        }
        guard let _child = self.item?.childItems.first else { return }
        let question: String = _item.value//設問は包んでるモデルの値に入れて渡しているので
        let answer: String = _child.curVal
        let cnt: Int = answer.count
        let max: Int = _child.editItem.valid.max ?? 0
        lblQuestion.text(text: question, fontType: .font_S, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        if answer.isEmpty {
            lblAnswaer.text(text: _child.placeholder, fontType: .font_S, textColor: UIColor(colorType: .color_line)!, alignment: .left)
        } else {
            lblAnswaer.text(text: answer, fontType: .font_S, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        }
        if max > 0 { //文字数制限が設定されている場合
            lblCount.text(text: "\(cnt)", fontType: .font_SSb, textColor: UIColor(colorType: .color_parts_gray)!, alignment: .left)
            lblCountMax.text(text: "文字 / \(max)字以内", fontType: .font_SSb, textColor: UIColor(colorType: .color_parts_gray)!, alignment: .left)
        } else {
            lblCount.text = nil
            lblCountMax.text = nil
        }
        //Validationエラー発生時の表示
        if errMsg != "" {
            //lblErrorMsg.text = errMsg
            lblErrorMsg.text(text: errMsg, fontType: .font_SS, textColor: UIColor(colorType: .color_sub)!, alignment: .left)
            lblErrorMsg.text = errMsg
            vwMainArea.backgroundColor = UIColor.init(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        } else {
            lblErrorMsg.text = ""
            vwMainArea.backgroundColor = self.backgroundColor
        }
    }

}




