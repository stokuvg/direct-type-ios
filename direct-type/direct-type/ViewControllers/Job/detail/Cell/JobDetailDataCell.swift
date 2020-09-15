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
    
    // 期限
    @IBOutlet weak var limitedAndScountBackView:UIView!
    @IBOutlet weak var limitedBackView:UIView!
    @IBOutlet weak var limitedImageView:UIImageView!
    @IBOutlet weak var limitedLabel:UILabel!
    // スカウト通知
    @IBOutlet weak var scoutNoticeView:ScoutNoticeView!
    
    @IBOutlet weak var topSpaceView:UIView!
    @IBOutlet weak var topSpaceHeight:NSLayoutConstraint!
    
    // 職種名
    @IBOutlet weak var jobCategoryBackView:UIView!
    @IBOutlet weak var jobCategoryBackViewTop:NSLayoutConstraint!
    @IBOutlet weak var jobCategoryBackViewHeight:NSLayoutConstraint!
    @IBOutlet weak var jobCategoryBackViewBottom:NSLayoutConstraint!
    @IBOutlet weak var jobCategoryLabel:UILabel!
    // 給与
    @IBOutlet weak var salaryBackView:UIView!
    @IBOutlet weak var salaryLabel:UILabel!
    @IBOutlet weak var salaryMarkLabel:UILabel!
    // 勤務地
    @IBOutlet weak var workPlaceBackView:UIView!
    @IBOutlet weak var workPlaceBackViewHeight:NSLayoutConstraint!
    @IBOutlet weak var workPlaceLabelTop:NSLayoutConstraint!
    @IBOutlet weak var workPlaceLabel:UILabel!
    // 社名
    @IBOutlet weak var companyBackView:UIView!
    @IBOutlet weak var companyTopLayout:NSLayoutConstraint!
    @IBOutlet weak var companyBottomLayout:NSLayoutConstraint!
    @IBOutlet weak var companyLabel:UILabel!
    // 掲載期限
    @IBOutlet weak var limitBackView:UIView!
    @IBOutlet weak var limitLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
//        Log.selectLog(logLevel: .debug, "JobDetailDataCell awakeFromNib start")
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
//        Log.selectLog(logLevel: .debug, "JobDetailDataCell setup start")
        
        let nowDate = Date()
        // NEWマーク 表示チェック
//        let start_date_string = data.displayPeriod.startAt
        let start_date_string = data.start_date
        let startFlag = DateHelper.newMarkFlagCheck(startDateString: start_date_string, nowDate: nowDate)
        // 終了マーク 表示チェック
//        let end_date_string = data.displayPeriod.endAt
        let end_date_string = data.end_date
        let endFlag = DateHelper.endFlagHiddenCheck(endDateString:end_date_string, nowDate:nowDate)

        let scoutFlag:Bool = data.scoutStatus
        let limitedType:LimitedType = DateHelper.limitedTypeCheck(startFlag: startFlag, endFlag: endFlag)
        self.limitedMarkSetting(type: limitedType, scout: scoutFlag)
        
        // 職種
