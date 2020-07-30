//
//  KeepCardCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AlamofireImage
import TudApi

protocol KeepCardCellDelegate {
    func keepChangeAction()
}

class KeepCardCell: BaseJobCardCell {
    
    @IBOutlet weak var unitLabel:UILabel!
    @IBOutlet weak var keepActionBtn:UIButton!
    @IBAction func keepAction() {
        self.changeKeepStatus()
        self.changeKeepImage()
        self.delegate.keepAction(jobId: self.jobId)
//        self.delegate.keepAction(tag: self.tag)
    }
    
    var jobId:String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // サムネイル
//        thumnailImageView.layer.cornerRadius = 15
//        thumnailImageView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
//        thumbnailImageBackView.layer.cornerRadius = 15
//        thumbnailImageBackView.clipsToBounds = true
        
        // 終了間近
        limitedLabel.text(text: "終了間近", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup(data:MdlKeepJob) {
        
        self.jobId = data.jobId
        
        // キープのステータス
        self.keepFlag = data.keepStatus
        self.changeKeepImage()
        
        let nowDate = Date()
        // NEWマーク 表示チェック
        let start_date_string = data.pressStartDate
//        let start_date_string = "2020-07-02"
//        Log.selectLog(logLevel: .debug, "start_date_string:\(start_date_string)")
        let startFlag = DateHelper.newMarkFlagCheck(startDateString: start_date_string, nowDate: nowDate)
        // 終了マーク 表示チェック
        let end_date_string = data.pressEndDate
//        let end_date_string = "2020-07-12"
//        Log.selectLog(logLevel: .debug, "end_date_string:\(end_date_string)")
        let endFlag = DateHelper.endFlagHiddenCheck(endDateString:end_date_string, nowDate:nowDate)
        
        let limitedType:LimitedType = DateHelper.limitedTypeCheck(startFlag: startFlag, endFlag: endFlag)
        self.limitedMarkSetting(type: limitedType)
        
        // 職種名
        let job = data.jobName
        jobLabel.text(text: job, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        // サムネイル
        let imageUrlString = data.mainPhotoURL
        if imageUrlString.count > 0 {
            thumnailImageView.af_setImage(withURL: URL(string: imageUrlString)!)
            
            thumnailImageView.layer.cornerRadius = 15
            thumnailImageView.cornerRadius = 15
            thumnailImageView.clipsToBounds = true
        }
        
        // 給与金額
        let displayFlag = data.isSalaryDisplay
        if displayFlag {
            let _minSalaryId = data.salaryMinCode
            let minPriceLabel = SelectItemsManager.getCodeDisp(.salary, code: _minSalaryId)?.disp ?? ""
            let minPrice = self.cutText(defaultText: minPriceLabel,cutString: "万円")
            
            let _maxSalaryId = data.salaryMaxCode
            let maxPriceLabel = SelectItemsManager.getCodeDisp(.salary, code: _maxSalaryId)?.disp ?? ""
            let maxPrice = self.cutText(defaultText: maxPriceLabel,cutString: "万円")
            
            let priceText = minPrice + "〜" + maxPrice
            
//            let price:String = (data["price"] as! String)
            saralyLabel.adjustsFontSizeToFitWidth = true
            saralyLabel.text(text: priceText, fontType: .C_font_M , textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
            // 単位
            unitLabel.text(text: "万円", fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        } else {
            saralyLabel.text(text: "非公開", fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            // 単位
            unitLabel.text(text: "", fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        }
        
        // 勤務地
        let areaCodes = data.areaNames
        let areaNames = self.makeAreaNames(codes: areaCodes)
//        let area:String = (data["area"] as! String)
//        areaLabel.text(text: area, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        self.areaLabel.text(text: areaNames, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        
        // 社名
        let company = data.companyName
        companyNameLabel.text(text: company, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
    }
    
    private func makeAreaNames(codes: [String]) -> String {
//        Log.selectLog(logLevel: .debug, "self.makeAreaNames codes:\(codes)")
        
        var text:String = ""
        for i in 0..<codes.count {
            let code = Int(codes[i])
            let areaString:String = (SelectItemsManager.getCodeDisp(.entryPlace, code: code!)?.disp ?? "")
            text += areaString
            if i < (codes.count - 1) {
                text += ","
            }
        }
        
        return text
    }
    
    private func cutText(defaultText: String, cutString: String) -> String {
        let curArray = defaultText.components(separatedBy: cutString)
        let displayText = curArray.first!
        
        return displayText
    }
    
    private func limitedMarkSetting(type:LimitedType) {
        switch type {
            case .none:
                self.limitedMarkView.isHidden = true
                self.stackView.removeArrangedSubview(self.limitedMarkBackView)
            case .new:
                self.limitedLabel.text(text: "", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
                self.limitedImageView.image = UIImage(named: "new")
            case .end:
                limitedLabel.text(text: "終了間近", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
                self.limitedImageView.image = UIImage(named: "upcoming")
        }
    }
    
    private func changeKeepImage() {
//        Log.selectLog(logLevel: .debug, "changeKeepImage start")
        let offImage = UIImage(named: "keepDefault_GN")
        let onImage = UIImage(named: "keepSelected_GN")
        
//        Log.selectLog(logLevel: .debug, "keepFlag:\(keepFlag)")
        
        let useImage = self.keepFlag ? onImage : offImage
        
        keepActionBtn.setImage(useImage, for: .normal)
    }
    
}
