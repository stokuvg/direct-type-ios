//
//  JobDetailTreatmentCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient
import TudApi

class JobDetailTreatmentCell: BaseJobDetailCell {

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
        
        title = "待遇・福利厚生"
        text = data.welfare
        titleLabel.text(text: title, fontType: .font_M, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
//        Log.selectLog(logLevel: .debug, "text:\(text)")
        self.indispensableLabel.text(text: text, fontType: .C_font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        // 任意
        var optionalDatas:[[String:Any]] = []
        if data.childcare.count > 0 {
//                    let title = data.childcare.title!
            let text = data.childcare
//                    let childcareData = ["title":title,"text":text]
            let childcareData = ["title":"産休・育休取得状況","text":text]
            optionalDatas.append(childcareData)
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
