//
//  JobDetailDataCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AlamofireImage
import TudApi

class JobDetailDataCell: BaseTableViewCell {
    
    @IBOutlet weak var dataStackView:UIStackView!
    
    // 期限,スカウト
    @IBOutlet weak var limitedAndScountBackView:UIView!
    @IBOutlet weak var limitedBackView:UIView!
    @IBOutlet weak var limitedImageView:UIImageView!
    @IBOutlet weak var limitedLabel:UILabel!
    
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
    
    func setup(data:MdlJobCardDetail) {
        Log.selectLog(logLevel: .debug, "JobDetailDataCell setup start")
        
        
        let nowDate = Date()
        // NEWマーク 表示チェック
//        let start_date_string = data.displayPeriod.startAt
        let start_date_string = data.start_date
        let startFlag = DateHelper.newMarkFlagCheck(startDateString: start_date_string, nowDate: nowDate)
        // 終了マーク 表示チェック
//        let end_date_string = data.displayPeriod.endAt
        let end_date_string = data.end_date
        let endFlag = DateHelper.endFlagHiddenCheck(endDateString:end_date_string, nowDate:nowDate)
                
        var limitedType:LimitedType!
        switch (startFlag,endFlag) {
            case (false,false):
//                Log.selectLog(logLevel: .debug, "両方当たる")
                // 両方とも一致しない
                limitedType = LimitedType.none
            case (false,true):
//                Log.selectLog(logLevel: .debug, "掲載開始から７日以内")
                // NEWマークのみ表示
                limitedType = .new
            case (true,false):
//                Log.selectLog(logLevel: .debug, "掲載終了まで７日以内")
                // 終了マークのみ表示
                limitedType = .end
            default:
//                Log.selectLog(logLevel: .debug, "それ以外")
                limitedType = LimitedType.none
        }
        self.limitedMarkSetting(type: limitedType)
        
        // 職種
//        let job = data["job"] as! String
        let job = data.jobName
        self.jobCategoryLabel.text(text: job, fontType: .C_font_L, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        // 年収
        let salaryDisplay = data.isSalaryDisplay
        if salaryDisplay {
            Log.selectLog(logLevel: .debug, "data.salaryMinId:\(data.salaryMinId)")
            let minPriceLabel = SelectItemsManager.getCodeDisp(.salary, code: data.salaryMinId)?.disp ?? ""
            let maxPriceLabel = SelectItemsManager.getCodeDisp(.salary, code: data.salaryMaxId)?.disp ?? ""
            if minPriceLabel.count > 0 && (maxPriceLabel.count > 0) {
                let minPrice = self.cutText(defaultText: minPriceLabel,cutString: "万円")
                let maxPrice = self.cutText(defaultText: maxPriceLabel,cutString: "万円")

                let priceText = minPrice + "〜" + maxPrice
                self.salaryLabel.text(text: priceText, fontType: .C_font_XL, textColor: UIColor.init(colorType: .color_sub)!, alignment: .center)
                self.salaryMarkLabel.text(text: "万円", fontType: .C_font_Sb ,textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
            }
        } else {
            self.salaryLabel.text(text: "非公開", fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            self.salaryMarkLabel.text(text: "", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        }
        // 勤務地
        let areaText = self.makeAreaNames(codes: data.workPlaceCodes)
        self.workPlaceLabel.text(text: areaText, fontType: .C_font_SSb ,textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        // 社名
        let company = data.companyName
        self.companyLabel.text(text: company, fontType: .C_font_SSb ,textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
                
        // 掲載期間
//        let ymdStartDate = DateHelper.dateStringChangeFormatString(dateString: start_date_string)
        let ymdEndDate = DateHelper.dateStringChangeFormatString(dateString: end_date_string)
//        let period_string = ymdStartDate + "〜" + ymdEndDate
        let period_string = "〜" + ymdEndDate
        self.limitLabel.text(text: period_string, fontType: .C_font_SSb ,textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }
    
    private func cutText(defaultText: String, cutString: String) -> String {
        let curArray = defaultText.components(separatedBy: cutString)
        let displayText = curArray.first!
        
        return displayText
    }
    
    private func makeAreaNames(codes:[Int]) -> String {
        var text:String = ""
        for i in 0..<codes.count {
            let code = codes[i]
            let placeText = (SelectItemsManager.getCodeDisp(.entryPlace, code: code)?.disp) ?? ""
            text = text + placeText
            if (codes.count - 1) > i {
                text += ","
            }
        }
        
        return text
    }
    
    private func limitedMarkSetting(type:LimitedType) {
        switch type {
            case .none:
                self.limitedAndScountBackView.isHidden = true
                self.dataStackView.removeArrangedSubview(self.limitedAndScountBackView)
            case .new:
                self.limitedLabel.text(text: "", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
                self.limitedImageView.image = UIImage(named: "new")
            case .end:
                limitedLabel.text(text: "終了間近", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
                self.limitedImageView.image = UIImage(named: "upcoming")
        }
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
