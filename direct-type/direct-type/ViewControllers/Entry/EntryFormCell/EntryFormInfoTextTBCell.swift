//
//  EntryFormInfoTextTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/29.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class EntryFormInfoTextTBCell: UITableViewCell {
    var title: String = ""
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var vwTitleArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = false //表示のみでタップ不可
        //===デザイン適用
        selectionStyle = .none
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)
        vwTitleArea.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initCell(title: String) {
        self.title = title
    }
    func dispCell() {
        lblTitle.text(text: title, fontType: .E_font_S, textColor: UIColor(colorType: .color_black)!, alignment: .center)
    }
}
