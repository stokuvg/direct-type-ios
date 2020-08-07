//
//  JobDetailStepView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/18.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailStepView: UIView {
    
    @IBOutlet weak var stackView:UIStackView!
    @IBOutlet weak var stepLabel:UILabel!
    @IBOutlet weak var textLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(no:String,text:String) {
//    func setup(data:[String: Any]) {
//        Log.selectLog(logLevel: .debug, "data:\(data)")
        
        stepLabel.text(text: no, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        
        textLabel.text(text: text, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
    }

}
