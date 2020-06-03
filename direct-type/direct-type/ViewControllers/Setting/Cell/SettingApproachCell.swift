//
//  SettingApproachCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/02.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class SettingApproachCell: BaseTableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var approachLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.text(text: "利用中のアプローチ", fontType: .font_Sb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data:[String:Any]) {
        var text:String = ""
        if data.count == 0 {
            text = "利用中のアプローチはありません"
        } else {
            let scountFlag = data["scount"] as! Bool
            let proFlag = data["pro"] as! Bool
            if scountFlag == false && proFlag == false {
                text = "利用中のアプローチはありません"
            } else if scountFlag == true && proFlag == true {
                text = "スカウト / プロのおすすめ"
            } else if scountFlag {
                text = "スカウト"
            } else if proFlag {
                text = "プロのおすすめ"
            }
        }
        approachLabel.text(text: text, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }
    
}
