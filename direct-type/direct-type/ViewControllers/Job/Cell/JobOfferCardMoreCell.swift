//
//  JobOfferCardMoreCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobOfferCardMoreCell: BaseTableViewCell {
    
    @IBOutlet weak var moreBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        deleteBtn.titleLabel?.text(text: "見送り", fontType: .C_font_M, textColor: textColor, alignment: .center)
        
        moreBtn.setTitle("もっと見る", for: .normal)
        
        moreBtn.setTitle(text: "もっと見る", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        moreBtn.backgroundColor = UIColor.init(colorType: .color_sub)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
