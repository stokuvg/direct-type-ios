//
//  UILabel+Extensions.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/30.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

// 破線
enum DashedLineType {
    case All,Top,Down,Right,Left
}

extension UILabel {
    
    func text(text: String, fontType: FontType, textColor: UIColor, alignment: NSTextAlignment, lineBreakMode: NSLineBreakMode = .byTruncatingTail) {
        self.attributedText = TudTool.attrText(text: text, fontType: fontType, textColor: textColor, alignment: alignment, lineBreakMode: lineBreakMode)
    }
    
    // 破線、点線の描画
    func drawDashedLine(color: UIColor, lineWidth: CGFloat, lineSize:NSNumber, spaceSize: NSNumber, type:DashedLineType) {
        let dashedLineLayer: CAShapeLayer = CAShapeLayer()
        dashedLineLayer.frame = self.bounds
        dashedLineLayer.strokeColor = color.cgColor
        dashedLineLayer.lineWidth = lineWidth
        dashedLineLayer.lineDashPattern = [lineSize, spaceSize]
        let path: CGMutablePath = CGMutablePath()
        
        switch type {
        case .All:
            dashedLineLayer.fillColor = nil
            dashedLineLayer.path = UIBezierPath(rect: dashedLineLayer.frame).cgPath
        case .Top:
            path.move(to: CGPoint(x: 0.0, y: 0.0))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
            dashedLineLayer.path = path
        case .Down:
            path.move(to: CGPoint(x: 0.0, y: self.frame.size.height))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
            dashedLineLayer.path = path
        case .Right:
            path.move(to: CGPoint(x: self.frame.size.width, y: 0.0))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
            dashedLineLayer.path = path
        case .Left:
            path.move(to: CGPoint(x: 0.0, y: 0.0))
            path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
            dashedLineLayer.path = path
        }
        self.layer.addSublayer(dashedLineLayer)
    }
}

