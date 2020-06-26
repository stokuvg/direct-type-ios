//
//  JobDetailItemAttentionView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailItemAttentionView: UIView {
    
    @IBOutlet weak var titleBackHeight:NSLayoutConstraint!
    @IBOutlet weak var markTopConstraint:NSLayoutConstraint!
    @IBOutlet weak var markLabel:UILabel!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var titleLabelTop:NSLayoutConstraint!
    @IBOutlet weak var titleLabelHeight:NSLayoutConstraint!
    @IBOutlet weak var textLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.markLabel.text(text: "注 目", fontType: .C_font_Sb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }
    
    func setup(datas:[String:Any]) {
        let title = datas["title"] as! String
        Log.selectLog(logLevel: .debug, "title:\(title)")
        
        let titleFont:FontType = .font_Sb
        
        titleLabel.text(text: title, fontType: titleFont, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        
        let singleWidth = self.titleLabel.frame.size.width
        let textSize = CGFloat(title.count * 14)
        
        Log.selectLog(logLevel: .debug, "singleWidth:\(singleWidth)")
        Log.selectLog(logLevel: .debug, "textSize:\(textSize)")
        
        if textSize > (singleWidth+5) {
            markTopConstraint.constant = 9
            titleLabelTop.constant = 1
            titleLabelHeight.constant = 50
            titleBackHeight.constant = 60
        }
        
        let text = datas["text"] as! String
        textLabel.text(text: text, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }

}
