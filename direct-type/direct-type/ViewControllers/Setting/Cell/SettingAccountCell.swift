//
//  SettingAccountCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/02.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class SettingAccountCell: BaseTableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var telNoLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.text(text: "アカウント（認証済み電話番号）", fontType: .font_Sb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
<<<<<<< HEAD
        //初期表示（ゴミ表示をなくす）
        telNoLabel.text = ""
=======
        telNoLabel.text(text: "------------", fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
>>>>>>> feature/h_mypage_statusbar_2020071701
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(telNo:String) {
        telNoLabel.text(text: telNo, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }
    
}
