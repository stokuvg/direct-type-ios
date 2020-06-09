//
//  ResumePreviewVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
//import SwaggerClient
import TudApi
import SVProgressHUD

//===[H-3]「履歴書確認」
class ResumePreviewVC: PreviewBaseVC {
    var detail: MdlResume? = nil

    override func actCommit(_ sender: UIButton) {
        print(#line, #function, "ボタン押下でAPIフェッチ確認")
        if validateLocalModel() {
            tableVW.reloadData()
            return
        }
        fetchGetResume()
    }
    //共通プレビューをOverrideして利用する
    override func initData() {
        title = "[H-3] 履歴書"
        if Constants.DbgOfflineMode {
            let resume: GetResumeResponseDTO = GetResumeResponseDTO(isEmployed: nil, changeJobCount: nil, workHistory: nil, experienceIndustryId: nil, finalEducation: nil, toeic: nil, toefl: nil, englishSkillId: nil, otherLanguageSkillId: nil, licenseIds: nil)
            self.detail = MdlResume(dto: resume)
        }
    }
    override func dispData() {
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        guard let _detail = detail else { return }
        self.arrData.removeAll()//いったん全件を削除しておく
        editableModel.arrData.removeAll()//こちらで管理させる？！

        //================================================================================
        //=== [H-3]履歴書編集
        //===(3a)就業状況
        arrData.append(MdlItemH(.employmentH3, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlResume.employmentStatus, val: _detail.employmentStatus),
        ]))
        //===(3b)転職回数
        arrData.append(MdlItemH(.changeCountH3, "", childItems: [
        EditableItemH(type: .selectMulti, editItem: EditItemMdlResume.changeCount, val: _detail.changeCount),
        ]))
        //===(3c)直近の経験職種
        let _jobType: String = "\(_detail.lastJobExperiment.jobType)"
        arrData.append(MdlItemH(.lastJobExperimentH3, "", childItems: [
            EditableItemH(type: .selectSpecialYear, editItem: EditItemMdlResumeLastJobExperiment.jobType, val: _jobType),
            //[jobTypeで合わせて設定するので、表示はすれども編集では不要]
            EditableItemH(type: .selectDrum, editItem: EditItemMdlResumeLastJobExperiment.jobExperimentYear, val: _detail.lastJobExperiment.jobExperimentYear),
        ]))
        //===(3d)その他の経験職種
        var _jobExperiments: [EditableItemH] = []
        for jobExperiment in _detail.jobExperiments {
            _jobExperiments.append(EditableItemH(type: .selectSpecialYear, editItem: EditItemMdlResumeJobExperiments.jobType, val: jobExperiment.jobType))
            _jobExperiments.append(EditableItemH(type: .selectDrum, editItem: EditItemMdlResumeJobExperiments.jobExperimentYear, val: jobExperiment.jobExperimentYear))
        }
        arrData.append(MdlItemH(.jobExperimentsH3, "", childItems: _jobExperiments))
        //===(3e)経験業種
        var _businessTypes: [EditableItemH] = []
        for businessType in _detail.businessTypes {
            _businessTypes.append(EditableItemH(type: .selectSpecial, editItem: EditItemMdlResume.businessTypes, val: businessType))
        }
        arrData.append(MdlItemH(.businessTypesH3, "", childItems: _businessTypes))
        //===(3f)最終学歴
        arrData.append(MdlItemH(.schoolH3, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSchool.schoolName, val: _detail.school.schoolName),
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSchool.department, val: _detail.school.department),
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSchool.subject, val: _detail.school.subject),
            EditableItemH(type: .selectDrumYMD, editItem: EditItemMdlResumeSchool.graduationYear, val: _detail.school.graduationYear),
        ]))
        //===(3g)語学
        arrData.append(MdlItemH(.skillLanguageH3, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSkillLanguage.languageToeicScore, val: _detail.skillLanguage.languageToeicScore),
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSkillLanguage.languageToeflScore, val: _detail.skillLanguage.languageToeflScore),
            EditableItemH(type: .selectSingle, editItem: EditItemMdlResumeSkillLanguage.languageEnglish, val: _detail.skillLanguage.languageEnglish),
            EditableItemH(type: .inputMemo, editItem: EditItemMdlResumeSkillLanguage.languageStudySkill, val: _detail.skillLanguage.languageStudySkill),
        ]))
        //===(3h)資格
        var arrCode: [Code] = []
        for qualifications in _detail.qualifications {
            arrCode.append(qualifications)
        }
        let codes: String = arrCode.joined(separator: "_")
        arrData.append(MdlItemH(.qualificationsH3, "", childItems: [
            EditableItemH(type: .selectMulti, editItem: EditItemMdlResume.qualifications, val: codes),
        ]))
        //===(3i)自己PR
        arrData.append(MdlItemH(.ownPr, "", childItems: [
            EditableItemH(type: .inputMemo, editItem: EditItemMdlResume.ownPr, val: _detail.ownPr),
        ]))

        //=== editableModelで管理させる
        editableModel.arrData.removeAll()
        for items in arrData { editableModel.arrData.append(items.childItems) }//editableModelに登録
        editableModel.chkTableCellAll()//これ実施しておくと、getItemByKeyが利用可能になる
        tableVW.reloadData()//描画しなおし
    }
    //========================================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchGetResume()
    }
}

//=== APIフェッチ

extension ResumePreviewVC {
    private func fetchGetResume() {
        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
        let resume: GetResumeResponseDTO = GetResumeResponseDTO(isEmployed: nil, changeJobCount: nil, workHistory: nil, experienceIndustryId: nil, finalEducation: nil, toeic: nil, toefl: nil, englishSkillId: nil, otherLanguageSkillId: nil, licenseIds: nil)
        self.detail = MdlResume(dto: resume)
        self.dispData()
    }
}
//    SVProgressHUD.show(withStatus: "職務経歴書情報の取得")
//    ApiManager.getCareer(Void(), isRetry: true)
//    .done { result in
//        for (num, item) in result.businessTypes.enumerated() {
//            if num == self.targetCardNum { //とりあえず最初(0)のものを対象とする
//                self.detail = result.businessTypes.first
//            }
//        }
//    }
//    .catch { (error) in
//        let myErr: MyErrorDisp = AuthManager.convAnyError(error)
//        self.showError(myErr)
//    }
//    .finally {
//        self.dispData()
//        SVProgressHUD.dismiss()
//    }
//}

