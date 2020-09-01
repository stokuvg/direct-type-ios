//
//  JobDetailArticleCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol JobDetailArticleCellDelegate {
    func articleCellCloseAction()
}

class JobDetailArticleCell: BaseTableViewCell {
    
    @IBOutlet weak var articleMainBackView:UIView!
    @IBOutlet weak var articleMainLabel:UILabel!
    @IBOutlet weak var articleCloseBackView:UIView!
    @IBOutlet weak var articleCloseBtn:UIButton!
    @IBAction func articleCloseBtnAction() {
        self.delegate.articleCellCloseAction()
    }
    
    var delegate:JobDetailArticleCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        articleCloseBtn.setNoRadiusTitle(text: "▲ 閉じる", fontType: .C_font_SS, textColor: UIColor.init(colorType: .color_line)!, alignment: .center)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data:String) {
        
        articleMainLabel.text(text: data, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }
    
}
