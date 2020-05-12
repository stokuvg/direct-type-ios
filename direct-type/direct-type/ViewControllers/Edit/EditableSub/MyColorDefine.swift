//
//  MyColorDefine.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/03/30.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

//=== Darkモードか調べる（iOS13未満なら常にfalse）
extension UITraitCollection {
    public static var isDarkMode: Bool {
        if #available(iOS 13, *), current.userInterfaceStyle == .dark {
            return true
        }
        return false
    }
}
//=== Colorref値で色定義
extension UIColor {
    convenience init(rgba: String) {
        var r: CGFloat = 1.0
        var g: CGFloat = 1.0
        var b: CGFloat = 1.0
        var a: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            if rgba.count >= 7 {
                r = CGFloat(Int(String.substr(rgba, 2, 2), radix: 16) ?? 0xff) / CGFloat(0xff)
                g = CGFloat(Int(String.substr(rgba, 4, 2), radix: 16) ?? 0xff) / CGFloat(0xff)
                b = CGFloat(Int(String.substr(rgba, 6, 2), radix: 16) ?? 0xff) / CGFloat(0xff)
                if rgba.count >= 9 {
                    a = CGFloat(Int(String.substr(rgba, 8, 2), radix: 16) ?? 0xff) / CGFloat(0xff)
                }
            }
            else
            if rgba.count >= 4 {
                r = CGFloat((Int(String.substr(rgba, 2, 1), radix: 16) ?? 0xf) * 0x11) / CGFloat(0xff)
                g = CGFloat((Int(String.substr(rgba, 3, 1), radix: 16) ?? 0xf) * 0x11) / CGFloat(0xff)
                b = CGFloat((Int(String.substr(rgba, 4, 1), radix: 16) ?? 0xf) * 0x11) / CGFloat(0xff)
                if rgba.count >= 5 {
                    a = CGFloat((Int(String.substr(rgba, 5, 1), radix: 16) ?? 0xf) * 0x11) / CGFloat(0xff)
                }
            }
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

//=== Darkモード対応
enum MyColorDefine {
    //===[色の定義は、自動生成させたい]___
    // [In]: <色定義ID>, <lightモードCOLORREF値>, <darkモードCOLORREF値>
    // [Out]: ↓
    case headText
    case headBack

    var lightColor: UIColor {
        switch self {
        case .headText:         return UIColor(rgba: "#000f")
        case .headBack:         return UIColor(rgba: "#ffff")
        }
    }
    var darkColor: UIColor {
        switch self {
        case .headText:         return UIColor(rgba: "#ffff")
        case .headBack:         return UIColor(rgba: "#000f")
        }
    }
    //===[色の定義は、自動生成させる]^^^

    //=== 現在のDarkモード設定に応じた色を返す
    var color: UIColor {
        return UITraitCollection.isDarkMode ? darkColor : lightColor
    }
}
