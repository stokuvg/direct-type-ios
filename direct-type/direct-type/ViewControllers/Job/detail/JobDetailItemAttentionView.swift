//
//  JobDetailItemAttentionView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailItemAttentionView: UIView {
    
    @IBOutlet weak var markLabel:UILabel!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var textLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.markLabel.text(text: "注 目", fontType: .C_font_Sb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }
    
    func setup(datas:[String:Any]) {
        let title = datas["title"] as! String
        titleLabel.text(text: title, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        
        let text = datas["text"] as! String
        textLabel.text(text: text, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }

}
