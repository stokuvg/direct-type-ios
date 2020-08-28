//
//  ExItemLabel.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/29.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class ExItemLabel: UILabel {
    var isReadonly: Bool = false
    private var fontType: FontType = .font_S //とりあえず標準サイズとしておく
    private var maxLabelSize: CGSize = CGSize.zero
//    let padding = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    let padding = UIEdgeInsets(top: 0, left: 120, bottom: 0, right: 120)

    func setProperties(fontType: FontType) {
        self.fontType = fontType
    }
    override func layoutSubviews() {
        self.maxLabelSize = CGSize(width: self.bounds.width, height: .greatestFiniteMagnitude)
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
    override func drawText(in rect: CGRect) {
        let rectTmp = rect.inset(by: padding)
        let rectangle = UIBezierPath(roundedRect: rect, cornerRadius: 6)
        UIColor(colorType: .color_white)!.setFill()
        UIColor(colorType: .color_line)!.setStroke()
        if isReadonly {
            //rectangle.fill()
            rectangle.stroke()
        } else {
            rectangle.fill()
            rectangle.stroke()
        }
        super.drawText(in: rectTmp)
//        //===処理確認用の枠線表示
        let rectangleTmp = UIBezierPath(roundedRect: rectTmp, cornerRadius: 4)
        UIColor.red.setStroke()
        rectangleTmp.stroke()
    }
    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = CGSize.zero
        let maxWidth: CGFloat = floor(maxLabelSize.width) - padding.left - padding.right
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.defaultTabInterval = 0
        paragraphStyle.baseWritingDirection = .natural
        paragraphStyle.hyphenationFactor = 0
        paragraphStyle.allowsDefaultTighteningForTruncation = false
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = fontType.lineSpacing
        if let _paragraphSpacing = fontType.paragraphSpacing {//行間とは別に段落間の余白を設定する
            paragraphStyle.paragraphSpacing = _paragraphSpacing
        }
        paragraphStyle.lineBreakMode = .byCharWrapping
        let attributes: [NSAttributedString.Key: Any] = [
        .font : UIFont(fontType: fontType) as Any,
        .paragraphStyle: paragraphStyle,
        ]
        let textArea = text?.makeSize(width: maxWidth, attributes: attributes) ?? CGSize.zero
        intrinsicContentSize.width = maxWidth + ( padding.left + padding.right )
        intrinsicContentSize.height = textArea.height + ( padding.top + padding.bottom )
 
        return intrinsicContentSize
    }
}
extension String {
    func makeSize(width: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGSize {
        let bounds = CGSize(width: width, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, ]
        let rect = self.boundingRect(with: bounds, options: options, attributes: attributes, context: nil)
        let size = CGSize(width: ceil(rect.size.width), height: ceil(rect.size.height))
        return size
    }
}

typealias MdlItemHTypeKey = String //EditItemProtocol.itemKey
class MdlItemH {
    var type: HPreviewItemType = .undefine
    var value: String = ""
    var notice: String = ""
    var readonly: Bool = false
    var childItems: [EditableItemH] = []
    var exModel: Any? = nil   //拡張情報
    
    convenience init(_ type: HPreviewItemType, _ value: String, _ notice: String = "", readonly: Bool = false, childItems: [EditableItemH], model: Any? = nil) {
        self.init()
        self.type = type
        self.value = value
        self.notice = notice
        self.readonly = readonly
        self.childItems = childItems
        self.exModel = model
    }
        
    var debugDisp: String {
        return "[\(type.dispTitle)] [\(value)]（\(childItems.count)件のサブ項目） [\(readonly ? "変更不可" : "")] [\(notice)] [\(exModel)]"
    }
}
