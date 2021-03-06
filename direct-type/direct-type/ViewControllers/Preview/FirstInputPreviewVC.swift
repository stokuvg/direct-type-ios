//
//  FirstInputPreviewVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import TudApi
import SVProgressHUD

//===[A系統]「初回入力」
final class FirstInputPreviewVC: PreviewBaseVC {
    var detail: MdlFirstInput? = nil

    override func actCommit(_ sender: UIButton) {
        if validateLocalModel() {
            refreshPreviewTable()
            return
        }
        fetchCreateProfile()
    }
    //共通プレビューをOverrideして利用する
    override func initData() {
        title = "プロフィール入力"
        let firstInput = MdlFirstInput(nickname: "", gender: "", birthday: Constants.SelectItemsUndefineDate, hopeArea: [], school: "", employmentStatus: "", lastJobExperiment: MdlJobExperiment(jobType: "", jobExperimentYear: ""), salary: "", jobExperiments: [])
        self.detail = firstInput
////        //===___ダミーデータ投入___
//        self.editableModel.editTempCD[EditItemMdlFirstInput.nickname.itemKey] = "あだ名タラ王"
//        self.editableModel.editTempCD[EditItemMdlFirstInput.gender.itemKey] = "2"
//        self.editableModel.editTempCD[EditItemMdlFirstInput.birthday.itemKey] = "1999-12-31"
//        self.editableModel.editTempCD[EditItemMdlFirstInput.hopeArea.itemKey] = "11_13_15"
//        self.editableModel.editTempCD[EditItemMdlFirstInput.school.itemKey] = "3"
//        self.editableModel.editTempCD[EditItemMdlFirstInput.employmentStatus.itemKey] = "2"
//        self.editableModel.editTempCD[EditItemMdlFirstInputLastJobExperiments.jobTypeAndJobExperimentYear.itemKey] = "98:3"
//        self.editableModel.editTempCD[EditItemMdlFirstInput.salary.itemKey] = "1450"
//        self.editableModel.editTempCD[EditItemMdlFirstInputJobExperiments.jobTypeAndJobExperimentYear.itemKey] = "2:2_3:3_4:4_5:5_6:6_7:7_8:8_9:9"
////        //===^^^ダミーデータ投入^^^
        dispData()
    }
    override func dispData() {
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        guard let _detail = detail else { return }
        self.arrData.removeAll()//いったん全件を削除しておく
        editableModel.arrData.removeAll()//こちらで管理させる？！
        arrData.append(MdlItemH(.spacer, "", childItems: [])) //上部の余白を実現させるため（ヘッダと違って、一緒にスクロールアウトさせたい）
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
            EditableItemH(type: .selectMulti, editItem: EditItemMdlFirstInput.hopeArea, val: _detail.hopeArea.joined(separator: EditItemTool.JoinMultiCodeSeparator)),
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
        let bufLastJobExperimentTypeAndYear = EditItemTool.convTypeAndYear(types: [lastJobType], years: [lastJobExperimentYear])
        arrData.append(MdlItemH(.lastJobExperimentA11, "", childItems: [
            EditableItemH(type: .selectSpecialYear, editItem: EditItemMdlFirstInputLastJobExperiments.jobTypeAndJobExperimentYear, val: bufLastJobExperimentTypeAndYear),
        ]))
        //=== [A-13] 入力（現在の年収）
        arrData.append(MdlItemH(.currentSalaryA13, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlFirstInput.salary, val: _detail.salary),
        ]))
        //=== [A-14] 入力（追加経験職種）
        let types = _detail.jobExperiments.map { $0.jobType }
        let years = _detail.jobExperiments.map { $0.jobExperimentYear }
        let bufJobTypeAndYear = EditItemTool.convTypeAndYear(types: types, years: years)
        arrData.append(MdlItemH(.jobExperimentsA14, "", childItems: [
            EditableItemH(type: .selectSpecialYear, editItem: EditItemMdlFirstInputJobExperiments.jobTypeAndJobExperimentYear, val: bufJobTypeAndYear),
        ]))
        //=== editableModelで管理させる
        editableModel.arrData.removeAll()
        for items in arrData { editableModel.arrData.append(items.childItems) }//editableModelに登録
        editableModel.chkTableCellAll()//これ実施しておくと、getItemByKeyが利用可能になる
        refreshPreviewTable()//描画しなおし
    }
    //========================================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    private func completeUpdate() {
        self.editableModel.editTempCD.removeAll()//編集情報をまるっと削除
        self.chkButtonEnable()
    }
}

//=== APIフェッチ
private extension FirstInputPreviewVC {
    //プロフィールと履歴書を叩くため
    func fetchCreateProfile() {
        let param = CreateProfileRequestDTO(editableModel.editTempCD)
        SVProgressHUD.show(withStatus: "プロフィール情報の作成")
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        LogManager.appendApiLog("createProfile", param, function: #function, line: #line)
        ApiManager.createProfile(param, isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("createProfile", result, function: #function, line: #line)
            self.fetchCreateResume()
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("createProfile", error, function: #function, line: #line)
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
            case 400:
                let (dicGrpError, dicError) = ValidateManager.convValidErrMsgProfile(myErr.arrValidErrMsg)
                self.dicGrpValidErrMsg = dicGrpError
                self.dicValidErrMsg = dicError
            default:
                self.showError(error)
            }
        }
        .finally {
            self.dispData()
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        }
    }
    
    func fetchCreateResume() {
        self.dicGrpValidErrMsg.removeAll()//状態をクリアしておく
        self.dicValidErrMsg.removeAll()//状態をクリアしておく
        let param = CreateResumeRequestDTO(editableModel.editTempCD)
        SVProgressHUD.show(withStatus: "履歴書情報の更新")
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        LogManager.appendApiLog("createResume", param, function: #function, line: #line)
        ApiManager.createResume(param, isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("createResume", result, function: #function, line: #line)
            self.fetchCreateSetting()
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("createResume", error, function: #function, line: #line)
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
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        }
    }
    
    func fetchCreateSetting() {
        let param = CreateSettingsRequestDTO(scoutEnable: true)
        SVProgressHUD.show(withStatus: "設定情報の更新")
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        LogManager.appendApiLog("createApproach", param, function: #function, line: #line)
        ApiManager.createApproach(param, isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("createApproach", result, function: #function, line: #line)
            self.transitionToComplete()
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("createApproach", error, function: #function, line: #line)
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }
        .finally {
            self.dispData()
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        }
    }
    
    func transitionToComplete() {
        AnalyticsEventManager.track(type: .registrationComplete)//初期登録が成功したタイミング（ユーザ作成に必要な全てのフェッチが完了した時点）
        let complete = getVC(sbName: "InitialInputCompleteVC", vcName: "InitialInputCompleteVC") as! InitialInputCompleteVC
        complete.configure(type: .registeredAll)
        navigationController?.pushViewController(complete, animated: true)
    }
}

