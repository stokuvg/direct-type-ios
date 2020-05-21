//
//  JobDetailDataCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class JobDetailDataCell: BaseTableViewCell {
    
    @IBOutlet weak var dataStackView:UIStackView!
    
    // 終了間近,スカウト
    @IBOutlet weak var imminetAndScountBackView:UIView!
    @IBOutlet weak var endBackView:UIView!
    @IBOutlet weak var endLabel:UILabel!
    
    @IBOutlet weak var scountBackView:UIView!
    @IBOutlet weak var scountLabel:UILabel!
    
    // 職種名
    @IBOutlet weak var jobCategoryBackView:UIView!
    @IBOutlet weak var jobCategoryLabel:UILabel!
    // 給与
    @IBOutlet weak var salaryBackView:UIView!
    @IBOutlet weak var salaryLabel:UILabel!
    @IBOutlet weak var salaryMarkLabel:UILabel!
    // 勤務地
    @IBOutlet weak var workPlaceBackView:UIView!
    @IBOutlet weak var workPlaceLabel:UILabel!
    // 社名
    @IBOutlet weak var companyBackView:UIView!
    @IBOutlet weak var companyLabel:UILabel!
    // 掲載期限
    @IBOutlet weak var limitBackView:UIView!
    @IBOutlet weak var limitLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        Log.selectLog(logLevel: .debug, "JobDetailDataCell awakeFromNib start")
        // Initialization code
        self.backgroundColor = UIColor.init(colorType: .color_base)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup(data:[String:Any]) {
        Log.selectLog(logLevel: .debug, "JobDetailDataCell setup start")
        
        // 終了間近
        let end = data["end"] as! Bool
        if end == false {
            dataStackView.removeArrangedSubview(imminetAndScountBackView)
        } else {
            endLabel.text(text: "終了間近", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        }
        
        // スカウト情報
        scountLabel.text(text: "スカウトが届いています", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        
        // 職種
        let job = data["job"] as! String
        self.jobCategoryLabel.text(text: job, fontType: .C_font_L, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        // 年収
        let salary = data["price"] as! String
        self.salaryLabel.text(text: salary, fontType: .C_font_XL, textColor: UIColor.init(colorType: .color_sub)!, alignment: .center)
        self.salaryMarkLabel.text(text: "万円", fontType: .C_font_Sb ,textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        // 勤務地
        let area = data["area"] as! String
        self.workPlaceLabel.text(text: area, fontType: .C_font_SSb ,textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        // 社名
        let company = data["company"] as! String
        self.companyLabel.text(text: company, fontType: .C_font_SSb ,textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        // 期間
        let period_start_string:String = data["period_start"] as! String
        let period_end_string:String = data["period_end"] as! String
                
        let period_start = self.changeFormatString(string: period_start_string)
        let period_end = self.changeFormatString(string: period_end_string)
        
        let period_string = period_start + "〜" + period_end
        self.limitLabel.text(text: period_string, fontType: .C_font_SSb ,textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }
    
    private func changeFormatString(string:String) -> String {
        if string.count == 0 {
            return ""
        }
        
        let formatter:DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.date(from: string)
        
        let changeFormatter:DateFormatter = DateFormatter()
        changeFormatter.calendar = Calendar(identifier: .gregorian)
        changeFormatter.dateFormat = "yyyy年MM月dd日"
        
        return changeFormatter.string(from: date!)
        
    }
    
}
