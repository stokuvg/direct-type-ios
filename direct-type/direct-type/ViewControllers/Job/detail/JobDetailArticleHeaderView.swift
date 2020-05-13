//
//  JobDetailArticleHeaderView.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol JobDetailArticleHeaderViewDelegate {
    func articleHeaderAction()
}

class JobDetailArticleHeaderView: UIView {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var headerOpenBtn:UIButton!
    @IBAction func headerOpenAction() {
        self.delegate.articleHeaderAction()
    }
    
    var delegate:JobDetailArticleHeaderViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        headerOpenBtn.setTitle(text: "続きを読む", fontType: .C_font_SS, textColor: UIColor.init(colorType: .color_sub)!, alignment: .center)
        self.headerOpenBtn.backgroundColor = UIColor.init(colorType: .color_line)
    }
    
    func setup(string:String,openFlag:Bool) {
        self.titleLabel.text(text: string, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        headerOpenBtn.isHidden = openFlag
    }

}
