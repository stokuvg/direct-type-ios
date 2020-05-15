//
//  JobDetailFoldingPhoneNumberCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailFoldingPhoneNumberCell: BaseTableViewCell {
    
    @IBOutlet weak var textView:UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textView.textColor = UIColor.init(colorType: .color_black)
        self.textView.font = UIFont.init(fontType: .C_font_S)
        self.textView.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init(colorType: .color_sub) as Any
        ]
        self.textView.dataDetectorTypes = .all
        self.textView.delegate = self
        
        self.textView.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: [String: Any]) {
        let text = data["text"] as! String
//        self.textView.text = text

        let attributedString = NSMutableAttributedString(string: text)

        let range = attributedString.mutableString.range(of: "http://www.systemsoft.co.jp/")
//        attributedString.setAttributes([.underlineStyle : NSUnderlineStyle.single.rawValue, .link: URL(string: "https://www.yahoo.co.jp/")!, .foregroundColor: UIColor.white, .paragraphStyle: style,], range: range)

        attributedString.addAttribute(.link,
        value: "https://www.google.co.jp/",
        range: range)
        
        self.textView.attributedText = attributedString
    }
    
}

extension JobDetailFoldingPhoneNumberCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        Log.selectLog(logLevel: .debug, "JobDetailFoldingPhoneNumberCell shouldInteractWith start")
        
        Log.selectLog(logLevel: .debug, "URL:\(URL)")
        
        return false
    }
}
