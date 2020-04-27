//
//  UIFont+Extensions.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

// 使用文字タイプ(スタイル,サイズ,行間)
enum FontType {
    // 求人系以外
    case font_L
    case font_M
    case font_Sb
    case font_S
    case font_SSb
    case font_SS
    // 求人系
    case C_font_XL
    case C_font_L
    case C_font_M
    case C_font_Sb
    case C_font_S
    case C_font_SSb
    case C_font_SS
    case C_font_SSSb
    case C_font_SSS
    
    var lineSpacing:CGFloat {
        switch self {
            case .font_L:
                return 28
            case .font_M:
                return 24
            case .font_Sb:
                return 22
            case .font_S:
                return 16
            case .font_SSb:
                return 14
            case .font_SS:
                return 14
            case .C_font_XL:
                return 34
            case .C_font_L:
                return 28
            case .C_font_M:
                return 24
            case .C_font_Sb:
                return 22
            case .C_font_S:
                return 16
            case .C_font_SSb:
                return 14
            case .C_font_SS:
                return 22
            case .C_font_SSSb:
                return 16
            case .C_font_SSS:
                return 14
        }
    }
}

extension UIFont {
    
    convenience init?(fontType:FontType) {
        var fontName:String = ""
        var fontSize:CGFloat = 0.0
        
        switch fontType {
            case .font_L:
                fontName = "HiraginoSans-W6"
                fontSize = 24.0
            case .font_M:
                fontName = "HiraginoSans-W6"
                fontSize = 20.0
            case .font_Sb:
                fontName = "HiraginoSans-W6"
                fontSize = 14.0
            case .font_S:
                fontName = "HiraginoSans-W3"
                fontSize = 14.0
            case .font_SSb:
                fontName = "HiraginoSans-W6"
                fontSize = 11.0
            case .font_SS:
                fontName = "HiraginoSans-W3"
                fontSize = 11.0
            
            case .C_font_XL:
                fontName = "HiraginoSans-W6"
                fontSize = 30.0
            case .C_font_L:
                fontName = "HiraginoSans-W6"
                fontSize = 24.0
            case .C_font_M:
                fontName = "HiraginoSans-W6"
                fontSize = 18.0
            case .C_font_Sb:
                fontName = "HiraginoSans-W6"
                fontSize = 14.0
            case .C_font_S:
                fontName = "HiraginoSans-W3"
                fontSize = 14.0
            case .C_font_SSb:
                fontName = "HiraginoSans-W6"
                fontSize = 12.0
            case .C_font_SS:
                fontName = "HiraginoSans-W3"
                fontSize = 12.0
            case .C_font_SSSb:
                fontName = "HiraginoSans-W6"
                fontSize = 10.0
            case .C_font_SSS:
                fontName = "HiraginoSans-W3"
                fontSize = 10.0
        }
        
        self.init(name: fontName, size: fontSize)
    }
}
