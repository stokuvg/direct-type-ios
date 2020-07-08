//
//  JobOfferBigCardCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AlamofireImage
import TudApi

class JobOfferBigCardCell: BaseJobCardCell {

    @IBOutlet weak var keepBtn:UIButton!
    @IBAction func keepBtnAction() {
        
        self.delegate.keepAction(tag: self.tag)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.init(colorType: .color_base)
        
        // サムネイル
        thumnailImageView.layer.cornerRadius = 15
        thumnailImageView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        limitedMarkView.cornerRadius = 5
        limitedLabel.text(text: "終了間近", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        
        btnView.layer.cornerRadius = 15
        btnView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        let textColor:UIColor = UIColor.init(colorType: .color_light_gray)!
        deleteBtn.titleLabel?.text(text: "見送り", fontType: .C_font_M, textColor: textColor, alignment: .center)
        deleteBtn.layer.cornerRadius = 15
        deleteBtn.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        keepBtn.titleLabel?.text(text: "キープ", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_sub)!, alignment: .center)
        keepBtn.layer.cornerRadius = 15
        keepBtn.layer.maskedCorners = [.layerMaxXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data:MdlJobCard) {
//        Log.selectLog(logLevel: .debug, "JobOfferBigCardCell setup start")
//        Log.selectLog(logLevel: .debug, "jobId:\(data.jobCardCode)")
        self.jobCardData = data
        // サムネイル画像
        let imageUrlString:String = data.mainPicture
        thumnailImageView.af_setImage(withURL: URL(string: imageUrlString)!)
        
        let nowDate = Date()
        // NEWマーク 表示チェック
        let start_date_string = data.displayPeriod.startAt
//        Log.selectLog(logLevel: .debug, "start_date_string:\(start_date_string)")
        let startPeriod = DateHelper.newMarkFlagCheck(startDateString: start_date_string, nowDate: nowDate)
        // 終了マーク 表示チェック
        let end_date_string = data.displayPeriod.endAt
//        Log.selectLog(logLevel: .debug, "end_date_string:\(end_date_string)")
        let endPeriod = DateHelper.endFlagHiddenCheck(endDateString:end_date_string, nowDate:nowDate)
        
        var limitedType:LimitedType!
        switch (startPeriod,endPeriod) {
            case (false,false):
//                Log.selectLog(logLevel: .debug, "両方当たる")
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
        
        // 職業
        let job:String = data.jobName
        jobLabel.text(text: job, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)

        // 給与
        let displayFlag = data.salaryDisplay
        if displayFlag {
            
            let minPriceLabel = SelectItemsManager.getCodeDisp(.salary, code: data.salaryMinCode)?.disp ?? ""
            let minPrice = self.cutText(defaultText: minPriceLabel,cutString: "万円")
            let maxPriceLabel = SelectItemsManager.getCodeDisp(.salary, code: data.salaryMaxCode)?.disp ?? ""
            let maxPrice = self.cutText(defaultText: maxPriceLabel,cutString: "万円")
            
            let priceText = minPrice + "〜" + maxPrice
            saralyLabel.text(text: priceText, fontType: .C_font_M , textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
            saralyMarkLabel.text(text: "万円", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        } else {
            saralyLabel.text(text: "非公開", fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            saralyMarkLabel.text(text: "", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        }
        // 特別年収 TODO:初回は非表示
//        saralySpecialLabel.isHidden = true
//        saralySpecialMarkLabel.isHidden = true
//        cautionView.isHidden = true
//        self.stackView.addArrangedSubview(cautionView)
//        cautionView.isHidden = true
        
        // 勤務地
        let areaText = self.makeAreaNames(codes: data.workPlaceCode)
        areaLabel.text(text: areaText, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        // 社名
        let companyName = data.companyName
//        Log.selectLog(logLevel: .debug, "companyName:\(String(describing: companyName))")
        companyNameLabel.text(text: companyName, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        // メイン
        let mainText = data.mainTitle.paragraphElimination()
        catchLabel.text(text: mainText, fontType: .C_font_SS , textColor: UIColor.init(colorType: .color_parts_gray)!, alignment: .left)
        catchLabel.lineBreakMode = .byTruncatingTail
        
        // 見送りボタン
//        let skip = data.skipStatus
//        self.skipSetting(flag:skip)
        
        // キープボタン
        let keep = data.keepStatus
        keepFlag = keep
        self.keepBtnSetting(flag: keepFlag)
        
    }
    
    private func limitedMarkSetting(type:LimitedType) {
        switch type {
            case .none:
                self.limitedMarkView.isHidden = true
                self.limitedImageView.isHidden = true
                self.limitedLabel.isHidden = true
                self.limitedMarkBackView.isHidden = true
//                self.stackView.removeArrangedSubview(self.limitedMarkBackView)
            case .new:
                self.limitedMarkView.isHidden = false
                self.limitedImageView.isHidden = false
                self.limitedLabel.isHidden = true
                self.limitedImageView.image = UIImage(named: "new")
                self.limitedMarkBackView.isHidden = false
            case .end:
                self.limitedMarkView.isHidden = false
                self.limitedImageView.isHidden = false
                self.limitedLabel.isHidden = false
                limitedLabel.text(text: "終了間近", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
                self.limitedImageView.image = UIImage(named: "upcoming")
                self.limitedMarkBackView.isHidden = false
        }
    }
    
    private func cutText(defaultText: String, cutString: String) -> String {
        let curArray = defaultText.components(separatedBy: cutString)
        let displayText = curArray.first!
        
        return displayText
    }
    
    private func makeAreaNames(codes:[Int]) -> String {
//        Log.selectLog(logLevel: .debug, "JobOfferBigCardCell makeAreaNames start")
        var text:String = ""
        for i in 0..<codes.count {
            let code = codes[i]
//            Log.selectLog(logLevel: .debug, "code:\(code)")
            if let placeText = (SelectItemsManager.getCodeDisp(.entryPlace, code: code)?.disp) {
                text = text + placeText
                if (codes.count - 1) > i {
                    text += ","
                }
            }
        }
        
        return text
    }
    
    // 見送り設定
    func skipSetting(flag: Bool) {
    }
    
    func keepSetting(flag: Bool) {
        Log.selectLog(logLevel: .debug, "JobOfferBigCardCell keepSetting start")
        keepBtnSetting(flag: flag)
    }
    
    private func keepBtnSetting(flag:Bool) {
        
        let noSelectImage = UIImage(named: "like_gray")
        let selectedImage = UIImage(named: "likeSelected")
        let useImage = flag ? selectedImage : noSelectImage
        
        let noSelectColor = UIColor.init(colorType: .color_light_gray)
        let selectColor = UIColor.init(colorType: .color_sub)
        let useColor = flag ? selectColor : noSelectColor
        
        keepBtn.setTitleColor(useColor, for: .normal)
        
        keepBtn.setImage(useImage, for: .normal)
    }
    
}
