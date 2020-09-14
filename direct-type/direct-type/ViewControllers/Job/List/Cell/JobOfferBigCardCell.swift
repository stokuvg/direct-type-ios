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
    
    @IBOutlet weak var jobLabelTop:NSLayoutConstraint!
    @IBOutlet weak var jobLabelHeight:NSLayoutConstraint!

    @IBOutlet weak var keepBtn:UIButton!
    @IBAction func keepBtnAction() {
        let flag = KeepManager.shared.getKeepStatus(jobCardID: self.jobId)
        keepBtnSetting(flag: !flag)//いったんローカルの表示だけ更新している
        self.delegate.keepAction(jobId: self.jobId, newStatus: !flag)
    }
    
    var jobId:String = ""

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
        
        initNotify()
    }
    
    //=== Notification通知の登録 ===
    // 画面遷移時にも取り除かないもの（他の画面で変更があった場合の更新のため）
    func initNotify() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keepListChanged(notification:)), name: Constants.NotificationKeepStatusChanged, object: nil)
    }
    @objc func keepListChanged(notification: NSNotification) {
        //notification.userInfoにjobCardIDを入れてるので、個別の表示更新にも対応可能
        if let userInfo = notification.userInfo {
            if let targetJobID: String = userInfo[Constants.NotificationKeepStatusChangedParamJobID] as? String {
                if jobId == targetJobID {
                    dispKeepStatus()//表示更新のため
                }
            }
        }
    }
    func dispKeepStatus() {
        let keepFlag = KeepManager.shared.getKeepStatus(jobCardID: jobId)
        keepBtnSetting(flag: keepFlag)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setup(data: MdlJobCard) {
        self.jobCardData = data
        self.jobId = jobCardData.jobCardCode
        // サムネイル画像
        let imageUrlString:String = data.mainPicture
        thumnailImageView.af_setImage(withURL: URL(string: imageUrlString)!)
        // NEWマーク 表示チェック
        let nowDate = Date()
        let start_date_string = data.displayPeriod.startAt
        let startPeriod = DateHelper.newMarkFlagCheck(startDateString: start_date_string, nowDate: nowDate)
        // 終了マーク 表示チェック
        let end_date_string = data.displayPeriod.endAt
        let endPeriod = DateHelper.endFlagHiddenCheck(endDateString:end_date_string, nowDate:nowDate)
        
        let limitedType:LimitedType = DateHelper.limitedTypeCheck(startFlag: startPeriod, endFlag: endPeriod)
        
        let scoutFlag:Bool = data.scoutStatus
        self.limitedMarkSetting(type: limitedType,scout: scoutFlag)
        
        // 職業
        let jobWidth = self.jobLabel.frame.size.width
        let jobName:String = data.jobName
//        Log.selectLog(logLevel: .debug, "jobName:\(jobName)")
//        Log.selectLog(logLevel: .debug, "jobName.count:\(jobName.count)")
        
        jobLabel.text(text: jobName, fontType: .C_font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        let saveHeight:CGFloat = 30.0
        // かつ１行か２行か
        let jobTextSize = CGFloat(jobName.count) * UIFont.init(fontType: .C_font_M)!.pointSize
        
//        Log.selectLog(logLevel: .debug, "jobTextSize:\(jobTextSize)")
//        Log.selectLog(logLevel: .debug, "jobWidth:\(jobWidth)")
        
        
        if jobTextSize <= (jobWidth + 10) {
            self.jobLabelHeight.constant = saveHeight
        } else {
            self.jobLabelHeight.constant = 60
        }
        
        /*
        if jobLabel.bounds.size.width > jobNameWidth {
            self.jobLabelHeight.constant -= 30
        } else if jobNameWidth > jobLabel.bounds.size.width {
            var jobLabelFrame = self.jobLabel.frame
            jobLabelFrame.size.height = 41
            jobLabel.frame = jobLabelFrame
            self.jobLabelHeight.constant = saveHeight
        } else if jobLabel.bounds.size.height <= 20.5 {
            self.jobLabelHeight.constant -= 30
        } else {
            self.jobLabelHeight.constant = saveHeight
        }
        */

        // 給与
        let displayFlag = data.salaryDisplay
        if displayFlag {
            
            let minPriceLabel = SelectItemsManager.getCodeDisp(.salaryCode, code: data.salaryMinCode)?.disp ?? ""
            let minPrice = self.cutText(defaultText: minPriceLabel,cutString: "万円")
            let maxPriceLabel = SelectItemsManager.getCodeDisp(.salaryCode, code: data.salaryMaxCode)?.disp ?? ""
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
        let codes: String = data.workPlaceCode.map { (code) -> String in
            "\(code)"
        }.joined(separator: EditItemTool.JoinMultiCodeSeparator)
        let areaText: String = SelectItemsManager.convCodeDisp(.entryPlace, codes).map { (cd) -> String in
            cd.disp
        }.joined(separator: ",")
        areaLabel.text(text: areaText, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        // 社名
        let companyName = data.companyName
        companyNameLabel.text(text: companyName, fontType: .C_font_SSb , textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        // メイン
        let mainText = data.mainTitle.paragraphElimination()
        catchLabel.text(text: mainText, fontType: .C_font_SS , textColor: UIColor.init(colorType: .color_parts_gray)!, alignment: .left)
        catchLabel.lineBreakMode = .byTruncatingTail
        
        // キープボタン
        dispKeepStatus()
    }
    
    private func limitedMarkSetting(type:LimitedType, scout:Bool) {
        self.scoutNoticeView.mark.isHidden = !scout
        switch type {
            case .none:
                self.limitedMarkView.isHidden = true
                self.limitedImageView.isHidden = true
                self.limitedLabel.isHidden = true
//                self.limitedMarkBackView.isHidden = true
                if scout {
                    self.limitedMarkBackView.isHidden = false
                } else {
                    self.limitedMarkBackView.isHidden = true
                }
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
