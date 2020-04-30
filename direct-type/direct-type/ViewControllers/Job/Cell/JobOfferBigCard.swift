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
    @IBOutlet weak var stackView:UIStackView!
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
            let job:String = (data["job"] as! String)
            jobLabel.text(text: job, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            let price:String = (data["price"] as! String)
            let priceText = (price + "万円")
            saralyLabel.text(text: priceText, fontType: .C_font_M , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            let special:String = (data["special"] as! String)
            if special.count > 0 {
                saralySpecialLabel.text(text: special, fontType: .C_font_M , textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
                saralySpecialMarkLabel.text(text: "万円", fontType: .C_font_L , textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
                saralySpecialLabel.isHidden = false
                saralySpecialMarkLabel.isHidden = false
            } else {
                saralySpecialLabel.text(text: special, fontType: .C_font_M , textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
                saralySpecialLabel.isHidden = true
                saralySpecialMarkLabel.isHidden = true
            }
            
            let area:String = (data["area"] as! String)
            areaLabel.text(text: area, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            let company:String = (data["company"] as! String)
            companyNameLabel.text(text: company, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            let main:String = (data["main"] as! String)
            catchLabel.text(text: main, fontType: .C_font_SS , textColor: UIColor.init(colorType: .color_parts_gray)!, alignment: .left)
        }
    }
    
}
