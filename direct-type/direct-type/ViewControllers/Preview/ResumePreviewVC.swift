//
//  ResumePreviewVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

//===[H-3]「履歴書確認」
class ResumePreviewVC: PreviewBaseVC {
    var detail: MdlResume? = nil

    //共通プレビューをOverrideして利用する
    override func initData() {
        //ダミーデータ投入しておく
        let resume: Resume = Resume(
            employment: 1,
            changeCount: 1,
            lastJobExperiment: ResumeLastJobExperiment(jobType: 5, jobExperimentYear: 5),
            jobExperiments: [
                ResumeJobExperiments(jobType: 2, jobExperimentYear: 2),
                ResumeJobExperiments(jobType: 3, jobExperimentYear: 3),
                ResumeJobExperiments(jobType: 4, jobExperimentYear: 4),
            ],
            businessTypes: [1, 2, 3, 4, 5, 6, 77, 8, 9],
            school: ResumeSchool(schoolName: "情報大学", department: "情報学部", subject: "情報学科", guraduationYear: "1996-12"),
            skillLanguage: ResumeSkillLanguage(languageToeicScore: nil, languageToeflScore: "431",
                                               languageEnglish: "1", languageStudySkill: "その他、スペイン語など"),
            qualifications: [1, 2, 3, 4],
            ownPr: String(repeating: "自己PRのテキストが入ります。", count: 38) )
        detail = MdlResume(dto: resume)
        //========
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        guard let _detail = detail else { return }
        print(_detail.debugDisp)

        //=== [H-3]履歴書編集
        //===(3a)就業状況
        arrData.append(MdlItemH(.employmentH3, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResume.employment, val: _detail.employment),
        ]))
        //===(3b)転職回数
        arrData.append(MdlItemH(.changeCountH3, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResume.changeCount, val: _detail.changeCount),
        ]))
        //===(3c)直近の経験職種
        let _jobType: String = "\(_detail.lastJobExperiment.jobType)"
        arrData.append(MdlItemH(.lastJobExperimentH3, "11", childItems: [
            EditableItemH(type: .selectSpecisl, editItem: EditItemMdlResumeLastJobExperiment.jobType, val: _jobType),
            EditableItemH(type: .selectDrumYMD, editItem: EditItemMdlResumeLastJobExperiment.jobExperimentYear, val: _detail.lastJobExperiment.jobExperimentYear),
        ]))
        //===(3d)その他の経験職種
        var _jobExperiments: [EditableItemH] = []
        for jobExperiment in _detail.jobExperiments {
            _jobExperiments.append(EditableItemH(type: .selectSpecisl, editItem: EditItemMdlResumeJobExperiments.jobType, val: jobExperiment.jobType))
            _jobExperiments.append(EditableItemH(type: .selectDrum, editItem: EditItemMdlResumeJobExperiments.jobExperimentYear, val: jobExperiment.jobExperimentYear))
        }
        arrData.append(MdlItemH(.jobExperimentsH3, "", childItems: _jobExperiments))
        //===(3e)経験業種
        var _businessTypes: [EditableItemH] = []
        for businessType in _detail.businessTypes {
            print(businessType)
            _businessTypes.append(EditableItemH(type: .selectDrum, editItem: EditItemMdlResume.businessTypes, val: businessType))
        }
        arrData.append(MdlItemH(.businessTypesH3, "", childItems: _businessTypes))
        //===(3f)最終学歴
        arrData.append(MdlItemH(.schoolH3, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSchool.schoolName, val: _detail.school.schoolName),
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSchool.department, val: _detail.school.department),
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSchool.subject, val: _detail.school.subject),
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSchool.guraduationYear, val: _detail.school.guraduationYear),
        ]))
        //===(3g)語学
        arrData.append(MdlItemH(.skillLanguageH3, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSkillLanguage.languageToeicScore, val: _detail.skillLanguage.languageToeicScore),
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSkillLanguage.languageToeflScore, val: _detail.skillLanguage.languageToeflScore),
            EditableItemH(type: .selectDrum, editItem: EditItemMdlResumeSkillLanguage.languageEnglish, val: _detail.skillLanguage.languageEnglish),
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSkillLanguage.languageStudySkill, val: _detail.skillLanguage.languageStudySkill),
        ]))
        //===(3h)資格
        var _qualifications: [EditableItemH] = []
        for qualifications in _detail.qualifications {
            _qualifications.append(EditableItemH(type: .selectDrum, editItem: EditItemMdlResume.qualifications, val: qualifications))
        }
        arrData.append(MdlItemH(.qualificationsH3, "", childItems: _qualifications))
        //===(3i)自己PR
        arrData.append(MdlItemH(.ownPr, "", childItems: [
            EditableItemH(type: .inputMemo, editItem: EditItemMdlResume.ownPr, val: _detail.ownPr),
        ]))
        
    }
    override func dispData() {
        title = "履歴書"
    }
}

