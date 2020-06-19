//
//  FirstInputPreviewVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
//import SwaggerClient
import TudApi
import SVProgressHUD

//===[A系統]「初回入力」
class FirstInputPreviewVC: PreviewBaseVC {
    var detail: MdlFirstInput? = nil

    override func actCommit(_ sender: UIButton) {
        print(#line, #function, "ボタン押下でAPIフェッチ確認")
        if validateLocalModel() {
            tableVW.reloadData()
            return
        }
    }
    //共通プレビューをOverrideして利用する
    override func initData() {
        title = "[A系統] 初期入力"
        
        let firstInput = MdlFirstInput(nickname: "", gender: "", birthday: Constants.SelectItemsUndefineBirthday, hopeArea: [], school: "", employmentStatus: "", lastJobExperiment: MdlJobExperiment(jobType: "", jobExperimentYear: ""), salary: "", jobExperiments: [])
        self.detail = firstInput
        dispData()
    }
    override func dispData() {
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        guard let _detail = detail else { return }
        self.arrData.removeAll()//いったん全件を削除しておく
        editableModel.arrData.removeAll()//こちらで管理させる？！

        //================================================================================
        //===(3a)就業状況
        //[A系統]初回入力
        //=== [A-5/6] 入力（ニックネーム）
        arrData.append(MdlItemH(.nicknameA6, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlFirstInput.nickname, val: _detail.nickname),
        ]))
        //=== [A-7] 入力（性別）
        arrData.append(MdlItemH(.genderA7, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlFirstInput.gender, val: _detail.gender),
        ]))
        //=== [A-8] 入力（生年月日）
        arrData.append(MdlItemH(.birthdayA8, "", childItems: [
            EditableItemH(type: .selectDrumYMD, editItem: EditItemMdlFirstInput.birthday, val: _detail.birthday.dispYmd()),
        ]))
        //=== [A-9] 入力（希望勤務地）
        arrData.append(MdlItemH(.hopeAreaA9, "", childItems: [
            EditableItemH(type: .selectMulti, editItem: EditItemMdlFirstInput.hopeArea, val: _detail.hopeArea.joined(separator: "_")),
        ]))
        //=== [A-10] 入力（最終学歴）
        arrData.append(MdlItemH(.schoolA10, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlFirstInput.school, val: _detail.school),
        ]))
        //=== [A-21] 入力（就業状況）
        arrData.append(MdlItemH(.employmentStatusA21, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlFirstInput.employmentStatus, val: _detail.employmentStatus),
        ]))
        //=== [A-11] 入力（直近経験職種）[A-12] 入力（直近の職種の経験年数）
        let lastJobType = _detail.lastJobExperiment.jobType
        let lastJobExperimentYear = _detail.lastJobExperiment.jobExperimentYear
        var bufLastJobExperimentTypeAndYear: String = [lastJobType, lastJobExperimentYear].joined(separator: ":")
        if bufLastJobExperimentTypeAndYear == ":" { bufLastJobExperimentTypeAndYear = "" }//実際は空データのため補正する
        arrData.append(MdlItemH(.lastJobExperimentA11, "", childItems: [
            EditableItemH(type: .selectSpecialYear, editItem: EditItemMdlFirstInputLastJobExperiments.jobTypeAndJobExperimentYear, val: bufLastJobExperimentTypeAndYear),
        ]))
        //=== [A-13] 入力（現在の年収）
        arrData.append(MdlItemH(.salaryA13, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlFirstInput.salary, val: _detail.salary),
        ]))
        //=== [A-14] 入力（追加経験職種）
        var arrJobExperiments: [String] = []
        for item in _detail.jobExperiments {
            let jobType = item.jobType
            let jobExperimentYear = item.jobExperimentYear
            let buf: String = [jobType, jobExperimentYear].joined(separator: ":")
            arrJobExperiments.append(buf)
        }
        let bufJobTypeAndYear: String = arrJobExperiments.joined(separator: "_")
        arrData.append(MdlItemH(.jobExperimentsA14, "", childItems: [
            EditableItemH(type: .selectSpecialYear, editItem: EditItemMdlFirstInputJobExperiments.jobTypeAndJobExperimentYear, val: bufJobTypeAndYear),
        ]))
        
        print(arrData.description)
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
//        fetchGetResume()
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

