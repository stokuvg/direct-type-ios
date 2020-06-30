//
//  EntryConfirmVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import TudApi
import SVProgressHUD
import SwaggerClient

class EntryConfirmVC: PreviewBaseVC {
    var jobCard: MdlJobCardDetail? = nil
    var profile: MdlProfile? = nil
    var resume: MdlResume? = nil
    var career: MdlCareer? = nil
    var entry: MdlEntry? = nil

    override func actCommit(_ sender: UIButton) {
        if validateLocalModel() {
            tableVW.reloadData()
            return
        }
        fetchPostEntry()
    }
    //共通プレビューをOverrideして利用する
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCommit.setTitle(text: "応募する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
    }
    func initData(_ jobCard: MdlJobCardDetail, _ profile: MdlProfile? = nil, _ resume: MdlResume? = nil, _ career: MdlCareer? = nil, _ entry: MdlEntry? = nil) {
        title = "[C-12] 応募確認"
        self.jobCard = jobCard
        self.profile = profile
        self.resume = resume
        self.career = career
        self.entry = entry
    }
    override func dispData() {
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        self.arrData.removeAll()//いったん全件を削除しておく
        editableModel.arrData.removeAll()//こちらで管理させる？！

        //===== [C-12]応募確認での追加分
        arrData.append(MdlItemH(.notifyEntry1C12, "", childItems: []))
        arrData.append(MdlItemH(.notifyEntry2C12, "", childItems: []))
        
        //====== [C-9]応募フォーム
        //===４．応募先求人
        arrData.append(MdlItemH(.jobCardC9, "", childItems: [
            EditableItemH(type: .model, editItem: EditItemMdlEntry.jobCard, val: "【モデルダミー】"),
        ], model: jobCard))
        //===５．プロフィール（一部必須）
        arrData.append(MdlItemH(.profileC9, "", childItems: [
            EditableItemH(type: .model, editItem: EditItemMdlEntry.profile, val: "【モデルダミー】"),
        ], model: profile))
        //===６．履歴書（一部必須）
        arrData.append(MdlItemH(.resumeC9, "", childItems: [
            EditableItemH(type: .model, editItem: EditItemMdlEntry.resume, val: "【モデルダミー】"),
        ], model: resume))
        //===７．職務経歴書（一部必須）
        arrData.append(MdlItemH(.careerC9, "", childItems: [
            EditableItemH(type: .model, editItem: EditItemMdlEntry.career, val: "【モデルダミー】"),
        ], model: career))
        
        //===XX. 固定文言
        arrData.append(MdlItemH(.fixedInfoC9, "", childItems: [] ))
        
        //===１２．独自質問（必須）
        var exQA: [MdlItemH] = []
        if let exQuestion = entry?.exQuestion1 {
            exQA.append(MdlItemH(.exQAItem1C9, exQuestion, childItems: [
                EditableItemH(type: .inputMemo, editItem: EditItemMdlEntry.exQuestionAnswer1, val: entry?.exAnswer1 ?? ""),
            ], model: career))
        }
        if let exQuestion = entry?.exQuestion2 {
            exQA.append(MdlItemH(.exQAItem2C9, exQuestion, childItems: [
                EditableItemH(type: .inputMemo, editItem: EditItemMdlEntry.exQuestionAnswer2, val: entry?.exAnswer2 ?? ""),
            ], model: career))
        }
        if let exQuestion = entry?.exQuestion3 {
            exQA.append(MdlItemH(.exQAItem3C9, exQuestion, childItems: [
                EditableItemH(type: .inputMemo, editItem: EditItemMdlEntry.exQuestionAnswer3, val: entry?.exAnswer3 ?? ""),
            ], model: career))
        }
        if exQA.count > 0 {
            arrData.append(MdlItemH(.exQuestionC9, "", childItems: []))
            for qa in exQA { arrData.append(qa) }
        }
        //===９．自己PR文字カウント
        arrData.append(MdlItemH(.ownPRC9, "", childItems: [
            EditableItemH(type: .inputMemo, editItem: EditItemMdlEntry.ownPR, val: entry?.ownPR ?? ""),
        ]))
        //===１０．希望勤務地（任意）
        let _hopeArea = entry?.hopeArea.joined(separator: EditItemTool.JoinMultiCodeSeparator)
        arrData.append(MdlItemH(.hopeAreaC9, "", childItems: [
            EditableItemH(type: .selectMulti, editItem: EditItemMdlEntry.hopeArea, val: _hopeArea ?? ""),
        ]))
        //===１１．希望年収（任意）
        arrData.append(MdlItemH(.hopeSalaryC9, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlEntry.hopeSalary, val: entry?.hopeSalary ?? ""),
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
    override func chkButtonEnable() {
        btnCommit.isEnabled = true
    }
}

extension EntryConfirmVC {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = arrData[indexPath.row]
        switch item.type {
        case .notifyEntry1C12:
            let cell: EntryConfirmNotifyEntry1TBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryConfirmNotifyEntry1TBCell", for: indexPath) as! EntryConfirmNotifyEntry1TBCell
            cell.initCell(email: profile?.mailAddress ?? "")
            cell.dispCell()
            return cell

        case .notifyEntry2C12:
            let cell: EntryConfirmNotifyEntry2TBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryConfirmNotifyEntry2TBCell", for: indexPath) as! EntryConfirmNotifyEntry2TBCell
            cell.initCell()
            cell.dispCell()
            return cell


        case .jobCardC9:
            let cell: EntryFormJobCardTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryFormJobCardTBCell", for: indexPath) as! EntryFormJobCardTBCell
            cell.initCell(self.jobCard)
            cell.dispCell()
            return cell

        case .profileC9:
            let cell: EntryFormAnyModelTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryFormAnyModelTBCell", for: indexPath) as! EntryFormAnyModelTBCell
            cell.initCell(.profile, model: self.profile)
            cell.dispCell()
            return cell

        case .resumeC9:
            let cell: EntryFormAnyModelTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryFormAnyModelTBCell", for: indexPath) as! EntryFormAnyModelTBCell
            cell.initCell(.resume, model: self.resume)
            cell.dispCell()
            return cell

        case .careerC9:
            let cell: EntryFormAnyModelTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryFormAnyModelTBCell", for: indexPath) as! EntryFormAnyModelTBCell
            cell.initCell(.career, model: self.career)
            cell.dispCell()
            return cell

        case .fixedInfoC9:
            let cell: EntryFormInfoTextTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryFormInfoTextTBCell", for: indexPath) as! EntryFormInfoTextTBCell
            cell.initCell(title: item.type.dispTitle)
            cell.dispCell()
            return cell

        case .exQuestionC9:
            let cell: EntryFormExQuestionsHeadTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryFormExQuestionsHeadTBCell", for: indexPath) as! EntryFormExQuestionsHeadTBCell
            cell.initCell(title: item.type.dispTitle)
            cell.dispCell()
            return cell

        case .exQAItem1C9, .exQAItem2C9, .exQAItem3C9:
            let cell: EntryFormExQuestionsItemTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryFormExQuestionsItemTBCell", for: indexPath) as! EntryFormExQuestionsItemTBCell
            let errMsg = dicGrpValidErrMsg[item.type.itemKey]?.joined(separator: "\n") ?? ""
            cell.initCell(item, editTempCD: editableModel.editTempCD, errMsg: errMsg)//編集中の値を表示適用させるためeditTempCDを渡す
            cell.dispCell()
            return cell

        default:
            let cell: HPreviewTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HPreviewTBCell", for: indexPath) as! HPreviewTBCell
            let errMsg = dicGrpValidErrMsg[item.type.itemKey]?.joined(separator: "\n") ?? ""
            cell.initCell(item, editTempCD: editableModel.editTempCD, errMsg: errMsg)//編集中の値を表示適用させるためeditTempCDを渡す
            cell.dispCell()
            return cell
        }
    }
}
//=== APIフェッチ
extension EntryConfirmVC {
    private func fetchPostEntry() {
        guard let _jobCard = self.jobCard else { return }
        guard let _profile = self.profile else { return }
        guard let _resume = self.resume else { return }
        guard let _career = self.career else { return }
        
        
        let param: WebAPIEntryUserDto = WebAPIEntryUserDto(_jobCard.jobCardCode, _profile, _resume, _career, editableModel.editTempCD)
        print(param)
        showConfirm(title: "", message: "\(param)", onlyOK: true)

        SVProgressHUD.show(withStatus: "応募処理")
        ApiManager.postEntry(param, isRetry: true)
        .done { result in
            print(result)
        }
        .catch { (error) in
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
            SVProgressHUD.dismiss()
        }
    }

}
