//
//  TudTool.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/09/04.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

/// iOS 14機能　StackMene を無効にする
///
/// * 画面遷移の都合上、ページ遷移をスキップすると崩れるためそれの防止
@available(iOS 14.0, *)
class DisabledStackMenuBarButtonItem: UIBarButtonItem {
    override var menu: UIMenu? {
        set { }
        get {
            return nil
        }
    }
}

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
