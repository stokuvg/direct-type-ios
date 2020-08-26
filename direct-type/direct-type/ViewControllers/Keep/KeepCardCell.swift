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
        let keepFlag = KeepManager.shared.getKeepStatus(jobCardID: self.jobId)
        self.changeKeepImage(!keepFlag)//表示だけ更新
        self.delegate.keepAction(jobId: self.jobId, newStatus: !keepFlag)//実際にフェッチさせる
    }
    
    @IBOutlet weak var jobNameBackView:UIView!
    @IBOutlet weak var jobNameBackViewHeight:NSLayoutConstraint!
    
    var jobId:String = ""
    
    var nowDate:Date = Date.init()

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
        
        self.jobNameBackView.backgroundColor = UIColor.init(colorType: .color_light_gray)
        self.jobLabel.backgroundColor = UIColor.init(colorType: .color_button)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nowDate = Date()
    }
    
    func setup(data:MdlKeepJob) {
        
        self.jobId = data.jobId
        
        // キープのステータス
        let keepFlag: Bool = KeepManager.shared.getKeepStatus(jobCardID: self.jobId)
        self.changeKeepImage(keepFlag)
        
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
        let jobName = data.jobName
        Log.selectLog(logLevel: .debug, "jobName:\(jobName)")
        jobLabel.text(text: jobName, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        let jobTextSize = CGFloat(jobName.count) * UIFont.init(fontType: .C_font_M)!.pointSize
        
        let jobWidth = self.jobLabel.frame.size.width
        
        Log.selectLog(logLevel: .debug, "jobTextSize:\(jobTextSize)")
        Log.selectLog(logLevel: .debug, "jobWidth:\(jobWidth)")
        
        if jobTextSize <= jobWidth {
            self.jobNameBackViewHeight.constant = 30
        } else {
            self.jobNameBackViewHeight.constant = 50
        }
        
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
            let minPriceLabel = SelectItemsManager.getCodeDisp(.salaryCode, code: _minSalaryId)?.disp ?? ""
            let minPrice = self.cutText(defaultText: minPriceLabel,cutString: "万円")
            
            let _maxSalaryId = data.salaryMaxCode
            let maxPriceLabel = SelectItemsManager.getCodeDisp(.salaryCode, code: _maxSalaryId)?.disp ?? ""
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
    
    private func changeKeepImage(_ keepFlag: Bool) {
        let offImage = UIImage(named: "like_gray")
        let onImage = UIImage(named: "likeSelected")
        let useImage = keepFlag ? onImage : offImage
        keepActionBtn.setImage(useImage, for: .normal)
    }
    
}
