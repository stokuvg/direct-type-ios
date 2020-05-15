//
//  JobDetailFoldingHeaderView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailFoldingHeaderView: BaseFoldingHeaderView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(title: String, openFlag:Bool) {
        Log.selectLog(logLevel: .debug, "JobDetailFoldingHeaderView setup start")
        
//        Log.selectLog(logLevel: .debug, "openFlag:\(openFlag)")
        
        self.titleLabel.text(text: title, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        let flagText:String = openFlag ? "-" : "+"
        self.foldingMarkLabel.text(text: flagText, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
    }

}
