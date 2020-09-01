//
//  JobDetailFoldingHeaderCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/08/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailFoldingHeaderCell: BaseTableViewCell {
    
    @IBOutlet weak var headerView:UIView!
    
    @IBOutlet weak var topLineView:UIView!
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var foldingMarkLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(title: String, openFlag:Bool) {
//        Log.selectLog(logLevel: .debug, "JobDetailFoldingHeaderCell setup start")
        
//        Log.selectLog(logLevel: .debug, "openFlag:\(openFlag)")
        
        self.titleLabel.text(text: title, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        let flagText:String = openFlag ? "-" : "+"
        self.foldingMarkLabel.text(text: flagText, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
    }
    
}
