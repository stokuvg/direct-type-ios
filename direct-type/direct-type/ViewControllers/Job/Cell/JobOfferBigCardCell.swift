//
//  JobOfferBigCardCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AlamofireImage

class JobOfferBigCardCell: BaseJobCardCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.init(colorType: .color_base)
        
        stackView.layer.cornerRadius = 15
        
        // サムネイル
        thumnailImageView.layer.cornerRadius = 15
        thumnailImageView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        limitedMarkView.cornerRadius = 5
        limitedLabel.text(text: "終了間近", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        
        btnView.layer.cornerRadius = 15
        btnView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
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
            let endFlag:Bool = (data["end"] as! Bool)
            if endFlag {
//                self.limitedMarkBackView.isHidden = true
                self.limitedMarkView.isHidden = true
                self.stackView.removeArrangedSubview(self.limitedMarkBackView)
            }
            
            let imageUrlString:String = (data["image"] as! String)
            thumnailImageView.af_setImage(withURL: URL(string: imageUrlString)!)
            
            let job:String = (data["job"] as! String)
            jobLabel.text(text: job, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            let price:String = (data["price"] as! String)
            let priceText = (price + "万円")
            saralyLabel.text(text: priceText, fontType: .C_font_M , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            //TODO:初回は非表示
            saralySpecialLabel.isHidden = true
            saralySpecialMarkLabel.isHidden = true
            cautionView.isHidden = true
            /*
            let special:String = (data["special"] as! String)
            if special.count > 0 && Int(special)! > 0 {
                saralySpecialLabel.text(text: special, fontType: .C_font_L , textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
                saralySpecialMarkLabel.text(text: "万円", fontType: .C_font_M , textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
                saralySpecialLabel.isHidden = true
                saralySpecialMarkLabel.isHidden = true
                saralyCautionLabel.text(text: "通常よりも", fontType: .C_font_S, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
            } else {
                cautionView.isHidden = true
                
                saralySpecialLabel.text(text: special, fontType: .C_font_M , textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
                saralySpecialLabel.isHidden = true
                saralySpecialMarkLabel.isHidden = true
            }
            */
            
            let area:String = (data["area"] as! String)
            areaLabel.text(text: area, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            let company:String = (data["company"] as! String)
            companyNameLabel.text(text: company, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            let main:String = (data["main"] as! String)
            catchLabel.text(text: main, fontType: .C_font_SS , textColor: UIColor.init(colorType: .color_parts_gray)!, alignment: .left)
        }
    }
    
}
