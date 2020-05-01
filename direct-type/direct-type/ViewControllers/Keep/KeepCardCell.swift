//
//  KeepCardCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class KeepCardCell: BaseJobCardCell {
    
    @IBOutlet weak var unitLabel:UILabel!
    @IBOutlet weak var keepActionBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // サムネイル
        thumnailImageView.layer.cornerRadius = 15
        thumnailImageView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        // 終了間近
        limitedLabel.text(text: "終了間近", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data:[String:Any]) {
        
        if data.count > 0 {
            // 終了間近
            let endFlag:Bool = (data["end"] as! Bool)
            if endFlag {
                self.limitedLabel.isHidden = true
            }
            // 職種名
            let job:String = (data["job"] as! String)
            jobLabel.text(text: job, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            // サムネイル
            let imageUrlString:String = (data["image"] as! String)
            thumnailImageView.af_setImage(withURL: URL(string: imageUrlString)!)
            
            // 給与金額
            let price:String = (data["price"] as! String)
            saralyLabel.adjustsFontSizeToFitWidth = true
            saralyLabel.text(text: price, fontType: .C_font_M , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            // 単位
            unitLabel.text(text: "万円", fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            // 勤務地
            let area:String = (data["area"] as! String)
            areaLabel.text(text: area, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            // 社名
            let company:String = (data["company"] as! String)
            companyNameLabel.text(text: company, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
        }
    }
    
}
