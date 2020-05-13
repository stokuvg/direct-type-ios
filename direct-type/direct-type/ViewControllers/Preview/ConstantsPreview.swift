//
//  ConstantsPreview.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

//選択されたTextFieldに被せているもの
class TargetAreaVW: UIView {
    override func draw(_ rect: CGRect) {
        UIColor(rgba: "#2e24").setStroke()
        UIColor(rgba: "#4f41").setFill()
        let rectangle = UIBezierPath(roundedRect: rect, cornerRadius: 8.0)
        rectangle.lineWidth = 3
//        rectangle.fill()
        rectangle.stroke()
    }
}

//EditableItemKeyを付与しておき、押下イベントで個別処理をできるように拡張しておく
class IKBarButtonItem: UIBarButtonItem {
    var parentPicker: Any? = nil//IKPickerView//IKDatePicker
}
class IKDatePicker: UIDatePicker {
    var itemKey: EditableItemKey = "<undefine>"
    var parentTF: IKTextField? = nil
}
class IKPickerView: UIPickerView {
    var itemKey: EditableItemKey = "<undefine>"
    var parentTF: IKTextField? = nil
}
class IKTextField: UITextField {
    var itemKey: EditableItemKey = "<undefine>"
}

enum HPreviewItemType {
    case undefine
    case fullname       //===４．氏名（必須）
    case birthGender    //===５．生年月日・性別（必須）
    case adderss        //===６．住所
    case email          //===７．メールアドレス
    case mobilephone    //===８．携帯電話番号

    var dispTitle: String {
        switch self {
        case .undefine:     return "<未定義>"
        case .fullname:     return "氏名"
        case .birthGender:  return "生年月日・性別"
        case .adderss:      return "住所"
        case .email:        return "メールアドレス"
        case .mobilephone:  return "アカウント（認証済み電話番号）"
        }
    }
}
