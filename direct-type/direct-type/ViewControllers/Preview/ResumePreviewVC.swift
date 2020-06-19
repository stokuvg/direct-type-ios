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
        if validateLocalModel() {
            tableVW.reloadData()
            return
        }
        fetchCreateResume()
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
        EditableItemH(type: .selectSingle, editItem: EditItemMdlResume.changeCount, val: _detail.changeCount),
        ]))
        //===(3c)直近の経験職種
        let lastJobType = _detail.lastJobExperiment.jobType
        let lastJobExperimentYear = _detail.lastJobExperiment.jobExperimentYear
        var bufLastJobExperimentTypeAndYear: String = [lastJobType, lastJobExperimentYear].joined(separator: ":")
        if bufLastJobExperimentTypeAndYear == ":" { bufLastJobExperimentTypeAndYear = "" }//実際は空データのため補正する
        arrData.append(MdlItemH(.lastJobExperimentH3, "", childItems: [
            EditableItemH(type: .selectSpecialYear, editItem: EditItemMdlResumeLastJobExperiment.jobTypeAndJobExperimentYear, val: bufLastJobExperimentTypeAndYear),
        ]))
        //===(3d)その他の経験職種
        var arrJobExperiments: [String] = []
        for item in _detail.jobExperiments {
            let jobType = item.jobType
            let jobExperimentYear = item.jobExperimentYear
            let buf: String = [jobType, jobExperimentYear].joined(separator: ":")
            arrJobExperiments.append(buf)
        }
        let bufJobTypeAndYear: String = arrJobExperiments.joined(separator: "_")
        print("✳️✳️✳️[bufJobTypeAndYear: \(bufJobTypeAndYear)]✳️✳️✳️")
        
        
        arrData.append(MdlItemH(.jobExperimentsH3, "", childItems: [
            EditableItemH(type: .selectSpecialYear, editItem: EditItemMdlResumeJobExperiments.jobTypeAndJobExperimentYear, val: bufJobTypeAndYear),
        ]))
        //===(3e)経験業種
        let businessType: String = _detail.businessTypes.joined(separator: "_")
        arrData.append(MdlItemH(.businessTypesH3, "", childItems: [
            EditableItemH(type: .selectSpecial, editItem: EditItemMdlResume.businessTypes, val: businessType),
        ]))
        //===(3f)最終学歴
        arrData.append(MdlItemH(.schoolH3, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSchool.schoolName, val: _detail.school.schoolName),
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSchool.department, val: _detail.school.department),
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSchool.subject, val: _detail.school.subject),
            EditableItemH(type: .selectDrumYM, editItem: EditItemMdlResumeSchool.graduationYear, val: _detail.school.graduationYear),
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
        arrData.append(MdlItemH(.ownPrH3, "", childItems: [
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
        if Constants.DbgOfflineMode {
            var workHistory: [WorkHistoryDTO] = []
            workHistory.append(WorkHistoryDTO(job3Id: "130", experienceYears: "7"))
            workHistory.append(WorkHistoryDTO(job3Id: "5", experienceYears: "3"))
            workHistory.append(WorkHistoryDTO(job3Id: "3", experienceYears: "2"))
            let resume: GetResumeResponseDTO = GetResumeResponseDTO(isEmployed: nil, changeJobCount: nil, workHistory: workHistory, experienceIndustryId: nil, finalEducation: nil, toeic: nil, toefl: nil, englishSkillId: nil, otherLanguageSkillId: nil, licenseIds: nil)
            self.detail = MdlResume(dto: resume)
            self.dispData()
        return }//[Dbg: フェッチ割愛]
        //========================================================
        SVProgressHUD.show(withStatus: "履歴書の取得")
        ApiManager.getResume(Void(), isRetry: true)
        .done { result in
            print(result.debugDisp)
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
            case 404://見つからない場合、空データを適用して画面を表示
                self.detail = MdlResume()
                return //エラー表示させないため
            default: break
}
            self.showError(myErr)
        }
        .finally {
            self.dispData()
            SVProgressHUD.dismiss()
        }
    }
//    private func fetchUpdateResume() {
//        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
//        let param = UpdateResumeRequestDTO(editableModel.editTempCD)
//        self.dicGrpValidErrMsg.removeAll()//状態をクリアしておく
//        self.dicValidErrMsg.removeAll()//状態をクリアしておく
//        SVProgressHUD.show(withStatus: "履歴書情報の更新")
//        ApiManager.updateResume(param, isRetry: true)
//        .done { result in
//            self.fetchGetResume()//成功したら取得フェチ
//        }
//        .catch { (error) in
//            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
//            switch myErr.code {
//            case 400:
//                let (dicGrpError, dicError) = ValidateManager.convValidErrMsgProfile(myErr.arrValidErrMsg)
//                self.dicGrpValidErrMsg = dicGrpError
//                self.dicValidErrMsg = dicError
//            default:
//                self.showError(error)
//            }
//        }
//        .finally {
//            self.dispData()
//            SVProgressHUD.dismiss()
//        }
//    }
    private func fetchCreateResume() {
        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
        let model: MdlResume = MdlResume()
        let param = CreateResumeRequestDTO(model, editableModel.editTempCD)
        
        self.dicGrpValidErrMsg.removeAll()//状態をクリアしておく
        self.dicValidErrMsg.removeAll()//状態をクリアしておく
        
        print(param)
        
//        SVProgressHUD.show(withStatus: "履歴書情報の更新")
//        ApiManager.createResume(param, isRetry: true)
//        .done { result in
//            self.fetchGetResume()//成功したら取得フェチ
//        }
//        .catch { (error) in
//            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
//            switch myErr.code {
//            case 400:
//                let (dicGrpError, dicError) = ValidateManager.convValidErrMsgProfile(myErr.arrValidErrMsg)
//                self.dicGrpValidErrMsg = dicGrpError
//                self.dicValidErrMsg = dicError
//            default:
//                self.showError(error)
//            }
//        }
//        .finally {
//            self.dispData()
//            SVProgressHUD.dismiss()
//        }
    }
}

