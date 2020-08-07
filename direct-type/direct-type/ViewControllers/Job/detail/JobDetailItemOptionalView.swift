//
//  JobDetailItemOptionalView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailItemOptionalView: UIView {
    
    @IBOutlet weak var optionalStackView:UIStackView!
    @IBOutlet weak var titleView:UIView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var itemView:UIView!
    @IBOutlet weak var itemLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(datas:[String:Any]) {
        let title = datas["title"] as! String
        titleLabel.text(text: title, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        
        let text = datas["text"] as! String
        itemLabel.text(text: text, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }

}
