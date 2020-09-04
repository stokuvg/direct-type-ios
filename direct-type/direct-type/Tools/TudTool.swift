//
//  TudTool.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/09/04.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class TudTool {
    class func attrText(text: String, fontType: FontType, textColor: UIColor, alignment: NSTextAlignment, lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> NSAttributedString {
        let textFont = UIFont(fontType: fontType)
        var attributes:[NSAttributedString.Key: Any] = [:]
        attributes = [
            .foregroundColor: textColor,
            .font: textFont as Any,
        ]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.lineSpacing = fontType.lineSpacing
        if let _paragraphSpacing = fontType.paragraphSpacing {//行間とは別に段落間の余白を設定する
            paragraphStyle.paragraphSpacing = _paragraphSpacing
        }
        attributes.updateValue(paragraphStyle, forKey: .paragraphStyle)
        let attrText = NSAttributedString(string: text, attributes: attributes)
        return attrText
    }
}
