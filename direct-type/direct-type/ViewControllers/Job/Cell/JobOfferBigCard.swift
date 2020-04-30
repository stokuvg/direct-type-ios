//
//  JobOfferBigCard.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AlamofireImage

class JobOfferBigCard: BaseTableViewCell {
    
    @IBOutlet weak var spaceView:UIView!
    @IBOutlet weak var thumnailImageView:UIImageView!
    @IBOutlet weak var limitedMarkView:UIView!
    @IBOutlet weak var limitedLabel:UILabel!
    @IBOutlet weak var jobLabel:UILabel!
    @IBOutlet weak var saralyView:UIView!
    @IBOutlet weak var saralyLabel:UILabel!
    @IBOutlet weak var saralySpecialLabel:UILabel!
    @IBOutlet weak var saralySpecialMarkLabel:UILabel!
    @IBOutlet weak var saralyCationLabel:UILabel!
    
    @IBOutlet weak var areaView:UIView!
    @IBOutlet weak var areaLabel:UILabel!
    @IBOutlet weak var companyView:UIView!
    @IBOutlet weak var companyNameLabel:UILabel!
    @IBOutlet weak var catchLabel:UILabel!
    @IBOutlet weak var btnView:UIView!
    
    @IBOutlet weak var deleteBtn:UIButton!
    @IBOutlet weak var keepBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        spaceView.layer.cornerRadius = 15
        
        limitedLabel.text(text: "終了間近", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        
        // ボタン
        let shadowColor = UIColor.init(colorType: .color_black)
        spaceView.layer.shadowColor = shadowColor?.cgColor
        spaceView.shadowOpacity = 0.5
        spaceView.layer.shadowRadius = 10
        spaceView.shadowOffset = CGSize(width: 1.0, height: 3.0)
        
        let textColor:UIColor = UIColor.init(colorType: .color_line)!
        deleteBtn.titleLabel?.text(text: "見送り", fontType: .C_font_M, textColor: textColor, alignment: .center)
        deleteBtn.layer.cornerRadius = 15
        deleteBtn.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        keepBtn.layer.cornerRadius = 15
        keepBtn.layer.maskedCorners = [.layerMaxXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data:[String: Any]) {
        if data.count > 0 {
            
        }
    }
    
}
