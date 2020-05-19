//
//  HomeTitleView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/19.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class HomeTitleView: UIView {
    
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var titleLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let date = Date()
        let dateString = date.dispHomeDate()
        
        self.dateLabel.text(text: dateString, fontType: .font_SS, textColor: UIColor.init(colorType: .color_white)!, alignment: .left)
        
        self.titleLabel.text(text: "今日のおすすめ求人", fontType: .font_Sb, textColor: UIColor.init(colorType: .color_white)!, alignment: .left)
    }

}
