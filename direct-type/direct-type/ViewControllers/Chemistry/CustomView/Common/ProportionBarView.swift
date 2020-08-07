//
//  ProportionBarView.swift
//  direct-type
//
//  Created by yamataku on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ProportionBarView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    var valueRatio: Double = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resetValueBar()
    }
}

private extension ProportionBarView {
    var valueBarFrame: CGRect {
        let valueWidth = bounds.width * CGFloat(valueRatio)
        return CGRect(x: .zero, y: .zero, width: valueWidth, height: bounds.height)
    }
    
    var halfHeight: CGFloat {
        return frame.height / 2
    }
    
    func setup() {
        layer.cornerRadius = halfHeight
        backgroundColor = .gray
    }
    
    func resetValueBar() {
        if let valueBar = subviews.first(where: { $0 is ProportionValueBarView }) {
            valueBar.removeFromSuperview()
        }
        let valueBar = ProportionValueBarView(frame: valueBarFrame)
        addSubview(valueBar)
    }
}

private final class ProportionValueBarView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    var halfHeight: CGFloat {
        return frame.height / 2
    }
    
    func setup() {
        backgroundColor = UIColor(colorType: .color_sub)
        layer.cornerRadius = halfHeight
    }
}
