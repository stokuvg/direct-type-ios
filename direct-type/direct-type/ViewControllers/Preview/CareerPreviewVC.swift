//
//  CareerPreviewVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
//import SwaggerClient
import TudApi
import SVProgressHUD

//===[C-15]「職務経歴書確認」＊単独
class CareerPreviewVC: PreviewBaseVC {
    var targetCardNum: Int = 0 //編集対象のカード番号
    var detail: MdlCareerCard? = nil

    override func actCommit(_ sender: UIButton) {
        print(#line, #function, "ボタン押下でAPIフェッチ確認")
        if validateUpdateCareer() {
            tableVW.reloadData()
            return
        }
        fetchCreateCareerList()
    }
    
    func validateUpdateCareer() -> Bool {
        if Constants.DbgSkipLocalValidate { return false }//[Dbg: ローカルValidationスキップ]
        ValidateManager.dbgDispCurrentItems(editableModel: editableModel) //[Dbg: 状態確認]
        let chkErr = ValidateManager.chkValidationErr(editableModel)
        if chkErr.count > 0 {
            print("＊＊＊　Validationエラー発生: \(chkErr.count)件　＊＊＊")
            var msg: String = ""
            for err in chkErr {
                msg = "\(msg)\(err.value)\n"
            }
            self.showValidationError(title: "Validationエラー (\(chkErr.count)件)", message: msg)
//            /* Warning回避 */ .done { _ in } .catch { (error) in } .finally { } //Warning回避
            return true
        } else {
            print("＊＊＊　Validationエラーなし　＊＊＊")
            return false
        }
    }
    
    //共通プレビューをOverrideして利用する
    override func initData() {
        title = "[C-15]「職務経歴書確認」"
        if Constants.DbgOfflineMode {
            let careerCard: CareerHistoryDTO = CareerHistoryDTO(
                startWorkPeriod: "2006/04/01",
                endWorkPeriod: "2014/03/01",
                companyName: "企業名",
                employmentId: "2",
                employees: 1234,
                salary: 9,
                workNote: "おぼえがきもろもろ：オフライン")
            self.detail = MdlCareerCard(dto: careerCard)
        }
    }
    
    override func dispData() {
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        guard let _detail = detail else { return }
        self.arrData.removeAll()//いったん全件を削除しておく
        editableModel.arrData.removeAll()//こちらで管理させる？！

        //・項目見出し部分に「〇社目（{勤務開始年月}～{勤務終了年月}）」と表示
        //・情報の置き方
        //    ｛企業名｝（｛雇用形態｝）
        //    従業員数：｛従業員数｝名 / 年収：｛年収｝万円
        //    ｛職務内容本文）

        //[C-15]職務経歴書編集
        //case .workPeriod:       return "雇用期間"
        arrData.append(MdlItemH(.workPeriodC15, "", childItems: [
            EditableItemH(type: .selectDrumYMD, editItem: EditItemCareerCardWorkPeriod.startDate, val: _detail.workPeriod.startDate.dispYmd()),
            EditableItemH(type: .selectDrumYMD, editItem: EditItemCareerCardWorkPeriod.endDate, val: _detail.workPeriod.endDate.dispYmd()),
        ]))
        //case .companyName:      return "企業名"
        arrData.append(MdlItemH(.companyNameC15, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemCareerCard.companyName, val: _detail.companyName),
        ]))
        //case .employmentType:   return "雇用形態"
        arrData.append(MdlItemH(.employmentTypeC15, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemCareerCard.employmentType, val: _detail.employmentType),
        ]))
        //case .employeesCount:   return "従業員数"
        arrData.append(MdlItemH(.employeesCountC15, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemCareerCard.employeesCount, val: _detail.employeesCount),
        ]))
        //case .salary:           return "年収"
        arrData.append(MdlItemH(.salaryC15, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemCareerCard.salary, val: _detail.salary),
        ]))
        //case .contents:         return "職務内容本文"
        arrData.append(MdlItemH(.contentsC15, "", childItems: [
            EditableItemH(type: .inputMemo, editItem: EditItemCareerCard.contents, val: _detail.contents),
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
        fetchGetCareerList()
    }
}

//=== APIフェッチ
extension CareerPreviewVC {
    private func fetchGetCareerList() {
        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
        SVProgressHUD.show(withStatus: "職務経歴書情報の取得")
        ApiManager.getCareer(Void(), isRetry: true)
        .done { result in
            for (num, item) in result.businessTypes.enumerated() {
                if num == self.targetCardNum { //とりあえず最初(0)のものを対象とする
                    self.detail = result.businessTypes.first
                }
            }
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }
        .finally {
            self.dispData()
            SVProgressHUD.dismiss()
        }
    }
    private func fetchCreateCareerList() {
        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
        let card = CareerHistoryDTO(self.detail!, editableModel.editTempCD) //変更部分を適用した更新用モデルを生成
        let param = CreateCareerRequestDTO(careerHistory: [card])
        self.dicGrpValidErrMsg.removeAll()//状態をクリアしておく
        self.dicValidErrMsg.removeAll()//状態をクリアしておく
        SVProgressHUD.show(withStatus: "職務経歴書情報の作成")
        ApiManager.createCareer(param, isRetry: true)
        .done { result in
            self.fetchGetCareerList()
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
            case 400:
                let (dicGrpError, dicError) = ValidateManager.canvValidErrMsgCareer(myErr.arrValidErrMsg)
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
    private func fetchUpdateCareerList() {
        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
        let card = CareerHistoryDTO(self.detail!, editableModel.editTempCD) //変更部分を適用した更新用モデルを生成
        let param = CreateCareerRequestDTO(careerHistory: [card])
        self.dicGrpValidErrMsg.removeAll()//状態をクリアしておく
        self.dicValidErrMsg.removeAll()//状態をクリアしておく
        SVProgressHUD.show(withStatus: "職務経歴書情報の作成")
        ApiManager.createCareer(param, isRetry: true)
        .done { result in
            self.fetchGetCareerList()
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
            case 400:
                let (dicGrpError, dicError) = ValidateManager.canvValidErrMsgCareer(myErr.arrValidErrMsg)
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
