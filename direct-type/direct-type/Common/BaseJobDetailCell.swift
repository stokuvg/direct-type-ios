//
//  BaseJobDetailCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class BaseJobDetailCell: BaseTableViewCell {
    
    @IBOutlet weak var itemBackView:UIView!
    @IBOutlet weak var itemStackView:UIStackView!
    @IBOutlet weak var titleView:UIView!
    @IBOutlet weak var titleMark:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var line:UIView!
    @IBOutlet weak var indispensableView:UIView!        // 必須View
    @IBOutlet weak var indispensableLabel:UILabel!      // 必須項目

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
