//
//  JobDetailWorkCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailWorkCell: BaseJobDetailCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data:[String:Any]) {
        Log.selectLog(logLevel: .debug, "JobDetailWorkCell setup start")
        
//        Log.selectLog(logLevel: .debug, "data:\(data)")
        let title = data["title"] as! String
        titleLabel.text(text: title, fontType: .font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        let indispensableText = data["indispensable"] as! String
        self.indispensableLabel.text(text: indispensableText, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }
    
}