//        let job = data["job"] as! String
        
        let jobNameWidth = self.jobCategoryLabel.frame.size.width
        
        let jobName = data.jobName
        self.jobCategoryLabel.text(text: jobName, fontType: .C_font_L, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
//        Log.selectLog(logLevel: .debug, "jobName:\(jobName)")
//        Log.selectLog(logLevel: .debug, "jobName.count:\(jobName.count)")
        
//        Log.selectLog(logLevel: .debug, "jobNameWidth:\(jobNameWidth)")
        let jobNameSize = CGFloat(jobName.count) * UIFont.init(fontType: .C_font_L)!.pointSize
//        Log.selectLog(logLevel: .debug, "jobNameSize:\(jobNameSize)")
        // 1行
        if jobNameWidth <= jobNameSize {
            self.jobCategoryBackViewTop.constant = 1
            self.jobCategoryBackViewHeight.constant = 25
            self.jobCategoryBackViewBottom.constant = 1
        } else {
            // 複数行
            self.jobCategoryBackViewTop.constant = 3
            self.jobCategoryBackViewHeight.constant = 60
            self.jobCategoryBackViewBottom.constant = 3
        }
        // 年収
        let salaryDisplay = data.isSalaryDisplay
        if salaryDisplay {
//            Log.selectLog(logLevel: .debug, "data.salaryMinId:\(data.salaryMinId)")
            let minPriceLabel = SelectItemsManager.getCodeDisp(.salaryCode, code: data.salaryMinId)?.disp ?? ""
            let maxPriceLabel = SelectItemsManager.getCodeDisp(.salaryCode, code: data.salaryMaxId)?.disp ?? ""
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
        let codes: String = data.workPlaceCodes.map { (code) -> String in
            "\(code)"
        }.joined(separator: EditItemTool.JoinMultiCodeSeparator)
        let areaText: String = SelectItemsManager.convCodeDisp(.entryPlace, codes).map { (cd) -> String in
            cd.disp
        }.joined(separator: ",")
        
//        let checkAreaText = areaText + areaText
        
        let placeTextSize = CGFloat(areaText.count) * UIFont.init(fontType: .C_font_SSb)!.pointSize
        
        let placeLabelWidth = self.workPlaceLabel.frame.size.width
        
        self.workPlaceLabel.text(text: areaText, fontType: .C_font_SSb ,textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        if placeTextSize <= placeLabelWidth {
//            Log.selectLog(logLevel: .debug, "1行")
//            self.workPlaceLabelTop.constant = 10
            self.workPlaceLabel.numberOfLines = 1
            self.workPlaceBackViewHeight.constant = 30
        } else {
//            Log.selectLog(logLevel: .debug, "２行以上")
            let lineCount = Int(placeTextSize / placeLabelWidth)
//            Log.selectLog(logLevel: .debug, "lineCount:\(lineCount)")
            
            self.workPlaceLabel.numberOfLines = 0
            let addConstant = CGFloat(15 * (lineCount/2))
            self.workPlaceBackViewHeight.constant = 30 + addConstant
        }
        // 社名
        let company = data.companyName
//        let dCompany = company + company
        self.companyLayoutSizeCheck(text:company)
        self.companyLabel.text(text: company, fontType: .C_font_SSb ,textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
//        self.companyLabel.text(text: dCompany, fontType: .C_font_SSb ,textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
                
        // 掲載期間
//        let ymdStartDate = DateHelper.dateStringChangeFormatString(dateString: start_date_string)
        let ymdEndDate = DateHelper.dateStringChangeFormatString(dateString: end_date_string)
//        let period_string = ymdStartDate + "〜" + ymdEndDate
        let period_string = "〜" + ymdEndDate
        self.limitLabel.text(text: period_string, fontType: .C_font_SSb ,textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
    }
    
    private func companyLayoutSizeCheck(text: String) {
        let areaWidth = self.companyLabel.frame.size.width
//        Log.selectLog(logLevel: .debug, "areaWidth:\(areaWidth)")
        
//        Log.selectLog(logLevel: .debug, "text:\(text)")
//        Log.selectLog(logLevel: .debug, "UIFont.init(fontType: .C_font_SSb)?.pointSize:\(String(describing: UIFont.init(fontType: .C_font_SSb)?.pointSize))")
        
        let areaTextSize = CGFloat(text.count) * UIFont.init(fontType: .C_font_SSb)!.pointSize
//        Log.selectLog(logLevel: .debug, "areaTextSize:\(areaTextSize)")
        
        if areaWidth < areaTextSize {
            self.companyTopLayout.constant =  1
            self.companyBottomLayout.constant = 1
        }
        
    }
    
    private func cutText(defaultText: String, cutString: String) -> String {
        let curArray = defaultText.components(separatedBy: cutString)
        let displayText = curArray.first!
        
        return displayText
    }
    
    private func limitedMarkSetting(type:LimitedType, scout:Bool) {
        self.scoutNoticeView.isHidden = !scout
        switch type {
            case .none:
                self.limitedLabel.isHidden = true
//                self.dataStackView.removeArrangedSubview(self.limitedAndScountBackView)
                self.topSpaceHeight.constant = 12
                if scout {
                    self.limitedAndScountBackView.isHidden = false
                } else {
                    self.limitedAndScountBackView.isHidden = true
                }
            case .new:
                self.limitedAndScountBackView.isHidden = false
                self.limitedBackView.backgroundColor = UIColor.clear
                self.limitedLabel.isHidden = true
                self.limitedImageView.image = UIImage(named: "new")
                self.topSpaceHeight.constant = 0
            case .end:
                self.limitedAndScountBackView.isHidden = false
                self.limitedBackView.backgroundColor = UIColor.init(colorType: .color_black)
                self.limitedLabel.isHidden = false
                limitedLabel.text(text: "終了間近", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
                self.limitedImageView.image = UIImage(named: "upcoming")
                self.topSpaceHeight.constant = 12
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
