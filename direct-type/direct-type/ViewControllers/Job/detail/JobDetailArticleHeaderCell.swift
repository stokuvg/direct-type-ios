//
//  JobDetailArticleHeaderCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/08/25.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol JobDetailArticleHeaderCellDelegate {
    func articleHeaderAction()
}

class JobDetailArticleHeaderCell: BaseTableViewCell {
    
    @IBOutlet weak var titleBackView:UIView!
    @IBOutlet weak var titleLabel:UILabel!
    
    @IBOutlet weak var btnBackView:UIView!
    @IBOutlet weak var headerOpenBtn:UIButton!
    @IBAction func headerOpenAction() {
        self.delegate.articleHeaderAction()
    }
    
    var delegate:JobDetailArticleHeaderCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
        headerOpenBtn.setNoRadiusTitle(text: "続きを読む", fontType: .C_font_SS, textColor: UIColor.init(colorType: .color_sub)!, alignment: .center)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup(string:String,openFlag:Bool) {
        self.titleLabel.text(text: string, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        headerOpenBtn.isHidden = openFlag
        if openFlag {
            titleLabel.numberOfLines = 0
        } else {
            titleLabel.numberOfLines = 2
        }
    }
    
}
