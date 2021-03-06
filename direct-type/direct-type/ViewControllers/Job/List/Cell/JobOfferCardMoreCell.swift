//
//  JobOfferCardMoreCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol JobOfferCardMoreCellDelegate {
    func moreDataAdd()
}

class JobOfferCardMoreCell: BaseTableViewCell {
    
    @IBOutlet weak var moreBtn:UIButton!
    @IBAction func moreBtnAction() {
        self.delegate.moreDataAdd()
    }
    
    var delegate:JobOfferCardMoreCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        deleteBtn.titleLabel?.text(text: "見送り", fontType: .C_font_M, textColor: textColor, alignment: .center)
        self.backgroundColor = UIColor.init(colorType: .color_base)
        
        moreBtn.setTitle("もっと見る", for: .normal)        
        moreBtn.setTitle(text: "もっと見る", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        moreBtn.backgroundColor = UIColor.init(colorType: .color_button)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
