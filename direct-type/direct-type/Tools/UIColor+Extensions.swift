//
//  UIColor+Extensions.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

// 色タイプ
enum ColorType {
    case color_main
    case color_sub
    case color_specialItemFocus
    case color_sub2
    case color_base
    case color_black
    case color_white
    case color_parts_gray
    case color_line
    case color_button
    case color_alart
    case color_close
    case color_light_gray
    case color_navy
}

extension UIColor {
    
    convenience init?(colorType:ColorType) {
        
        var colorName:String = ""
        switch colorType {
            case .color_main:
                colorName = "color-main"
            case .color_sub:
                colorName = "color-sub"
            case .color_specialItemFocus:
                colorName = "color-sub-half-alpha"
            case .color_sub2:
                colorName = "color-sub2"
            case .color_base:
                colorName = "color-base"
            case .color_black:
                colorName = "color-black"
            case .color_white:
                colorName = "color-white"
            case .color_parts_gray:
                colorName = "color-parts_gray"
            case .color_line:
                colorName = "color-line"
            case .color_button:
                colorName = "color-button"
            case .color_alart:
                colorName = "color-alart"
            case .color_close:
                colorName = "color-close"
            case .color_light_gray:
                colorName = "color-light-gray"
            case .color_navy:
                colorName = "color-navy"
        }
        
        self.init(named:colorName)
    }
}
