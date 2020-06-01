//
//  MyPageNameCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class MyPageNameCell: BaseTableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var editBtn:UIButton!
    @IBAction func editBtnAction() {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.text(text: "ゲストさん", fontType: .C_font_L, textColor: UIColor.init(colorType: .color_black)!, alignment: .right)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
