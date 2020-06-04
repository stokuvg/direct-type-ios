//
//  SettingBaseCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/02.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class SettingBaseCell: BaseTableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(title:String) {
        self.titleLabel.text(text: title, fontType: .font_S, textColor: UIColor.init(colorType: .color_parts_gray)!, alignment: .left)
    }
    
}
