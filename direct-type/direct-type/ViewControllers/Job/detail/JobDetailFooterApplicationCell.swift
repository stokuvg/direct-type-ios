//
//  JobDetailFooterApplicationCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/18.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailFooterApplicationCell: BaseTableViewCell {
    
    @IBOutlet weak var applicationBtn:UIButton!
    @IBAction func applicationBtnAction() {
        
    }
    
    @IBOutlet weak var keepBtn:UIButton!
    @IBAction func keepBtnAction() {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        applicationBtn.setTitle(text: "応募する", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        
        keepBtn.setTitle(text: "", fontType: .C_font_M, textColor: UIColor.clear, alignment: .center)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
