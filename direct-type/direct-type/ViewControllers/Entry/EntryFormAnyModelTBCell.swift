//
//  EntryFormAnyModelTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/23.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension EntryFormAnyModelTBCell {
    enum EntryFormModelType {
        case profile
        case resume
        case career
    }
}

class EntryFormAnyModelTBCell: UITableViewCell {
    var detail: Any? = nil
    var type: EntryFormModelType = .profile
    
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
    func initCell(_ type: EntryFormModelType, model: Any?) {
        self.type = type
        self.detail = model
    }
    func dispCell() {
        switch type {
        case .profile:
            lblTitle.text(text: "プロフィール", fontType: .font_Sb, textColor: .black, alignment: .left)
            lblMessage.text(text: "未入力", fontType: .font_SS, textColor: UIColor(colorType: .color_sub)!, alignment: .left)
            if let model = self.detail as? MdlProfile {
                if chkProgressProfile() {
                    lblMessage.text(text: "入力済み", fontType: .font_SS, textColor: UIColor(colorType: .color_parts_gray)!, alignment: .left)
                }
            }
        case .resume:
            lblTitle.text(text: "履歴書", fontType: .font_Sb, textColor: .black, alignment: .left)
            lblMessage.text(text: "未入力", fontType: .font_SS, textColor: UIColor(colorType: .color_sub)!, alignment: .left)
            if let model = self.detail as? MdlResume {
                if chkProgressResumee() {
                    lblMessage.text(text: "入力済み", fontType: .font_SS, textColor: UIColor(colorType: .color_parts_gray)!, alignment: .left)
                }
            }
        case .career:
            lblTitle.text(text: "職務経歴書", fontType: .font_Sb, textColor: .black, alignment: .left)
            lblMessage.text(text: "未入力", fontType: .font_SS, textColor: UIColor(colorType: .color_sub)!, alignment: .left)
            if let model = self.detail as? MdlCareer {
                if chkProgressCareer() {//未入力チェック
                    lblMessage.text(text: "入力済み", fontType: .font_SS, textColor: UIColor(colorType: .color_parts_gray)!, alignment: .left)
                }
            }
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
//            色：color-parts-gray
//            センタリング、１行で収まらなければ改行
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//TODO: 入力済かのチェック（初回入力で生成されるも、必須項目が全て入っていないケースに対応させる必要あり）
extension EntryFormAnyModelTBCell {
    private func chkProgressProfile() -> Bool {
        return true
    }
    private func chkProgressResumee() -> Bool {
        return true
    }
    private func chkProgressCareer() -> Bool {
        return true
    }

}

