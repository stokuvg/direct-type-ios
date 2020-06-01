//
//  MyPageEditedChemistryCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class MyPageEditedChemistryCell: BaseTableViewCell {
    
    @IBOutlet weak var iconImageView:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var arImageView:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.text(text: "相性診断", fontType: .font_Sb, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
