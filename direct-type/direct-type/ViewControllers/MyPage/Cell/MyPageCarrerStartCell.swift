//
//  MyPageCarrerStartCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol MyPageCarrerStartCellDelegate {
    func registCarrerAction()
}

class MyPageCarrerStartCell: BaseTableViewCell {
    
    @IBOutlet weak var backCenterView:UIView!
    @IBOutlet weak var iconImageView:UIImageView!
    @IBOutlet weak var textCenterLabel:UILabel!
    @IBOutlet weak var registBtn:UIButton!
    @IBAction func registBtnAction() {
        self.delegate.registCarrerAction()
    }
    
    var delegate:MyPageCarrerStartCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backCenterView.layer.cornerRadius = 15
        
        textCenterLabel.text(text: "職務経歴書情報を登録して\nおすすめの求人の精度をあげよう！", fontType: .font_Sb, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
        registBtn.setTitle(text: "職務経歴書情報を登録する", fontType: .font_Sb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
