//
//  EntryConfirmAnyModelTBCell.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/30.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension EntryConfirmAnyModelTBCell {
    enum EntryFormModelType {
        case profile
        case resume
        case career
    }
}

class EntryConfirmAnyModelTBCell: UITableViewCell {
    var detail: Any? = nil
    var type: EntryFormModelType = .profile
    
    @IBOutlet weak var vwBoardArea: UIView!
    @IBOutlet weak var vwBoardSafeArea: UIView!

    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var vwHeadArea: UIView!
    @IBOutlet weak var vwTitleArea: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwStackArea: UIView!
    @IBOutlet weak var stackVW: UIStackView!
    @IBOutlet weak var vwFootArea: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = false //表示のみでタップ不可
        //===デザイン適用
        backgroundColor = UIColor(colorType: .color_base)
        vwBoardArea.backgroundColor = .white
        vwBoardArea.cornerRadius = 16
        vwBoardArea.clipsToBounds = true
        vwBoardArea.borderColor = UIColor(colorType: .color_line)!
        vwBoardArea.borderWidth = 1
    }
    func initCell(_ type: EntryFormModelType, model: Any?) {
        self.type = type
        self.detail = model
    }
    
    func dispCell() {
        var bufTitle: String = ""
        switch type {
        case .profile:  bufTitle = "プロフィール"
        case .resume:   bufTitle = "履歴書"
        case .career:   bufTitle = "業務経歴書"
        }
        lblTitle.text(text: bufTitle, fontType: .font_Sb, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        lblTitle.updateConstraints()

        //=== 既存部品の全削除
        for asv in stackVW.arrangedSubviews {
            stackVW.removeArrangedSubview(asv)
            asv.removeFromSuperview()
        }
        //=== 表示項目を追加していく
        switch type {
        case .profile:
            if let profile = self.detail as? MdlProfile {
                let bufFullname: String = "\(profile.familyName) \(profile.firstName)"
                let bufFullnameKana: String = "\(profile.familyNameKana) \(profile.firstNameKana)"
                let dispName = "\(bufFullname)（\(bufFullnameKana)）"
                stackVW.addArrangedSubview(EntryConfirmItem("名前", "\(dispName)"))
                let bufBirthday: String = profile.birthday.dispYmdJP()
                let bufAge: String = "\(profile.birthday.age)歳"
                let dispBirthday: String = "\(bufBirthday)（\(bufAge)）"
                stackVW.addArrangedSubview(EntryConfirmItem("生年月日", "\(dispBirthday)"))
                let tmpGender: String = profile.gender
                let bufGender: String = SelectItemsManager.getCodeDisp(.gender, code: tmpGender)?.disp ?? "--"
                let dispGender: String = " \(bufGender)"
                stackVW.addArrangedSubview(EntryConfirmItem("性別", "\(dispGender)"))
                let zip: String = profile.zipCode.zeroUme(7)
                let dispZip: String = "〒\(String.substr(zip, 1, 3))-\(String.substr(zip, 4, 4))"
                let bufPlace: String = SelectItemsManager.getCodeDisp(.place, code: profile.prefecture)?.disp ?? ""
                let dispAddress: String = "\(bufPlace)\(profile.address1)\(profile.address2)"
                stackVW.addArrangedSubview(EntryConfirmItem("住所", "\(dispZip)\n\(dispAddress)"))
                let dispMail: String = "\(profile.mailAddress)"
                stackVW.addArrangedSubview(EntryConfirmItem("メールアドレス", "\(dispMail)"))
            }
        case .resume:
            if let resume = self.detail as? MdlResume {
                if let cd = SelectItemsManager.getCodeDisp(.employmentStatus, code: resume.employmentStatus) {
                    stackVW.addArrangedSubview(EntryConfirmItem(EditItemMdlResume.employmentStatus.dispName, cd.disp))
                }




            }
        case .career:
            if let career = self.detail as? MdlCareer {
            }
        }
//        stackVW.addArrangedSubview(EntryConfirmItem("仕事名", "\(bufJobName)"))
//        stackVW.addArrangedSubview(EntryConfirmItem("応募期限", "\(bufDate)"))


        //すべてを表示させる
        for asv in stackVW.arrangedSubviews {
            if let eci = asv as? EntryConfirmItem {
                eci.dispCell()
            }
        }
        stackVW.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
