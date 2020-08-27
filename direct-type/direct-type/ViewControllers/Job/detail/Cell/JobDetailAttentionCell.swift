//
//  JobDetailAttentionCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/08/17.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailAttentionCell: BaseTableViewCell {
    
    @IBOutlet weak var titleView:UIView!
    @IBOutlet weak var titleBackHeight:NSLayoutConstraint!
    @IBOutlet weak var markTopConstraint:NSLayoutConstraint!
    @IBOutlet weak var markImageView:UIImageView!
    @IBOutlet weak var attentionTitle:UILabel!
    @IBOutlet weak var titleLabelTop:NSLayoutConstraint!
    @IBOutlet weak var titleLabelHeight:NSLayoutConstraint!
    @IBOutlet weak var attentionText:UILabel!
    
    @IBOutlet weak var bottomSpaceHeight:NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceView:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.attentionTitle.backgroundColor = UIColor.init(colorType: .color_button)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    func setup(title: String, text: String, bottomSpaceFlag:Bool) {
//        Log.selectLog(logLevel: .debug, "JobDetailAttentionCell setup start")
//        Log.selectLog(logLevel: .debug, "title:\(title)")
        
        let titleFont:FontType = .font_Sb
        
        let attentionBackView = self
//        Log.selectLog(logLevel: .debug, "attentionBackView:\(attentionBackView)")
        
        let labelSpace = (self.titleView.frame.size.width - (self.markImageView.bounds.origin.x + self.markImageView.bounds.size.width)) - (15 + 10)
//        Log.selectLog(logLevel: .debug, "labelSpace:\(labelSpace)")
        
        let singleWidth = self.attentionTitle.frame.size.width
//        Log.selectLog(logLevel: .debug, "singleWidth:\(singleWidth)")
        
        let textSize = CGFloat(title.count * 14)
//        Log.selectLog(logLevel: .debug, "textSize:\(textSize)")
        
        if textSize > labelSpace || textSize > singleWidth {
//            Log.selectLog(logLevel: .debug, "注目タイトルが２行以上")
//            markTopConstraint.constant = 9
            titleLabelTop.constant = 4
            titleLabelHeight.constant = 40
            titleBackHeight.constant = 60
        } else {
//            Log.selectLog(logLevel: .debug, "注目タイトルが1行以上")
            titleLabelTop.constant = 6
            titleLabelHeight.constant = 16
            titleBackHeight.constant = 28
        }
        // 注目 タイトル
        self.attentionTitle.clipText(text: title, fontType: titleFont, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left, type: .byCharWrapping)
        
        // 注目 テキスト
        self.attentionText.text(text: text, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        if bottomSpaceFlag {
            self.bottomSpaceHeight.constant = 15
            self.bottomSpaceView.backgroundColor = UIColor.init(colorType: .color_base)
        } else {
            self.bottomSpaceHeight.constant = 0
            self.bottomSpaceView.backgroundColor = UIColor.init(colorType: .color_white)
        }
    }
    
}
