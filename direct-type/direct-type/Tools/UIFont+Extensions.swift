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
    // 応募フォーム
    case E_font_Mb
    case E_font_Sb
    case E_font_SSb
    case E_font_M
    case E_font_S
    case E_font_SS
    case E_font_Status
    // 応募確認
    case EC_font_Info
    case EC_font_Notice
    // プレビュー
    case PV_font_S
    // 求人系以外
    case font_XL
    case font_L
    case font_M
    case font_Sb
    case font_S
    case font_SSb
    case font_SS
    case font_SSSb
    case font_SSS
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
    // タグ系
    case Tag_font_SS
    
    var lineSpacing:CGFloat {
        switch self {
            case .E_font_M, .E_font_Mb:
                return 4
            case .E_font_S, .E_font_Sb:
                return 4
            case .E_font_SS, .E_font_SSb:
                return 4
            case .E_font_Status:
                return 3
            case .EC_font_Info:
                return 9
            case .EC_font_Notice:
                return 9
            case .PV_font_S:
                return 6
            case .font_XL:
                return 4
            case .font_L:
                return 4
            case .font_M:
                return 4
            case .font_Sb:
                return 8
            case .font_S:
                return 2
            case .font_SSb:
                return 3
            case .font_SS:
                return 3
            case .font_SSSb:
                return 4
            case .font_SSS:
                return 4
            case .C_font_XL:
                return 4
            case .C_font_L:
                return 4
            case .C_font_M:
                return 9
            case .C_font_Sb:
                return 8
            case .C_font_S:
                return 7
            case .C_font_SSb:
                return 2
            case .C_font_SS:
                return 10
            case .C_font_SSSb:
                return 6
            case .C_font_SSS:
                return 4
            case .Tag_font_SS:
                return 2
        }
    }
    var paragraphSpacing: CGFloat? {
        switch self {
        case .PV_font_S:
            return 8
        default:
            return nil
        }
    }
}

extension UIFont {
    
    convenience init?(fontType:FontType) {
        var fontName:String = ""
        var fontSize:CGFloat = 0.0
        
        switch fontType {
            case .E_font_Mb:
                fontName = "HiraginoSans-W6"
                fontSize = 18.0
            case .E_font_Sb:
                fontName = "HiraginoSans-W6"
                fontSize = 16.0
            case .E_font_SSb:
                fontName = "HiraginoSans-W6"
                fontSize = 12.0
            case .E_font_M:
                fontName = "HiraginoSans-W3"
                fontSize = 18.0
            case .E_font_S:
                fontName = "HiraginoSans-W3"
                fontSize = 16.0
            case .E_font_SS:
                fontName = "HiraginoSans-W3"
                fontSize = 12.0
            case .E_font_Status:
                fontName = "HiraginoSans-W3"
                fontSize = 8.0
            case .EC_font_Info:
                fontName = "HiraginoSans-W3"
                fontSize = 14.0
            case .EC_font_Notice:
                fontName = "HiraginoSans-W3"
                fontSize = 12.0
            case .PV_font_S:
                fontName = "HiraginoSans-W3"
                fontSize = 14.0
            case .font_XL:
                fontName = "HiraginoSans-W6"
                fontSize = 30.0
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
            case .font_SSSb:
                fontName = "HiraginoSans-W6"
                fontSize = 10.0
            case .font_SSS:
                fontName = "HiraginoSans-W3"
                fontSize = 10.0
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
            case .Tag_font_SS:
                fontName = "HiraginoSans-W3"
                fontSize = 11.0
        }
        
        self.init(name: fontName, size: fontSize)
    }
}
