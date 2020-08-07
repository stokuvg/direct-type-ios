//
//  MyPageSettingCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class MyPageSettingCell: BaseTableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rightImage:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.init(colorType: .color_white)
        title.text(text: "設定", fontType: .font_Sb, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
