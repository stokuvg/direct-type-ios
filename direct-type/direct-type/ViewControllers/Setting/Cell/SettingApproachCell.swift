//
//  SettingApproachCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/02.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class SettingApproachCell: BaseTableViewCell {
    
    @IBOutlet private weak var titleLabel:UILabel!
    @IBOutlet private weak var scoutLabel: UILabel!
    @IBOutlet private weak var perLabel: UILabel!
    @IBOutlet private weak var recommendLabel: UILabel!
    @IBOutlet private weak var notInUseApproachLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func configure(with data: MdlApproach) {
        scoutLabel.isHidden = !data.isScoutEnable
        perLabel.isHidden = true
        recommendLabel.isHidden = true
        notInUseApproachLabel.isHidden = data.isScoutEnable
    }
}

private extension SettingApproachCell {
    func setup() {
        titleLabel.text(text: "利用中のアプローチ", fontType: .font_Sb,
                        textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        
        [scoutLabel, perLabel, recommendLabel, notInUseApproachLabel].forEach({ label in
            guard let label = label else { return }
            label.textColor = UIColor(colorType: .color_black)
            label.font = UIFont(fontType: .font_S)
        })
    }
}
