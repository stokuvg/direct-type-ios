//
//  Validate+Base.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/10.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

extension ValidateManager {
    class func makeGrpErrByItemErr(_ dicError: [EditableItemKey: [String]]) -> ([MdlItemHTypeKey: [String]]) {
        var dicGrpError: [MdlItemHTypeKey: [String]] = [:]
        for (key, val) in dicError {
            switch key {
            //===プロフィール
            case EditItemMdlProfile.familyName.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.fullnameH2.itemKey, val: val)
            case EditItemMdlProfile.firstName.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.fullnameH2.itemKey, val: val)
            case EditItemMdlProfile.familyNameKana.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.fullnameH2.itemKey, val: val)
            case EditItemMdlProfile.firstNameKana.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.fullnameH2.itemKey, val: val)
            case EditItemMdlProfile.birthday.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.birthGenderH2.itemKey, val: val)
            case EditItemMdlProfile.gender.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.birthGenderH2.itemKey, val: val)
            case EditItemMdlProfile.zipCode.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.adderssH2.itemKey, val: val)
            case EditItemMdlProfile.prefecture.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.adderssH2.itemKey, val: val)
            case EditItemMdlProfile.address1.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.adderssH2.itemKey, val: val)
            case EditItemMdlProfile.address2.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.adderssH2.itemKey, val: val)
            case EditItemMdlProfile.mailAddress.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.emailH2.itemKey, val: val)
            case EditItemMdlProfile.mobilePhoneNo.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.mobilephoneH2.itemKey, val: val)

            //===[A系統]初期入力
            case EditItemMdlFirstInput.nickname.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.nicknameA6.itemKey, val: val)
            case EditItemMdlFirstInput.gender.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.genderA7.itemKey, val: val)
            case EditItemMdlFirstInput.birthday.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.birthdayA8.itemKey, val: val)
            case EditItemMdlFirstInput.hopeArea.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.hopeAreaA9.itemKey, val: val)
            case EditItemMdlFirstInput.school.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.schoolA10.itemKey, val: val)
            case EditItemMdlFirstInput.employmentStatus.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.employmentStatusA21.itemKey, val: val)
            //表示項目としてはセットで扱うのでまとめて定義
            case EditItemMdlFirstInputLastJobExperiments.jobTypeAndJobExperimentYear.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.lastJobExperimentA11.itemKey, val: val)

            case EditItemMdlFirstInput.salary.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.salaryA13.itemKey, val: val)
            //表示項目としてはセットで扱うのでまとめて定義
            case EditItemMdlFirstInputJobExperiments.jobTypeAndJobExperimentYear.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.jobExperimentsA14.itemKey, val: val)

            //===[C-15]「職務経歴書確認」＊単独
            case EditItemMdlCareerCardWorkPeriod.startDate.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.workPeriodC15.itemKey, val: val)
            case EditItemMdlCareerCardWorkPeriod.endDate.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.workPeriodC15.itemKey, val: val)
            case EditItemMdlCareerCard.companyName.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.companyNameC15.itemKey, val: val)
            case EditItemMdlCareerCard.employmentType.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.employmentTypeC15.itemKey, val: val)
            case EditItemMdlCareerCard.employeesCount.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.employeesCountC15.itemKey, val: val)
            case EditItemMdlCareerCard.salary.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.salaryC15.itemKey, val: val)
            case EditItemMdlCareerCard.contents.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.contentsC15.itemKey, val: val)
                    
            //===[H-3]「履歴書確認」
            //case employmentH3           //===(3a)就業状況
            case EditItemMdlResume.employmentStatus.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.employmentH3.itemKey, val: val)
            //case changeCountH3          //===(3b)転職回数
            case EditItemMdlResume.changeCount.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.changeCountH3.itemKey, val: val)
            //case lastJobExperimentH3    //===(3c)直近の経験職種
            case EditItemMdlResume.lastJobExperiment.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.lastJobExperimentH3.itemKey, val: val)
            case EditItemMdlResumeLastJobExperiment.jobTypeAndJobExperimentYear.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.lastJobExperimentH3.itemKey, val: val)
            //case jobExperimentsH3       //===(3d)その他の経験職種
            case EditItemMdlResume.jobExperiments.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.jobExperimentsH3.itemKey, val: val)
            case EditItemMdlResumeJobExperiments.jobTypeAndJobExperimentYear.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.jobExperimentsH3.itemKey, val: val)
            //case businessTypesH3        //===(3e)経験業種
            case EditItemMdlResume.businessTypes.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.businessTypesH3.itemKey, val: val)
            //case schoolH3               //===(3f)最終学歴
            case EditItemMdlResume.school.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.schoolH3.itemKey, val: val)
            case EditItemMdlResumeSchool.schoolName.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.schoolH3.itemKey, val: val)
            case EditItemMdlResumeSchool.faculty.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.schoolH3.itemKey, val: val)
            case EditItemMdlResumeSchool.department.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.schoolH3.itemKey, val: val)
            case EditItemMdlResumeSchool.graduationYear.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.schoolH3.itemKey, val: val)
            //case skillLanguageH3        //===(3g)語学
            case EditItemMdlResume.skillLanguage.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.skillLanguageH3.itemKey, val: val)
            case EditItemMdlResumeSkillLanguage.languageToeicScore.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.skillLanguageH3.itemKey, val: val)
            case EditItemMdlResumeSkillLanguage.languageToeflScore.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.skillLanguageH3.itemKey, val: val)
            case EditItemMdlResumeSkillLanguage.languageEnglish.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.skillLanguageH3.itemKey, val: val)
            case EditItemMdlResumeSkillLanguage.languageStudySkill.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.skillLanguageH3.itemKey, val: val)
            //case qualificationsH3       //===(3h)資格
            case EditItemMdlResume.qualifications.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.qualificationsH3.itemKey, val: val)
            //case ownPrH3                //===(3i)自己PR
            case EditItemMdlResume.ownPr.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.ownPrH3.itemKey, val: val)

            //======応募フォーム
            case EditItemMdlEntry.ownPR.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.ownPRC9.itemKey, val: val)
            case EditItemMdlEntry.hopeArea.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.hopeAreaC9.itemKey, val: val)
            case EditItemMdlEntry.hopeSalary.itemKey: dicGrpError.addDicArrVal(key: HPreviewItemType.hopeSalaryC9.itemKey, val: val)

                
                
            default:
                print("\t☠️割り当てエラー☠️[\(key): \(val)]☠️")
            }
        }
        return dicGrpError
    }
}
