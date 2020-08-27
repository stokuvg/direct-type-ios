//
//  JobDetailFoldingOptionalView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/18.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailFoldingOptionalView: UIView {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var itemLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(title:String,item:String) {
        self.titleLabel.text(text: title, fontType: .C_font_Sb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        
        self.itemLabel.text(text: item, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }

}
