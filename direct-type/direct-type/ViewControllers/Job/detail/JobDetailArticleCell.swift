//
//  JobDetailArticleCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailArticleCell: BaseTableViewCell {
    
    @IBOutlet weak var articleMainLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data:String) {
        articleMainLabel.text(text: data, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }
    
}
