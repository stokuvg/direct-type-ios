//
//  JobDetailWorkAttentionCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/08/17.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailWorkAttentionCell: BaseTableViewCell {
    
    @IBOutlet weak var titleBackHeight:NSLayoutConstraint!
    @IBOutlet weak var markTopConstraint:NSLayoutConstraint!
    @IBOutlet weak var markImageView:UIImageView!
    @IBOutlet weak var attentionTitle:UILabel!
    @IBOutlet weak var titleLabelTop:NSLayoutConstraint!
    @IBOutlet weak var titleLabelHeight:NSLayoutConstraint!
    @IBOutlet weak var attentionText:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Log.selectLog(logLevel: .debug, "JobDetailWorkAttentionCell awakeFromNib start")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(title: String, text: String) {
        Log.selectLog(logLevel: .debug, "title:\(title)")
        
        let titleFont:FontType = .font_Sb
        
        self.attentionTitle.text(text: title, fontType: titleFont, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        
        let attentionBackView = self
//        Log.selectLog(logLevel: .debug, "attentionBackView:\(attentionBackView)")
        
        let labelSpace = (attentionBackView.frame.size.width - (self.markImageView.bounds.origin.x + self.markImageView.bounds.size.width)) - (15 + 10)
        Log.selectLog(logLevel: .debug, "labelSpace:\(labelSpace)")
        
//        let singleWidth = self.titleLabel.frame.size.width
        let textSize = CGFloat(title.count * 14)
        
//        Log.selectLog(logLevel: .debug, "singleWidth:\(singleWidth)")
//        Log.selectLog(logLevel: .debug, "textSize:\(textSize)")
        
        if textSize >= labelSpace {
            Log.selectLog(logLevel: .debug, "注目タイトルが２行以上")
//            markTopConstraint.constant = 9
            titleLabelTop.constant = 0
            titleLabelHeight.constant = 50
            titleBackHeight.constant = 60
        } else {
            Log.selectLog(logLevel: .debug, "注目タイトルが1行以上")
        }
        
        self.attentionText.text(text: text, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }
}
