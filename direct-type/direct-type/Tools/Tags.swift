//
//  Tags.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/13.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class TagLabel: UILabel {
    let tagPadding: CGFloat = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        layer.cornerRadius = 5
//        layer.borderColor = UIColor.lightGray.cgColor
//        layer.borderWidth = 1
        
        textColor = UIColor.lightGray
        clipsToBounds = true
        numberOfLines = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets(top: tagPadding, left: tagPadding, bottom: tagPadding, right: tagPadding)
        return super.drawText(in:rect.inset(by: insets))
    }
    
    func setKindDesign(text:String,tagFont:UIFont) {
//        self.layer.borderWidth = 1
        
        self.text(text: text, fontType: .font_SS, textColor: UIColor.init(colorType: .color_parts_gray)!, alignment: .left)
        
    }
}

class TagsView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func placeTagsOn(tagsView: UIView, tags:[[String:Any]]) {
        
    }
    
//    func setKind(datas:[String], frame: CGRect, sizeType:SizeType = .normal) {
    func setKind(datas:[String], frame: CGRect, tagFont:UIFont) {
        let areaWidth = frame.size.width
//        let areaHeight = frame.size.height
        
        let tagMargin: CGFloat = 2
        
        var tagFont:UIFont!
        tagFont = UIFont.init(fontType: .font_SS)
        
        let tagHeight = tagFont!.lineHeight + TagLabel().tagPadding * 2
        
        var tagOriginX: CGFloat = 0
        var tagOriginY: CGFloat = 0
        
//        Log.selectLog(logLevel: .debug, "datas:\(datas)")
        
        /*
        let dummyDatas:[String] = [
            "採用予定人数5名以上",
            "ワーキングマザーが在籍",
            "理系出身者歓迎",
            "新規事業・スタートアップメンバー",
            "設立5年以内",
        ]
        */
        
        var addEndFlag:Bool = false
        
        for i in 0..<datas.count {
//        for i in 0..<dummyDatas.count {
//            let tagText = "#" + dummyDatas[i]
            let tagText = "#" + datas[i]
            var tagWidth = tagKindTextWidth(text: tagText, font: tagFont!, height: tagHeight)
            
            if tagWidth > areaWidth {
                tagWidth = areaWidth
            }
            
            if areaWidth - tagOriginX < tagWidth {
                tagOriginX = 0
                tagOriginY += tagHeight + tagMargin
                
//                Log.selectLog(logLevel: .debug, "tagOriginY:\(tagOriginY)")
//                Log.selectLog(logLevel: .debug, "frame:\(frame)")
                
                if tagOriginY >= (frame.size.height - tagHeight) {
                    addEndFlag = true
                }
            }
            
            if addEndFlag {
                // 行数より多くなった場合は追加終了
                break
            } else {
                
                let label = TagLabel(frame: CGRect(x: tagOriginX, y: tagOriginY, width: tagWidth, height: tagHeight))
                
                label.setKindDesign(text: tagText, tagFont: tagFont!)
                if addEndFlag {
                    break
                } else {
                    self.addSubview(label)
                    tagOriginX += tagWidth + tagMargin
                }
            }
        }
    }
    
    func tagKindTextWidth(text:String, font: UIFont, height:CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.size.width + TagLabel().tagPadding * 2
    }
}
