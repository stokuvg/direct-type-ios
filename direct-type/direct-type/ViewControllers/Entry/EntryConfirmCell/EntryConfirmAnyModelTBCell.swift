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
        case entry
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
        guard val.count > 0 else { return } //0件なら登録しない
        stackVW.addArrangedSubview(EntryConfirmItem(type.dispTitle, val.joined(separator: "\n")))
    }

    func dispCell() {
        var bufTitle: String = ""
        switch type {
        case .profile:  bufTitle = "プロフィール"
        case .resume:   bufTitle = "履歴書"
        case .career:   bufTitle = "業務経歴書"
        case .entry:    bufTitle = "企業向けに送る情報"
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
                addStackItem(type: .fullnameH2, val: dispName)
                let bufBirthday: String = profile.birthday.dispYmdJP()
                let bufAge: String = "\(profile.birthday.age)歳"
                let dispBirthday: String = "\(bufBirthday)（\(bufAge)）"
                addStackItem(type: .birthH2, val: dispBirthday)
                let tmpGender: String = profile.gender
                let bufGender: String = SelectItemsManager.getCodeDisp(.gender, code: tmpGender)?.disp ?? "--"
                let dispGender: String = " \(bufGender)"
                addStackItem(type: .genderH2, val: dispGender)
                let zip: String = profile.zipCode.zeroUme(7)
                let dispZip: String = "〒\(String.substr(zip, 1, 3))-\(String.substr(zip, 4, 4))"
                let bufPlace: String = SelectItemsManager.getCodeDisp(.place, code: profile.prefecture)?.disp ?? ""
                let dispAddress: String = "\(bufPlace)\(profile.address1)\(profile.address2)"
                addStackItem(type: .adderssH2, val: "\(dispZip)\n\(dispAddress)")
                addStackItem(type: .emailH2, val: profile.mailAddress)
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
                    if let cd = SelectItemsManager.getCodeDisp(.qualification, code: val) {
                        disp3h.append(cd.disp)
                    }
                }
                addStackItem(type: .qualificationsH3, val: disp3h)
                //===(3i)自己PR
                if !resume.ownPr.isEmpty {
                    addStackItem(type: .ownPrH3, val: resume.ownPr)
                }
            }
        case .career:
            if let careerList = self.detail as? MdlCareer {
                for (cnt, career) in careerList.businessTypes.enumerated() {
                    //[C-15]職務経歴書編集
                    stackVW.addArrangedSubview(EntryConfirmItem("▼\(cnt + 1)社目", ""))
                    //===企業名
                    if !career.companyName.isEmpty {
                        addStackItem(type: .companyNameC15, val: career.companyName)
                    }
                    //===雇用期間
                    let bufWorkPeriodStart = career.workPeriod.startDate.dispYmJP()
                    var bufWorkPeriodEnd: String = ""
                    if career.workPeriod.endDate == Constants.DefaultSelectWorkPeriodEndDate {
                        bufWorkPeriodEnd = Constants.DefaultSelectWorkPeriodEndDateJP
                    } else {
                        bufWorkPeriodEnd = career.workPeriod.endDate.dispYmJP()
                    }
                    let bufWorkPeriod: String = "\(bufWorkPeriodStart)〜\(bufWorkPeriodEnd)"
                    addStackItem(type: .workPeriodC15, val: bufWorkPeriod)
                    //===雇用形態
                    if let cd = SelectItemsManager.getCodeDispSyou(.employmentType, code: career.employmentType) {
                        addStackItem(type: .employmentTypeC15, val: cd.disp)
                    }
                    //===従業員数（数値）*これは直接数値入力で良い
                    let _employeesCount: Int = Int(career.employeesCount) ?? 0
                    if _employeesCount != 0 {
                        addStackItem(type: .employeesCountC15, val: "\(_employeesCount)")
                    }
                    //===年収
                    if let cd = SelectItemsManager.getCodeDispSyou(.salary, code: career.salary) {
                        addStackItem(type: .salaryC15, val: cd.disp)
                    }
                    //===職務内容本文
                    if !career.contents.isEmpty {
                        addStackItem(type: .contentsC15, val: career.contents)
                    }
                }
            }
        case .entry:
            if let entry = self.detail as? MdlEntry {
                //=== 企業からの質問項目 ===
                if let exQuestion = entry.exQuestion1, !exQuestion.isEmpty {
                    let exAnswer = entry.exAnswer1
                    stackVW.addArrangedSubview(EntryConfirmItem(exQuestion, exAnswer))
                }
                if let exQuestion = entry.exQuestion2, !exQuestion.isEmpty {
                    let exAnswer = entry.exAnswer2
                    stackVW.addArrangedSubview(EntryConfirmItem(exQuestion, exAnswer))
                }
                if let exQuestion = entry.exQuestion3, !exQuestion.isEmpty {
                    let exAnswer = entry.exAnswer3
                    stackVW.addArrangedSubview(EntryConfirmItem(exQuestion, exAnswer))
                }
                //=== 希望勤務地
                var dispHopeArea: [String] = []
                for val in entry.hopeArea {
                    if let cd = SelectItemsManager.getCodeDisp(.entryPlace, code: val) {
                        dispHopeArea.append(cd.disp)
                    }
                }
                addStackItem(type: .hopeAreaA9, val: dispHopeArea)
                //=== 希望年収
                if let cd = SelectItemsManager.getCodeDisp(.salary, code: entry.hopeSalary) {
                    addStackItem(type: .hopeSalaryC9, val: cd.disp)
                }
                //=== 自己PR
                if !entry.ownPR.isEmpty {
                    addStackItem(type: .ownPRC9, val: entry.ownPR)
                }
            }

        }

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
