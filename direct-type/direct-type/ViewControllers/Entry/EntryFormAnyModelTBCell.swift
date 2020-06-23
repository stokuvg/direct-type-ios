//
//  EntryFormAnyModelTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/23.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class EntryFormAnyModelTBCell: UITableViewCell {
    var detail: Any? = nil
    var type: HPreviewItemType = .undefine
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var vwTitleArea: UIView!
    @IBOutlet weak var vwMessageArea: UIView!
    @IBOutlet weak var vwIconArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        //===デザイン適用
        self.backgroundColor = UIColor(colorType: .color_base)//Clearにしたとき、こちらが透過される
        vwMainArea.backgroundColor = UIColor(colorType: .color_base)
        vwTitleArea.backgroundColor = .clear
        vwMessageArea.backgroundColor = .clear
        vwIconArea.backgroundColor = .clear
    }
    func initCell(_ type: HPreviewItemType, model: Any?) {
        self.type = type
        self.detail = model
    }
    
    func dispCell() {
        switch type {
        case .profileC9:
            lblTitle.text(text: "プロフィール", fontType: .font_Sb, textColor: .black, alignment: .left)
            if let model = self.detail as? MdlProfile {
                //未入力チェック
                if true {
                    vwMessageArea.isHidden = false
                } else {
                    vwMessageArea.isHidden = true
                }
            }
        case .resumeC9:
            lblTitle.text(text: "履歴書", fontType: .font_Sb, textColor: .black, alignment: .left)
            if let model = self.detail as? MdlProfile {
                //未入力チェック
                if true {
                    vwMessageArea.isHidden = false
                } else {
                    vwMessageArea.isHidden = true
                }
            }
        case .careerC9:
            lblTitle.text(text: "職務経歴書", fontType: .font_Sb, textColor: .black, alignment: .left)
            if let model = self.detail as? MdlProfile {
                //未入力チェック
                if true {
                    vwMessageArea.isHidden = false
                } else {
                    vwMessageArea.isHidden = true
                }
            }
        default:
            lblTitle.text = "【未実装】"
        }
        
//        ③メインスクリーンエリア
//            背景色：color-base
//
//        ④見出し文字　※スクリーン単位の仕様書独自の記載がなければ原則
//            文字：font-Sb
//            色：color-black
//            センタリング、１行で収まらなければ改行
//                    
//        ⑤注釈文字　※スクリーン単位の仕様書独自の記載がなければ原則
//            文字：font-SS
//            色：color-parts-grau
//            センタリング、１行で収まらなければ改行
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
