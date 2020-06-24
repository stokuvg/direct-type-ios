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
        //=== チェック対象の項目の確認）
        //入力状況：加点
        //初回入力完了時点：40%
        //氏名の入力：20%
        //住所の入力：20%
        //メールアドレスの入力：20%
        var progress: Int = 0   //部分項目確定はできないので、実質、0/40/100 にしかならない
        if let model = self.detail as? MdlProfile {
            progress += 40
            if ( !model.familyName.isEmpty &&
                !model.familyName.isEmpty &&
                !model.familyName.isEmpty &&
                !model.familyName.isEmpty ) {
                progress += 20
            }
            if ( !model.zipCode.isEmpty &&
                !model.prefecture.isEmpty &&
                (!model.address1.isEmpty || !model.address2.isEmpty) ) {
                progress += 20
            }
            if ( !model.mailAddress.isEmpty) {
                progress += 20
            }
        }
        print(#line, #function, "[progress: \(progress)]")
        return (progress == 100) ? true : false
    }
private func chkProgressResumee() -> Bool {
        //入力状況：加点
        //初回入力完了時点：35%
        //経験業種：10%（必須じゃない）
        //最終学歴：15%
        //語学：10%（必須じゃない）
        //資格：15%（必須じゃない）
        //自己PR：15%（必須じゃない）
        var progress: Int = 0
        if let model = self.detail as? MdlResume {
            progress += 35
            if ( !model.businessTypes.isEmpty ) {
                progress += 20
            }
            if ( !model.skillLanguage.languageToeicScore.isEmpty ||
                !model.skillLanguage.languageToeflScore.isEmpty ||
                !model.skillLanguage.languageEnglish.isEmpty ||
                !model.skillLanguage.languageStudySkill.isEmpty ) {
                progress += 10
            }
            let _graduationYear = DateHelper.convStrYM2Date(model.school.graduationYear)
            if ( !model.school.schoolName.isEmpty &&
                !model.school.department.isEmpty &&
                !(_graduationYear == Constants.SelectItemsUndefineDate) ) {
                progress += 15
            }
            if ( !model.ownPr.isEmpty) {
                progress += 15
            }
        }
        print(#line, #function, "[progress: \(progress)]")
        return (progress == 100) ? true : false
    }
    private func chkProgressCareer() -> Bool {
        var progress: Int = 0
        if let model = self.detail as? MdlResume {
            progress += 35
        }
        print(#line, #function, "[progress: \(progress)]")
        return true
    }

}

