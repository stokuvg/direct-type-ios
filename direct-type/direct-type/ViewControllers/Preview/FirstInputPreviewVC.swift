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
        
        let firstInput = MdlFirstInput(nickname: "", gender: "", birthday: Date(), hopeArea: [], school: "", employmentStatus: "", lastJobExperiment: MdlResumeLastJobExperiment(jobType: "", jobExperimentYear: ""), salary: "", jobExperiments: [])
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
        arrData.append(MdlItemH(.employmentH3, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlResume.employmentStatus, val: _detail.employmentStatus),
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

