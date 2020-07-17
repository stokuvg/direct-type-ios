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
    var isEntryMode: Bool = false //応募フォームから呼び出された場合には、「自己PR」欄を非表示にするため

    override func actCommit(_ sender: UIButton) {
        if editableModel.editTempCD.count == 0 { //変更なければ、そのまま戻して良いプレビュー画面
            navigationController?.popViewController(animated: true)
            return
        }
        if validateLocalModel() {
            tableVW.reloadData()
            return
        }
        fetchUpdateResume()
    }
    //共通プレビューをOverrideではなくなった
    func initData(isEntryMode: Bool) {
        title = "履歴書"
        self.isEntryMode = isEntryMode
    }
    override func dispData() {
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        guard let _detail = detail else { return }
        self.arrData.removeAll()//いったん全件を削除しておく
        editableModel.arrData.removeAll()//こちらで管理させる？！
        arrData.append(MdlItemH(.spacer, "", childItems: [])) //上部の余白を実現させるため（ヘッダと違って、一緒にスクロールアウトさせたい）
        //================================================================================
        //=== [H-3]履歴書編集
        //===(3a)就業状況
        arrData.append(MdlItemH(.employmentH3, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlResume.employmentStatus, val: _detail.employmentStatus),
        ]))
        //===(XX)現在の年収
        arrData.append(MdlItemH(.currentSalaryH3, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlResume.currentSalary, val: _detail.currentSalary),
        ]))
        //===(3b)転職回数
        arrData.append(MdlItemH(.changeCountH3, "", childItems: [
        EditableItemH(type: .selectSingle, editItem: EditItemMdlResume.changeCount, val: _detail.changeCount),
        ]))
        //===(3c)直近の経験職種
        let lastJobType = _detail.lastJobExperiment.jobType
        let lastJobExperimentYear = _detail.lastJobExperiment.jobExperimentYear
        let bufLastJobExperimentTypeAndYear = EditItemTool.convTypeAndYear(types: [lastJobType], years: [lastJobExperimentYear])
        arrData.append(MdlItemH(.lastJobExperimentH3, "", childItems: [
            EditableItemH(type: .selectSpecialYear, editItem: EditItemMdlResumeLastJobExperiment.jobTypeAndJobExperimentYear, val: bufLastJobExperimentTypeAndYear),
        ]))
        //===(3d)その他の経験職種
        let types = _detail.jobExperiments.map { $0.jobType }
        let years = _detail.jobExperiments.map { $0.jobExperimentYear }
        let bufJobTypeAndYear = EditItemTool.convTypeAndYear(types: types, years: years)
        arrData.append(MdlItemH(.jobExperimentsH3, "", childItems: [
            EditableItemH(type: .selectSpecialYear, editItem: EditItemMdlResumeJobExperiments.jobTypeAndJobExperimentYear, val: bufJobTypeAndYear),
        ]))
        //===(3e)経験業種
        let businessType: String = _detail.businessTypes.joined(separator: EditItemTool.JoinMultiCodeSeparator)
        arrData.append(MdlItemH(.businessTypesH3, "", childItems: [
            EditableItemH(type: .selectSpecial, editItem: EditItemMdlResume.businessTypes, val: businessType),
        ]))
        //===(3f)最終学歴
        arrData.append(MdlItemH(.schoolH3, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSchool.schoolName, val: _detail.school.schoolName),
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSchool.faculty, val: _detail.school.faculty),
            EditableItemH(type: .inputText, editItem: EditItemMdlResumeSchool.department, val: _detail.school.department),
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
        let codes: String = arrCode.joined(separator: EditItemTool.JoinMultiCodeSeparator)
        arrData.append(MdlItemH(.qualificationsH3, "", childItems: [
            EditableItemH(type: .selectMulti, editItem: EditItemMdlResume.qualifications, val: codes),
        ]))
        //===(3i)自己PR
        if !isEntryMode { //応募フォームの場合には項目非表示とする
            arrData.append(MdlItemH(.ownPrH3, "", childItems: [
                EditableItemH(type: .inputMemo, editItem: EditItemMdlResume.ownPr, val: _detail.ownPr),
            ]))
        }

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
    private func completeUpdate() {
        self.editableModel.editTempCD.removeAll()//編集情報をまるっと削除
        self.chkButtonEnable()
    }
}

//=== APIフェッチ
extension ResumePreviewVC {
    private func fetchGetResume() {
        SVProgressHUD.show(withStatus: "履歴書の取得")
        ApiManager.getResume(Void(), isRetry: true)
        .done { result in
            self.detail = result
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
            case 404://見つからない場合、空データを適用して画面を表示
                let message: String = "[A系統]初期入力画面でProfileやResumeの一部データが登録されているはず\n"
                self.showError(MyErrorDisp(code: 9999, title: "特殊処理", message: message, orgErr: nil, arrValidErrMsg: []))
                self.pushViewController(.firstInputPreviewA)
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
    private func fetchUpdateResume() {
        guard let resume = self.detail else { return }
        let param = UpdateResumeRequestDTO(resume ,editableModel.editTempCD)
//        let param = UpdateResumeRequestDTO(isEmployed: false, changeJobCount: 0, workHistory: [], experienceIndustryIds: [], educationId: "", finalEducation: FinalEducationDTO(schoolName: "", faculty: "", department: "", guraduationYearMonth: ""), toeic: 99999, toefl: 999999, englishSkillId: "", otherLanguageSkillId: "", licenseIds: [], selfPR: "", currentSalary: "")
        self.dicGrpValidErrMsg.removeAll()//状態をクリアしておく
        self.dicValidErrMsg.removeAll()//状態をクリアしておく
        SVProgressHUD.show(withStatus: "履歴書情報の更新")
        ApiManager.updateResume(param, isRetry: true)
        .done { result in
            self.fetchCompletePopVC()
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
            case 400:
                let (dicGrpError, dicError) = ValidateManager.convValidErrMsgResume(myErr.arrValidErrMsg)
                self.dicGrpValidErrMsg = dicGrpError
                self.dicValidErrMsg = dicError
            default:
                self.showError(error)
            }
        }
        .finally {
            self.dispData()
            SVProgressHUD.dismiss()
        }
    }
}
