//
//  JobDetailTextView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/19.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailTextView: UIView {
    
    @IBOutlet weak var textLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(data:String) {
        textLabel.text(text: data, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }

}
