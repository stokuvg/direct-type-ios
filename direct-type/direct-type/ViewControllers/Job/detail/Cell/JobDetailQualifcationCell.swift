//
//  JobDetailQualifcationCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient
import TudApi

class JobDetailQualifcationCell: BaseJobDetailCell {

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
    
    func setup(data: MdlJobCardDetail) {
//    func setup(data:[String:Any]) {
        
        var title:String = ""
        var text:String = ""
        
        title = "応募資格"
        text = data.qualification
        titleLabel.text(text: title, fontType: .font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
//        Log.selectLog(logLevel: .debug, "text:\(text)")
        self.indispensableLabel.text(text: text, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        // 任意
        var optionalDatas:[[String:Any]] = []
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
    }
}
