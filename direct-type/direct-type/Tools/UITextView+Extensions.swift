//
//  UITextView+Extensions.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension UITextView {
    
    func text(text:String,fontType:FontType,textColor:UIColor, alignment:NSTextAlignment) {
        var attributes:[NSAttributedString.Key:Any] = [:]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        let textFont = UIFont.init(fontType: fontType)
        
        attributes = [
            .foregroundColor: textColor,
            .font: textFont as Any,
        ]
        paragraphStyle.lineSpacing = fontType.lineSpacing
        attributes.updateValue(paragraphStyle, forKey: .paragraphStyle)
        
        let attrText = NSAttributedString(string: text, attributes: attributes)
        
        self.accessibilityAttributedLabel = attrText
    }

}
