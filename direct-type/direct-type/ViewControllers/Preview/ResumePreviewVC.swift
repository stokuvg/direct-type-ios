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
            businessTypes: [],
            school: ResumeSchool(schoolName: "", department: "", subject: "", guraduationYear: ""),
            skillLanguage: ResumeSkillLanguage(languageToeicScore: nil, languageToeflScore: nil,
                                               languageEnglish: "", languageStudySkill: ""),
            qualifications: [],
            ownPr: "")
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
            EditableItemH(type: .selectDrum, editItem: EditItemMdlResumeLastJobExperiment.jobType, val: _jobType),
            EditableItemH(type: .selectDrumYMD, editItem: EditItemMdlResumeLastJobExperiment.jobExperimentYear, val: _detail.lastJobExperiment.jobExperimentYear),
        ]))
        //===(3d)その他の経験職種
        arrData.append(MdlItemH(.jobExperimentsH3, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResume.employment, val: _detail.employment),
        ]))
        //===(3e)経験業種
        arrData.append(MdlItemH(.businessTypesH3, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResume.employment, val: _detail.employment),
        ]))
        //===(3f)最終学歴
        arrData.append(MdlItemH(.schoolH3, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResume.employment, val: _detail.employment),
        ]))
        //===(3g)語学
        arrData.append(MdlItemH(.skillLanguageH3, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResume.employment, val: _detail.employment),
        ]))
        //===(3h)資格
        arrData.append(MdlItemH(.qualificationsH3, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResume.employment, val: _detail.employment),
        ]))
        //===(3i)自己PR
        arrData.append(MdlItemH(.ownPr, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResume.employment, val: _detail.employment),
        ]))
        
    }
    override func dispData() {
        title = "履歴書"
    }
}

