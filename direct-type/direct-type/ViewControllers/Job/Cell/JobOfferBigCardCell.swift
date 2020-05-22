//
//  JobOfferBigCardCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AlamofireImage

enum LimitedType {
    case none
    case new
    case end
}

class JobOfferBigCardCell: BaseJobCardCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.init(colorType: .color_base)
        
        stackView.layer.cornerRadius = 15
        
        // サムネイル
        thumnailImageView.layer.cornerRadius = 15
        thumnailImageView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        limitedMarkView.cornerRadius = 5
        limitedLabel.text(text: "終了間近", fontType: .C_font_SSSb, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        
        btnView.layer.cornerRadius = 15
        btnView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        let textColor:UIColor = UIColor.init(colorType: .color_line)!
        deleteBtn.titleLabel?.text(text: "見送り", fontType: .C_font_M, textColor: textColor, alignment: .center)
        deleteBtn.layer.cornerRadius = 15
        deleteBtn.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        keepBtn.layer.cornerRadius = 15
        keepBtn.layer.maskedCorners = [.layerMaxXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data:MdlJobCard) {
    
        // サムネイル画像
        let imageUrlString:String = data.mainPicture
        thumnailImageView.af_setImage(withURL: URL(string: imageUrlString)!)
        
        let nowDate = Date()
        // NEWマーク 表示チェック
        let start_date_string = data.displayPeriod.startAt
        let startFlag = newMarkFlagCheck(startDateString: start_date_string, nowDate: nowDate)
        // 終了マーク 表示チェック
        let end_date_string = data.displayPeriod.endAt
        let endFlag = endFlagHiddenCheck(endDateString:end_date_string, nowDate:nowDate)
        
        var limitedType:LimitedType!
        switch (startFlag,endFlag) {
            case (false,false):
//                Log.selectLog(logLevel: .debug, "両方当たる")
                // 終了マークのみ表示
                limitedType = .end
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
            
            let minPriceLabel = SelectItemsManager.getCodeDisp(.salary, code: data.salaryMinCode)?.disp
//            Log.selectLog(logLevel: .debug, "minPriceLabel:\(String(describing: minPriceLabel))")
            let minPrice = self.cutText(defaultText: minPriceLabel!,cutString: "万円")
            let maxPriceLabel = SelectItemsManager.getCodeDisp(.salary, code: data.salaryMaxCode)?.disp
            let maxPrice = self.cutText(defaultText: maxPriceLabel!,cutString: "万円")
//            Log.selectLog(logLevel: .debug, "maxPriceLabel:\(String(describing: maxPriceLabel))")
            
            let priceText = minPrice + "〜" + maxPrice
            saralyLabel.text(text: priceText, fontType: .C_font_M , textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
            saralyMarkLabel.text(text: "万円", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        } else {
            saralyLabel.text(text: "非公開", fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            saralyMarkLabel.text(text: "", fontType: .C_font_M, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
        }
        // 特別年収 TODO:初回は非表示
        saralySpecialLabel.isHidden = true
        saralySpecialMarkLabel.isHidden = true
        cautionView.isHidden = true
        self.stackView.addArrangedSubview(cautionView)
//        cautionView.isHidden = true
        
        // 勤務地
        let areaText = self.makeAreaNames(codes: data.workPlaceCode)
//        Log.selectLog(logLevel: .debug, "areaText:\(String(describing: areaText))")
        areaLabel.text(text: areaText, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        // 社名
        let companyName = data.companyName
//        Log.selectLog(logLevel: .debug, "companyName:\(String(describing: companyName))")
        companyNameLabel.text(text: companyName, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        // メイン
        let mainText = data.mainTitle
//        Log.selectLog(logLevel: .debug, "mainText:\(String(describing: mainText))")
        catchLabel.text(text: mainText, fontType: .C_font_SS , textColor: UIColor.init(colorType: .color_parts_gray)!, alignment: .left)
        
        // 見送りボタン
        let skip = data.skipStatus
//        Log.selectLog(logLevel: .debug, "skip:\(String(describing: skip))")
        self.skipSetting(flag:skip)
        
        // キープボタン
        let keep = data.keepStatus
//        Log.selectLog(logLevel: .debug, "keep:\(String(describing: keep))")
        self.keepSetting(flag:keep)
        
        /*
        if data.count > 0 {
            let endFlag:Bool = (data["end"] as! Bool)
            if endFlag {
                self.limitedMarkView.isHidden = true
                self.stackView.removeArrangedSubview(self.limitedMarkBackView)
            }
            
            let imageUrlString:String = (data["image"] as! String)
            thumnailImageView.af_setImage(withURL: URL(string: imageUrlString)!)
            
            let job:String = (data["job"] as! String)
            jobLabel.text(text: job, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            let price:String = (data["price"] as! String)
            let priceText = (price + "万円")
            saralyLabel.text(text: priceText, fontType: .C_font_M , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            //TODO:初回は非表示
            saralySpecialLabel.isHidden = true
            saralySpecialMarkLabel.isHidden = true
            cautionView.isHidden = true
            /*
            let special:String = (data["special"] as! String)
            if special.count > 0 && Int(special)! > 0 {
                saralySpecialLabel.text(text: special, fontType: .C_font_L , textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
                saralySpecialMarkLabel.text(text: "万円", fontType: .C_font_M , textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
                saralySpecialLabel.isHidden = true
                saralySpecialMarkLabel.isHidden = true
                saralyCautionLabel.text(text: "通常よりも", fontType: .C_font_S, textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
            } else {
                cautionView.isHidden = true
                
                saralySpecialLabel.text(text: special, fontType: .C_font_M , textColor: UIColor.init(colorType: .color_sub)!, alignment: .left)
                saralySpecialLabel.isHidden = true
                saralySpecialMarkLabel.isHidden = true
            }
            */
            
            let area:String = (data["area"] as! String)
            areaLabel.text(text: area, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            let company:String = (data["company"] as! String)
            companyNameLabel.text(text: company, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
            
            let main:String = (data["main"] as! String)
            catchLabel.text(text: main, fontType: .C_font_SS , textColor: UIColor.init(colorType: .color_parts_gray)!, alignment: .left)
        }
        */
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
    
    private func newMarkFlagCheck(startDateString: String, nowDate:Date) -> Bool {
        var retInterval:Double!
        
        let startDate = DateHelper.convStr2Date(startDateString)
//        Log.selectLog(logLevel: .debug, "startDate:\(startDate)")
        
        retInterval = nowDate.timeIntervalSince(startDate)
        
        let ret = retInterval/86400
//        Log.selectLog(logLevel: .debug, "ret:\(ret)")
        if ret > 7 {
            return true
        }
        return false
        
    }
    
    private func endFlagHiddenCheck(endDateString: String, nowDate:Date) -> Bool {
        var retInterval:Double!
        
        let endDate = DateHelper.convStr2Date(endDateString)
//        Log.selectLog(logLevel: .debug, "endDate:\(endDate)")
        
        retInterval = endDate.timeIntervalSince(nowDate)
        
        let ret = retInterval/86400
//        Log.selectLog(logLevel: .debug, "ret:\(ret)")
        if ret > 7 {
            return true
        }
        return false
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
            let placeText = (SelectItemsManager.getCodeDisp(.place, code: code)?.disp)!
            text = text + placeText
            if (codes.count - 1) > i {
                text += ","
            }
        }
        
        return text
    }
    
    // 見送り設定
    func skipSetting(flag: Bool) {
        
    }
    
    func keepSetting(flag: Bool) {
        
    }
    
}
