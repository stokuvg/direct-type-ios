//
//  JobDetailPRCodeTagsCell.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class JobDetailPRCodeTagsCell: BaseTableViewCell {
    
    @IBOutlet weak var tagsView:TagsView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(prcodeNos:[Int]){
//    func setup(datas:[String]) {
        changeTagsViewSize()
        subViewsRemove()
        
        var datas:[String] = []
        for i in 0..<prcodeNos.count {
            let prCodeNo = prcodeNos[i]
            let prCode:String = (SelectItemsManager.getCodeDisp(.prCode, code: prCodeNo)?.disp)!
            Log.selectLog(logLevel: .debug, "prCode:\(prCode)")
            
            var prCodeString:String = ""
            if prCode.hasPrefix("#") {
                prCodeString = prCode.replacingOccurrences(of: "#", with: "")
            } else {
                prCodeString = prCode
            }
            datas.append(prCodeString)
        }
        
        tagsView.setKind(datas: datas, frame: tagsView.frame)
    }
        
    private func subViewsRemove() {
//        Log.selectLog(logLevel: .debug, "JobDetailPRCodeTagsCell subViewsRemove start")
        if (tagsView != nil) {
            for _sub in tagsView.subviews {
//                Log.selectLog(logLevel: .debug, "_sub:\(_sub)")
                if _sub is TagLabel {
//                if _sub is TagButton {
                    _sub.removeFromSuperview()
                }
            }
        } else {
//            Log.selectLog(logLevel: .debug, "tagViewがセットされていない")
        }
    }
    
    private func changeTagsViewSize() {
        var tagFrame = tagsView.frame
        tagFrame.size.width = self.frame.size.width - (tagsView.frame.origin.x * 2)
        tagsView.frame = tagFrame
    }
}
