//
//  JobDetailDataCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailDataCell: UITableViewCell {
    
    @IBOutlet weak var dataStackView:UIStackView!
    
    // 終了間近,スカウト
    @IBOutlet weak var imminetAndScountBackView:UIView!
    // 職種名
    @IBOutlet weak var jobCategoryBackView:UIView!
    // 給与
    @IBOutlet weak var salaryBackView:UIView!
    // 勤務地
    @IBOutlet weak var workPlaceBackView:UIView!
    // 社名
    @IBOutlet weak var companyBackView:UIView!
    // 掲載期限
    @IBOutlet weak var limitBackView:UIView!
    // メイン画像
    @IBOutlet weak var mainImageBackView:UIView!
    // 記事
    @IBOutlet weak var articleBackView:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.init(colorType: .color_base)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
