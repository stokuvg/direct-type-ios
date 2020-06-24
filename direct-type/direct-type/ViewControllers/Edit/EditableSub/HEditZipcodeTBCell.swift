//
//  HEditZipcodeTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/11.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class HEditZipcodeTBCell: UITableViewCell {
    var item: EditableItemH? = nil
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfValueZip3: IKTextField!
    @IBOutlet weak var tfValueZip4: IKTextField!
    @IBOutlet weak var lblDebug: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
    }

    func initCell(_ item: EditableItemH) {
        self.item = item
        tfValueZip3.clearButtonMode = .always //クリアボタンの表示制御
        tfValueZip4.clearButtonMode = .always //クリアボタンの表示制御
    }
    
    func dispCell() {
        guard let _item = item else { return }
        let bufTitle = _item.dispName //_item.type.dispTitle
        lblTitle.text(text: bufTitle, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_main)!, alignment: .left)
        let zipcode = _item.curVal.zeroUme(7)
        tfValueZip3.text = String.substr(zipcode, 1, 3)
        tfValueZip4.text = String.substr(zipcode, 4, 4)
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
