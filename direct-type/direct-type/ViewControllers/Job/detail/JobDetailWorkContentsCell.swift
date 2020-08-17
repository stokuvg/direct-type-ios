//
//  JobDetailWorkContentsCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/08/17.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient
import TudApi

class JobDetailWorkContentsCell: BaseJobDetailCell {
    
    @IBOutlet weak var bottomSpace:NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup(data: MdlJobCardDetail) {
        let title = "仕事内容"
        let text = data.jobDescription
        titleLabel.text(text: title, fontType: .font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        self.indispensableLabel.text(text: text, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        let spotTitle1 = data.spotTitle1
        let spotDetail1 = data.spotDetail1
        
        let spotTitle2 = data.spotTitle2
        let spotDetail2 = data.spotDetail2
        
        // 注目1,注目２が両方とも無い
        if (spotTitle1.count == 0 || spotDetail1.count == 0) && (spotTitle2.count == 0 || spotDetail2.count == 0) {
            bottomSpace.constant = 15
        } else {
            bottomSpace.constant = 0
        }
    }
    
}
