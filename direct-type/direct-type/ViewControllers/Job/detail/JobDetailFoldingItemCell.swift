//
//  JobDetailFoldingItemCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

enum TextType {
    case text       // テキストのみ
    case step       // STEP表示あり
    case textLink   // ブラウザ遷移
    case headline   // 見出し表示あり
}

class JobDetailFoldingItemCell: BaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data:[String: Any], textType:TextType, flag:Bool) {
        Log.selectLog(logLevel: .debug, "JobDetailFoldingItemCell setup start")
        Log.selectLog(logLevel: .debug, "data:\(data)")
        if textType == .text {
            // テキストのみ
        } else if textType == .step {
            // STEPあり
        } else if textType == .textLink {
            let text = data["text"] as! String
            if text.count > 0 && flag == true {
                
                // ブラウザ遷移
                let browerView = UINib.init(nibName: "JobDetailBrowserView", bundle: nil)
                .instantiate(withOwner: self, options: nil)
                .first as! JobDetailBrowserView
                
                var frame = browerView.frame
                frame.origin.x = 15
                frame.size.width = (self.contentView.frame.size.width - (15 * 2))
                browerView.frame = frame
                
                browerView.setup(data: text)
                Log.selectLog(logLevel: .debug, "browserView:\(browerView)")
                
                self.addSubview(browerView)
            }
        } else if textType == .headline {
            // 見出しあり
        } else {
            // その他
        }
    }
    
}
