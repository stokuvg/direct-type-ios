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
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var lblDebug: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func initCell(_ item: EditableItemH) {
        self.item = item
    }
    
    func dispCell() {
        guard let _item = item else { return }
        let bufTitle = _item.dispName //_item.type.dispTitle
        lblTitle.text(text: bufTitle, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        tfValue.text = _item.curVal
        
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
