//
//  JobDetailBrowserView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailBrowserView: UIView {
    @IBOutlet weak var stackView:UIStackView!
    
    @IBOutlet weak var textView:UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(data:String) {
        
//        self.textView.text(text:data, fontType: .C_font_M ,textColor:UIColor(colorType: .color_black)!, alignment:.left)
        
        self.textView.text = data
    }

}
