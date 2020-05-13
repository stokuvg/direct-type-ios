//
//  JobDetailSalaryExampleCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailSalaryExampleCell: BaseTableViewCell {
    
    @IBOutlet weak var borderView:UIView!
    @IBOutlet weak var examplesNameLabel:UILabel!
    @IBOutlet weak var examplesItemLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data:String) {
        examplesNameLabel.text(text: "給与例", fontType: .font_Sb, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        examplesItemLabel.text(text: data, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }
    
}
