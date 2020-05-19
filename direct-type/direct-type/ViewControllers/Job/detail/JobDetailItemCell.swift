//
//  JobDetailItemCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailItemCell: BaseJobDetailCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for subView in self.itemStackView.subviews {
            if subView is JobDetailItemOptionalView {
                subView.removeFromSuperview()
            } else if subView is JobDetailItemAttentionView {
                subView.removeFromSuperview()
            }
        }
    }
    
    func setup(data:[String:Any]) {
//        Log.selectLog(logLevel: .debug, "JobDetailItemCell setup start")
        
//        Log.selectLog(logLevel: .debug, "data:\(data)")
        let title = data["title"] as! String
        titleLabel.text(text: title, fontType: .font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        let indispensableText = data["indispensable"] as! String
        self.indispensableLabel.text(text: indispensableText, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        /*
        let optional = data["optional"] as! [[String:Any]]
        if optional.count > 0 {
            let optionalFrameWidth = self.itemBackView.frame.size.width
            for i in 0..<optional.count {
                let optionalView = UINib.init(nibName: "JobDetailItemOptionalView", bundle: nil)
                .instantiate(withOwner: self, options: nil)
                .first as! JobDetailItemOptionalView
                
                var viewFrame = optionalView.frame
                viewFrame.size.width = optionalFrameWidth
                optionalView.frame = viewFrame
                
                optionalView.tag = (i+1)
                
                let optionalData = optional[i]
                optionalView.setup(datas: optionalData)
                
                self.itemStackView.addArrangedSubview(optionalView)
            }
        }
        
        let attention = data["attention"] as! [[String:Any]]
        if attention.count > 0 {
            let attentionFrameWidth = self.itemBackView.frame.size.width
            for i in 0..<attention.count {
                let attentionView = UINib.init(nibName: "JobDetailItemAttentionView", bundle: nil)
                .instantiate(withOwner: self, options: nil)
                .first as! JobDetailItemAttentionView
                
                var viewFrame = attentionView.frame
                viewFrame.size.width = attentionFrameWidth
                attentionView.frame = viewFrame
                
                attentionView.tag = (i+1)
                
                let attentionData = attention[i]
                attentionView.setup(datas: attentionData)
                
                self.itemStackView.addArrangedSubview(attentionView)
            }
        }
        */
        
    }
}
