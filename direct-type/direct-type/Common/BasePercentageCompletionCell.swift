//
//  BasePercentageCompletionCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol BasePercentageCompletionCellDelegate: class {
    func completionEditAction(sender: BaseTableViewCell)
}

class BasePercentageCompletionCell: BaseTableViewCell {
    @IBOutlet private weak var stackView:UIStackView!
    @IBOutlet private weak var titleLabel:UILabel!
    @IBOutlet private weak var percentLabel:UILabel!
    @IBOutlet private weak var percentMark:UILabel!
    @IBOutlet private weak var percentProgress:UIProgressView!
    @IBOutlet private weak var editBtn:UIButton!
    @IBAction private func editBtnAction() {
        delegate?.completionEditAction(sender: self)
    }
    
    var delegate: BasePercentageCompletionCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        percentMark.text(text: "%", fontType: .font_SSb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        editBtn.isUserInteractionEnabled = false //セル全体で反応させるため、ボタンUI無効化した
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup(title: String, percent: String) {
        titleLabel.text(text: title, fontType: .font_Sb, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        percentLabel.text(text: percent, fontType: .font_Sb, textColor: UIColor(colorType: .color_sub)!, alignment: .left)
        
        let intPercent = Int(percent)
        let percentFloat = Float(intPercent!) / 100
        
        percentProgress.progress = percentFloat
    }
}
