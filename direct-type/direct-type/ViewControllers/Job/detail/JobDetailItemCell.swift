//
//  JobDetailItemCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class JobDetailItemCell: BaseJobDetailCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for subView in self.itemStackView.subviews {
            if subView is JobDetailItemOptionalView {
                subView.removeFromSuperview()
            } else if subView is JobDetailItemAttentionView {
                subView.removeFromSuperview()
            }
        }
    }
    
    func setup(data: MdlJobCardDetail,row: Int) {
//    func setup(data:[String:Any]) {
        Log.selectLog(logLevel: .debug, "JobDetailItemCell setup start")

        Log.selectLog(logLevel: .debug, "row:\(row)")
//        Log.selectLog(logLevel: .debug, "data:\(data)")
        
        /*

         // 1.仕事内容:              必須
         // 　・案件例:               任意
         // 　・手掛ける商品・サービス:   任意
         // 　・開発環境・業務範囲:     任意
         // 　・注目ポイント:           任意
         // 2.応募資格:              必須
         // 　・歓迎する経験・スキル:     任意
         // 　・過去の採用例:           任意
         // 　・この仕事の向き・不向き:  任意
         // 3.雇用携帯コード:        必須
         // 4.給与:               必須
         // 　・賞与について:          任意
         // 5.勤務時間:             必須
         //   ・残業について:
         // 6.勤務地:              必須
         //   ・交通詳細
         // 7.休日休暇:            必須
         // 8.待遇・福利厚生:       必須
         // 　・産休・育休取得:      任意
         */
        var title:String = ""
        var text:String = ""
        switch row {
            case 0:
                // 仕事内容
                title = data.jobDescription.title
                text = data.jobDescription.text
            case 1:
                // 応募資格
                title = data.qualification.title!
                text = data.qualification.text!
            case 2:
                // 雇用形態
                title = data.employmentType.title!
                let type = SelectItemsManager.getCodeDisp(.employmentType, code: data.employmentType.type!)?.disp
                text = type!
            case 3:
                // 給与
                title = data.salary.title!
                text = data.salary.text!
            case 4:
                // 勤務時間
                title = data.jobtime.title!
                text = data.jobtime.text!
            case 5:
                // 勤務地
                title = data.workPlace.title!
                text = data.workPlace.text!
            case 6:
                // 休日休暇
                title = data.holiday.title!
                text = data.holiday.text!
            case 7:
                // 待遇・福利厚生
                title = data.welfare.title!
                text = data.welfare.text!
            default:
                title = ""
                text = ""
        }
        titleLabel.text(text: title, fontType: .font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        self.indispensableLabel.text(text: text, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        // 任意
        var optionalDatas:[[String:Any]] = []
        switch row {
            case 0:
                // 案件例
                if data.jobExample.text.count > 0 {
                    let exampleData = ["title":data.jobExample.title,"text":data.jobExample.text]
                    optionalDatas.append(exampleData)
                }
                // 手がける商品・サービス
                if data.product.text.count > 0 {
                    let productData = ["title":data.product.title,"text":data.product.text]
                    optionalDatas.append(productData)
                }
                // 開発環境
                if data.scope.text.count > 0 {
                    let scopeData = ["title":data.scope.title,"text":data.scope.text]
                    optionalDatas.append(scopeData)
                }
            case 1:
                // 歓迎するスキル
                if data.betterSkill.text!.count > 0 {
                    let title = data.betterSkill.title!
                    let text = data.betterSkill.text!
                    let skillData:[String: Any] = ["title": title, "text": text]
                    optionalDatas.append(skillData)
                }
                // 過去の採用例
                if data.applicationExample.text!.count > 0 {
                    let title = data.applicationExample.title!
                    let text = data.applicationExample.text!
                    let applicationExampleData = ["title":title, "text": text]
                    optionalDatas.append(applicationExampleData)
                }
                // この仕事の向き・不向き
                if data.suitableUnsuitable.text!.count > 0 {
                    let title = data.suitableUnsuitable.title!
                    let text = data.suitableUnsuitable.text!
                    let suitableUnsuitableData = ["title": title, "text": text]
                    optionalDatas.append(suitableUnsuitableData)
                }
            default:
                optionalDatas = []
        }
        
        if optionalDatas.count > 0 {
            Log.selectLog(logLevel: .debug, "任意用View")
            let optionalFrameWidth = self.itemBackView.frame.size.width
            for i in 0..<optionalDatas.count {
                let optionalView = UINib.init(nibName: "JobDetailItemOptionalView", bundle: nil)
                .instantiate(withOwner: self, options: nil)
                .first as! JobDetailItemOptionalView
                
                var viewFrame = optionalView.frame
                viewFrame.size.width = optionalFrameWidth
                optionalView.frame = viewFrame
                
                optionalView.tag = (i+1)
                
                let optionalData = optionalDatas[i]
                optionalView.setup(datas: optionalData)
                
                self.itemStackView.addArrangedSubview(optionalView)
            }
        }
        
        Log.selectLog(logLevel: .debug, "任意用View 追加後 self.itemStackView.subviews:\(self.itemStackView.subviews)")
        
        // 注目
        var attentionDatas:[[String:Any]] = []
        if row == 0 {
            Log.selectLog(logLevel: .debug, "注目用View")
            let spotTitle1 = data.spotTitle1
            let spotDetail1 = data.spotDetail1
            
            let spotTitle2 = data.spotTitle2
            let spotDetail2 = data.spotDetail2
            
            let spot1 = ["title":spotTitle1,"text":spotDetail1]
            let spot2 = ["title":spotTitle2,"text":spotDetail2]
            
            attentionDatas = [spot1,spot2]
            
            let attentionFrameWidth = self.itemBackView.frame.size.width
            for i in 0..<attentionDatas.count {
                let attentionView = UINib.init(nibName: "JobDetailItemAttentionView", bundle: nil)
                .instantiate(withOwner: self, options: nil)
                .first as! JobDetailItemAttentionView
                
                var viewFrame = attentionView.frame
                viewFrame.size.width = attentionFrameWidth
                attentionView.frame = viewFrame
                
                attentionView.tag = (i+1)
                
                let attentionData = attentionDatas[i]
                attentionView.setup(datas: attentionData)
                
                self.itemStackView.addArrangedSubview(attentionView)
            }
        } else {
            
        }
        
        /*
        let optional = data["optional"] as! [[String:Any]]
        if optional.count > 0 {
            let optionalFrameWidth = self.itemBackView.frame.size.width
            for i in 0..<optional.count {
                let optionalView = UINib.init(nibName: "JobDetailItemOptionalView", bundle: nil)
                .instantiate(withOwner: self, options: nil)
                .first as! JobDetailItemOptionalView
                
                var viewFrame = optionalView.frame
                viewFrame.size.width = optionalFrameWidth
                optionalView.frame = viewFrame
                
                optionalView.tag = (i+1)
                
                let optionalData = optional[i]
                optionalView.setup(datas: optionalData)
                
                self.itemStackView.addArrangedSubview(optionalView)
            }
        }
        
        let attention = data["attention"] as! [[String:Any]]
        if attention.count > 0 {
            let attentionFrameWidth = self.itemBackView.frame.size.width
            for i in 0..<attention.count {
                let attentionView = UINib.init(nibName: "JobDetailItemAttentionView", bundle: nil)
                .instantiate(withOwner: self, options: nil)
                .first as! JobDetailItemAttentionView
                
                var viewFrame = attentionView.frame
                viewFrame.size.width = attentionFrameWidth
                attentionView.frame = viewFrame
                
                attentionView.tag = (i+1)
                
                let attentionData = attention[i]
                attentionView.setup(datas: attentionData)
                
                self.itemStackView.addArrangedSubview(attentionView)
            }
        }
        */
        
    }
}
