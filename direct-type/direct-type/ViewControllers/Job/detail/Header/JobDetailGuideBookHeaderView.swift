//
//  JobDetailGuideBookHeaderView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailGuideBookHeaderView: UIView {
    
    @IBOutlet weak var headerTitle:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        headerTitle.text(text: "募集要項", fontType: .font_M, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
    }

}
