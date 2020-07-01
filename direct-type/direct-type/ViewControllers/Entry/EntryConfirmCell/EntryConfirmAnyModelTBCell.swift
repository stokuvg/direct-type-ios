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

    private func addStackItem(type: HPreviewItemType, val: String) {
        stackVW.addArrangedSubview(EntryConfirmItem(type.dispTitle, val))
    }
    private func addStackItem(type: HPreviewItemType, val: [String]) {
        stackVW.addArrangedSubview(EntryConfirmItem(type.dispTitle, val.joined(separator: "\n")))
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
                //===(3a)就業状況
                if let cd = SelectItemsManager.getCodeDisp(.employmentStatus, code: resume.employmentStatus) {
                    addStackItem(type: .employmentH3, val: cd.disp)
                }
                //===(3b)転職回数
                if let cd = SelectItemsManager.getCodeDisp(.changeCount, code: resume.changeCount) {
                    addStackItem(type: .changeCountH3, val: cd.disp)
                }
                //===(3c)直近の経験職種
                if let cd = SelectItemsManager.getCodeDispSyou(.jobType, code: resume.lastJobExperiment.jobType),
                let cd2 = SelectItemsManager.getCodeDisp(.jobExperimentYear, code: resume.lastJobExperiment.jobExperimentYear) {
                    addStackItem(type: .lastJobExperimentH3, val: "\(cd.disp) \(cd2.disp)")
                }
                //===(3d)その他の経験職種
                var disp3d: [String] = []
                for jy in resume.jobExperiments {
                    if let cd = SelectItemsManager.getCodeDispSyou(.jobType, code: jy.jobType),
                    let cd2 = SelectItemsManager.getCodeDisp(.jobExperimentYear, code: jy.jobExperimentYear) {
                        disp3d.append("\(cd.disp) \(cd2.disp)")
                    }
                }
                addStackItem(type: .jobExperimentsH3, val: disp3d)
                //===(3e)経験業種
                var disp3e: [String] = []
                for tmp in resume.businessTypes {
                    if let cd = SelectItemsManager.getCodeDispSyou(.businessType, code: tmp) {
                        disp3e.append("\(cd.disp)")
                    }
                }
                addStackItem(type: .businessTypesH3, val: disp3e)
                //===(3f)最終学歴
                var disp3f: [String] = []
                if !resume.school.schoolName.isEmpty {
                    disp3f.append(resume.school.schoolName)
                }
                if !(resume.school.faculty.isEmpty && resume.school.department.isEmpty) {
                    disp3f.append("\(resume.school.faculty)\(resume.school.department)")
                }
                let _graduationYear = DateHelper.convStrYM2Date(resume.school.graduationYear)
                if _graduationYear != Constants.SelectItemsUndefineDate {
                    disp3f.append(_graduationYear.dispYmJP())
                }
                addStackItem(type: .schoolH3, val: disp3f)
                //===(3g)語学
                var disp3g: [String] = []
                let tmpToeic = Int(resume.skillLanguage.languageToeicScore) ?? 0
                let tmoToefl = Int(resume.skillLanguage.languageToeflScore) ?? 0
                let bufToeic = (tmpToeic == 0) ? "--" : "\(tmpToeic)"
                let bufToefl = (tmoToefl == 0) ? "--" : "\(tmoToefl)"
                disp3g.append("TOEIC：\(bufToeic) / TOEFL：\(bufToefl)")
                if let cd = SelectItemsManager.getCodeDisp(.skillEnglish, code: resume.skillLanguage.languageEnglish) {
                    disp3g.append(cd.disp)
                }
                if !resume.skillLanguage.languageStudySkill.isEmpty {
                    disp3f.append(resume.skillLanguage.languageStudySkill)
                }
                addStackItem(type: .skillLanguageH3, val: disp3g)
                //===(3h)資格
                var disp3h: [String] = []
                for val in resume.qualifications {
                    if let cd = SelectItemsManager.getCodeDispSyou(.skill, code: val) {
                        disp3h.append(cd.disp)
                    }
                }
                addStackItem(type: .jobExperimentsH3, val: disp3h)
                //===(3i)自己PR
                if !resume.ownPr.isEmpty {
                    addStackItem(type: .ownPrH3, val: resume.ownPr)
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
