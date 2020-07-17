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
    //var padding = UIEdgeInsets.zero
    let padding = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
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
    }
    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.height += ( padding.top + padding.bottom + 0 )
        intrinsicContentSize.width += ( padding.left + padding.right + 0 )
        return intrinsicContentSize
    }
}

typealias MdlItemHTypeKey = String //EditItemProtocol.itemKey
class MdlItemH {
    var type: HPreviewItemType = .undefine
    var value: String = ""
    var notice: String = ""
    var readonly: Bool = false
    var childItems: [EditableItemH] = []
    var model: Any? = nil
    
    convenience init(_ type: HPreviewItemType, _ value: String, _ notice: String = "", readonly: Bool = false, childItems: [EditableItemH], model: Any? = nil) {
        self.init()
        self.type = type
        self.value = value
        self.notice = notice
        self.readonly = readonly
        self.childItems = childItems
        self.model = model
    }
        
    var debugDisp: String {
        return "[\(type.dispTitle)] [\(value)]（\(childItems.count)件のサブ項目） [\(readonly ? "変更不可" : "")] [\(notice)] [\(model)]"
    }
}
