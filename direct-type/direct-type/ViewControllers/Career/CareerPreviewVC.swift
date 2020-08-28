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

protocol CareerListProtocol {
    func changedCard(num: Int, item: MdlCareerCard) //変更して戻る
    func cancelCard(num: Int, item: MdlCareerCard) //変更なしで戻る
}

//===[C-15]「職務経歴書確認」＊単独
class CareerPreviewVC: PreviewBaseVC {
    var delegate: CareerListProtocol? = nil
    var targetCardNum: Int = 0 //編集対象のカード番号
    var arrDetail: [MdlCareerCard] = []

    override func actCommit(_ sender: UIButton) {
        //===== フェッチかける
        if validateLocalModel() {
            tableVW.reloadData()
            return
        }
        //===複数項目にわたるものなど、拡張バリデーションの実施
        var isExistDummyText: Bool = false
        if let workMemo = editableModel.getItemByKey(EditItemMdlCareerCard.contents.itemKey) {
            let text = workMemo.curVal
            let regexp = "\(Constants.TypeDummyStrings)"
            let regex = try! NSRegularExpression(pattern: regexp, options: [.dotMatchesLineSeparators])
            let matches = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
            isExistDummyText = (matches.count > 0) ? true : false
        }
        if isExistDummyText {
            self.dicValidErrMsg.addDicArrVal(key: EditItemMdlCareerCard.contents.itemKey, val: "ダミーテキストが残っています")
            self.dicGrpValidErrMsg = ValidateManager.makeGrpErrByItemErr(self.dicValidErrMsg)
            tableVW.reloadData()            
            let title: String = "確認"
            let message: String = "ダミーの文字を削除して保存しますが、よろしいですか？"
            let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction.init(title: "ダミーを削除して保存", style: UIAlertAction.Style.default) { _ in
                if let workMemo = self.editableModel.getItemByKey(EditItemMdlCareerCard.contents.itemKey) {
                    let text = workMemo.curVal
                    let regexp = "\(Constants.TypeDummyStrings)"
                    let newText = text.replacementString(text: text, regexp: regexp, fixedReplacementString: "")
                    self.editableModel.changeTempItem(workMemo, text: newText)
                    self.fetchCreateCareerList()
                }
            }
            let cancelAction = UIAlertAction.init(title: "修正する", style: UIAlertAction.Style.cancel) { _ in
                if let item = self.editableModel.getItemByKey(EditItemMdlCareerCard.contents.itemKey) {
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        let storyboard = UIStoryboard(name: "Edit", bundle: nil)
                        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubInputMemoVC") as? SubInputMemoVC{
                            nvc.initData(self, editableItem: item)
                            //遷移アニメーション関連
                            nvc.modalTransitionStyle = .coverVertical//.crossDissolve
                            self.present(nvc, animated: true) {}
                        }
                    })
                }
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        fetchCreateCareerList()
    }
    
    //共通プレビューをOverrideして利用する
    override func initData() {
        //title = "職務経歴書入力" //「n社目」表示するようになったため、このタイミングのtitle表示は不要
    }
    override func dispData() {
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        guard arrDetail.count > targetCardNum else { return }
        let _detail = arrDetail[targetCardNum]
        self.arrData.removeAll()//いったん全件を削除しておく
        editableModel.arrData.removeAll()//こちらで管理させる？！
        arrData.append(MdlItemH(.spacer, "", childItems: [])) //上部の余白を実現させるため（ヘッダと違って、一緒にスクロールアウトさせたい）
        //================================================================================
        //・項目見出し部分に「〇社目（{勤務開始年月}～{勤務終了年月}）」と表示
        //・情報の置き方
        //    ｛企業名｝（｛雇用形態｝）
        //    従業員数：｛従業員数｝名 / 年収：｛年収｝万円
        //    ｛職務内容本文）

        //[C-15]職務経歴書編集
        //case .workPeriod:       return "在籍期間"
        arrData.append(MdlItemH(.workPeriodC15, "", childItems: [
            EditableItemH(type: .selectDrumYM, editItem: EditItemMdlCareerCardWorkPeriod.startDate, val: _detail.workPeriod.startDate.dispYmd()),
            EditableItemH(type: .selectDrumYM, editItem: EditItemMdlCareerCardWorkPeriod.endDate, val: _detail.workPeriod.endDate.dispYmd()),
        ]))
        //case .companyName:      return "社名"
        arrData.append(MdlItemH(.companyNameC15, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlCareerCard.companyName, val: _detail.companyName),
        ]))
        //case .employmentType:   return "雇用形態"
        arrData.append(MdlItemH(.employmentTypeC15, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlCareerCard.employmentType, val: _detail.employmentType),
        ]))
        //case .employeesCount:   return "従業員数"
        arrData.append(MdlItemH(.employeesCountC15, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlCareerCard.employeesCount, val: _detail.employeesCount),
        ]))
        //case .salary:           return "年収"
        arrData.append(MdlItemH(.salaryC15, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlCareerCard.salary, val: _detail.salary),
        ]))
        //case .contents:         return "職務内容本文"
        arrData.append(MdlItemH(.contentsC15, "", childItems: [
            EditableItemH(type: .inputMemo, editItem: EditItemMdlCareerCard.contents, val: _detail.contents),
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
    }
    //========================================
    func initData(_ delegate: CareerListProtocol, _ num: Int, _ details: [MdlCareerCard]) {
        self.delegate = delegate
        self.targetCardNum = num
        self.arrDetail = details
        title = "職務経歴書入力 \(num + 1)社目"
    }
    //========================================
    override func chkButtonEnable() {
        var isEnable: Bool = true
        if (editableModel.getItemByKey(EditItemMdlCareerCardWorkPeriod.startDate.itemKey)?.curVal ?? "").isEmpty { isEnable = false }
        if (editableModel.getItemByKey(EditItemMdlCareerCardWorkPeriod.endDate.itemKey)?.curVal ?? "").isEmpty { isEnable = false }
        if (editableModel.getItemByKey(EditItemMdlCareerCard.companyName.itemKey)?.curVal ?? "").isEmpty { isEnable = false }
        if (editableModel.getItemByKey(EditItemMdlCareerCard.contents.itemKey)?.curVal ?? "").isEmpty { isEnable = false }
        dispButton(isEnable: isEnable)
    }
    private func dispButton(isEnable: Bool) {
        if isEnable {
            btnCommit.isEnabled = true
            btnCommit.setTitle(text: "完了する", fontType: .font_M, textColor: UIColor(colorType: .color_white)!, alignment: .center)
            btnCommit.backgroundColor = UIColor(colorType: .color_button)
        } else {
            btnCommit.isEnabled = false
            btnCommit.setTitle(text: "完了する", fontType: .font_M, textColor: UIColor(colorType: .color_white)!, alignment: .center)
            btnCommit.backgroundColor = UIColor(colorType: .color_close)
        }
    }

}

//=== APIフェッチ
extension CareerPreviewVC {
    private func fetchCreateCareerList() {
        guard arrDetail.count > targetCardNum else { return }
        let _detail = arrDetail[targetCardNum]
        let card = CareerHistoryDTO(_detail, editableModel.editTempCD) //変更部分を適用した更新用モデルを生成
        var tempCards: [CareerHistoryDTO] = []
        for (num, item) in arrDetail.enumerated() {
            if num == targetCardNum {
                //print("💙編集対象 #\(num) [\(item.debugDisp)]")
                tempCards.append(card)
            } else {
                //print("💙そのまま #\(num) [\(item.debugDisp)]")
                tempCards.append(CareerHistoryDTO(item))
            }
        }
        let _tempCards = tempCards.sorted { (lv, rv) -> Bool in
            lv.startWorkPeriod > rv.endWorkPeriod
        }
        let param = CreateCareerRequestDTO(careerHistory: _tempCards)
        self.dicGrpValidErrMsg.removeAll()//状態をクリアしておく
        self.dicValidErrMsg.removeAll()//状態をクリアしておく
        SVProgressHUD.show(withStatus: "職務経歴書情報の作成")
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        LogManager.appendApiLog("createCareer", param, function: #function, line: #line)
        ApiManager.createCareer(param, isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("createCareer", result, function: #function, line: #line)
            //self.fetchGetCareerList()
            self.fetchCompletePopVC()
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("createCareer", error, function: #function, line: #line)
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
            case 400:
                let (dicGrpError, dicError) = ValidateManager.convValidErrMsgCareer(myErr.arrValidErrMsg)
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
}
