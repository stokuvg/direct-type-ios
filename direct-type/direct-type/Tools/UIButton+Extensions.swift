//
//  UIButton+Extensions.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/07.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setTitle(text:String,fontType:FontType,textColor:UIColor, alignment:NSTextAlignment) {
        
        self.setTitle(text, for: .normal)
        self.titleLabel?.text(text: text, fontType: fontType, textColor: textColor, alignment: alignment)
        
        self.cornerRadius = self.bounds.height/2
        
        self.setTitleColor(textColor.withAlphaComponent(0.8), for: .highlighted) //ボタン押下時のフィードバック（仮）
        self.isExclusiveTouch = true //同時押し不可にしておく

    }
    
    func setNoRadiusTitle(text:String,fontType:FontType,textColor:UIColor, alignment:NSTextAlignment) {
        
        self.setTitle(text, for: .normal)
        self.titleLabel?.text(text: text, fontType: fontType, textColor: textColor, alignment: alignment)
    }
}
