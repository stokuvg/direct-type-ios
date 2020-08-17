//
//  JobDetailItemCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient
import TudApi

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
//                subView.removeFromSuperview()
            }
        }
    }
    
    private func makeEmploymentTypes(typeString: String) -> String {
        
//        let dummyTypeString = "1_2_5"
//        let typeCutStrings = dummyTypeString.components(separatedBy: "_")
        let typeCutStrings = typeString.components(separatedBy: "_")
//        Log.selectLog(logLevel: .debug, "typeCutStrings:\(typeCutStrings)")
        
        if typeCutStrings.count > 1 {
            var types:String = ""
            let firstCode = Int(typeCutStrings[0]) ?? 0
            let firstType = SelectItemsManager.getCodeDisp(.employmentType, code: firstCode)?.disp ?? ""
            
            types.append(firstType)
            
            for i in 1..<typeCutStrings.count {
                let typeCode = Int(typeCutStrings[i]) ?? 0
                let typeItem = SelectItemsManager.getCodeDisp(.employmentType, code: typeCode)?.disp ?? ""
                
                types.append("/")
                types.append(typeItem)
            }
            
            return types
            
        } else {
            let typeCode = Int(typeString) ?? 0
            let type = SelectItemsManager.getCodeDisp(.employmentType, code: typeCode)?.disp
            return type!
        }
    }
    
    func setup(data: MdlJobCardDetail,row: Int) {
//    func setup(data:[String:Any]) {
        
        var title:String = ""
        var text:String = ""
        switch row {
            case 0:
                // 仕事内容
//                title = data.jobDescription.title
//                text = data.jobDescription.text
                title = "仕事内容"
                text = data.jobDescription
            case 3:
                // 応募資格
//                title = data.qualification.title!
//                text = data.qualification.text!
                title = "応募資格"
                text = data.qualification
            case 4:
                // 雇用形態
                title = "雇用形態"
                Log.selectLog(logLevel: .debug, "employmentType:\(data.employmentType)")
                
                let types = self.makeEmploymentTypes(typeString:data.employmentType)
//                let type = SelectItemsManager.getCodeDisp(.employmentType, code: data.employmentType)?.disp ?? ""
                Log.selectLog(logLevel: .debug, "雇用形態:\(types)")
                
                text = types
            case 5:
                // 給与
//                title = data.salary.title!
                title = "給与"
                text = data.salary
            case 6:
                // 勤務時間
//                title = data.jobtime.title!
                title = "勤務時間"
                text = data.jobtime
            case 7:
                // 勤務地
//                title = data.workPlace.title!
                title = "勤務地"
                text = data.workPlace
            case 8:
                // 休日休暇
//                title = data.holiday.title!
                title = "休日休暇"
                text = data.holiday
            case 9:
                // 待遇・福利厚生
//                title = data.welfare.title!
                title = "待遇・福利厚生"
                text = data.welfare
            default:
                title = ""
                text = ""
        }
        titleLabel.text(text: title, fontType: .font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        self.indispensableLabel.text(text: text, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        // 任意
        var optionalDatas:[[String:Any]] = []
        switch row {
            case 0:
                // 案件例
                if data.jobExample.count > 0 {
//                    let exampleData = ["title":data.jobExample.title,"text":data.jobExample.text]
                    let exampleData = ["title":"案件例","text":data.jobExample]
                    optionalDatas.append(exampleData)
                }
                // 手がける商品・サービス
                if data.product.count > 0 {
//                    let productData = ["title":data.product.title,"text":data.product.text]
                    let productData = ["title":"手がける商品・サービス","text":data.product]
                    optionalDatas.append(productData)
                }
                // 開発環境
                if data.scope.count > 0 {
//                    let scopeData = ["title":data.scope.title,"text":data.scope.text]
                    let scopeData = ["title":"開発環境・業務範囲","text":data.scope]
                    optionalDatas.append(scopeData)
                }
            case 1:
                // 歓迎するスキル
                if data.betterSkill.count > 0 {
//                    let title = data.betterSkill.title!
                    let text = data.betterSkill
//                    let skillData:[String: Any] = ["title": title, "text": text]
                    let skillData:[String: Any] = ["title": "歓迎する経験・スキル", "text": text]
                    optionalDatas.append(skillData)
                }
                // 過去の採用例
                if data.applicationExample.count > 0 {
//                    let title = data.applicationExample.title!
                    let text = data.applicationExample
//                    let applicationExampleData = ["title":title, "text": text]
                    let applicationExampleData = ["title":"過去の採用例", "text": text]
                    optionalDatas.append(applicationExampleData)
                }
                // この仕事の向き・不向き
                let _suitableUnsuitable = data.suitableUnsuitable
                let _notSuitableUnsuitable = data.notSuitableUnsuitable
//                Log.selectLog(logLevel: .debug, "_suitableUnsuitable:\(_suitableUnsuitable)")
//                Log.selectLog(logLevel: .debug, "_notSuitableUnsuitable:\(_notSuitableUnsuitable)")
                
                if _suitableUnsuitable.count > 0 && _notSuitableUnsuitable.count > 0 {
                    var sumText:String = "向いている人\n"
                    sumText += _suitableUnsuitable
                    sumText += "\n"
                    sumText += "向いていない人\n"
                    sumText += _notSuitableUnsuitable
//                    let text = data.suitableUnsuitable
//                    let suitableUnsuitableData = ["title": title, "text": text]
                    let suitableUnsuitableData = ["title": "この仕事の向き・不向き", "text": sumText]
                    optionalDatas.append(suitableUnsuitableData)
                }
            case 3:
                // 賞与について
                if data.bonusAbout.count > 0 {
//                    let title = data.bonusAbout.title!
                    let text = data.bonusAbout
//                    let bonusAboutData = ["title":title,"text":text]
                    let bonusAboutData = ["title":"賞与について","text":text]
                    optionalDatas.append(bonusAboutData)
                }
            case 4:
                // 残業について
                if data.overtimeAbout.count > 0 {
//                    let title = data.overtimeAbout.title!
                    let text = data.overtimeAbout
//                    let overtimeAboutData = ["title":title,"text":text]
                    let overtimeAboutData = ["title":"残業について","text":text]
                    optionalDatas.append(overtimeAboutData)
                }
                // 残業時間目安
                if data.overtimeCode > 0 {
                    
                    let code = SelectItemsManager.getCodeDisp(.overtime, code: data.overtimeCode)?.disp ?? ""
                    let text = code
                    if text.count > 0 {
                        let overtimeCodeData = ["title":"残業時間目安", "text":text]
                        optionalDatas.append(overtimeCodeData as [String : Any])
                    }
                }
            case 5:
                // 交通・詳細
                if data.transport.count > 0 {
//                    let title = data.transport.title!
                    let text = data.transport
//                    let transportData = ["title":title,"text":text]
                    let transportData = ["title":"交通・詳細","text":text]
                    optionalDatas.append(transportData)
                }
            case 7:
                // 産休・育休取得状況
                if data.childcare.count > 0 {
//                    let title = data.childcare.title!
                    let text = data.childcare
//                    let childcareData = ["title":title,"text":text]
                    let childcareData = ["title":"産休・育休取得状況","text":text]
                    optionalDatas.append(childcareData)
                }
            default:
                optionalDatas = []
        }
        
        if optionalDatas.count > 0 {
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
        } else {
//            Log.selectLog(logLevel: .debug, "任意用Viewは他は入らない")
        }
        
        // 注目
        /*
        var attentionDatas:[[String:Any]] = []
        if row == 0 {
            let spotTitle1 = data.spotTitle1
            let spotDetail1 = data.spotDetail1
            
            let spotTitle2 = data.spotTitle2
            let spotDetail2 = data.spotDetail2
            
            let spot1 = ["title":spotTitle1,"text":spotDetail1]
            let spot2 = ["title":spotTitle2,"text":spotDetail2]
            
            if spotTitle1.count > 0 && spotDetail1.count > 0 {
                attentionDatas.append(spot1)
            }
            
            if spotTitle2.count > 0 && spotDetail2.count > 0 {
                attentionDatas.append(spot2)
            }
            
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
//            Log.selectLog(logLevel: .debug, "注目用Viewは他は入らない")
        }
        */
    }
}
