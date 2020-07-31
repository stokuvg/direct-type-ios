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
    
    var isAccept: Bool = false
    var bufPassword: String = ""
    var flgValidErrExist: Bool = false
        
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
        //=== 入力Typeパスワードのバリデーション
        let buf = bufPassword
        if !ValidateManager.chkValidateTypePassword(typePassword: buf) {
            let errMsg: String = "ログインできません。入力内容をご確認ください"
            showConfirm(title: "", message: errMsg, onlyOK: true)
            return
        }
        fetchPostEntry()
    }
    //共通プレビューをOverrideして利用する
    override func viewDidLoad() {
        super.viewDidLoad()
        dispButton(isEnable: false)
    }
    private func dispButton(isEnable: Bool) {
        if isEnable {
            btnCommit.isEnabled = true
            btnCommit.setTitle(text: "応募する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
            btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
        } else {
            btnCommit.isEnabled = false
            btnCommit.setTitle(text: "応募する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
            btnCommit.backgroundColor = UIColor.init(colorType: .color_close)
        }
    }

    func initData(_ jobCard: MdlJobCardDetail, _ profile: MdlProfile? = nil, _ resume: MdlResume? = nil, _ career: MdlCareer? = nil, _ entry: MdlEntry? = nil) {
        title = "応募確認"
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
        //===== [C-12]応募フォーム独自追加項目
        arrData.append(MdlItemH(.entryC12, "", childItems: [
            EditableItemH(type: .model, editItem: EditItemMdlEntry.entryItems, val: "【モデルダミー】"),
        ], model: entry))

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
    //=== Notification通知の登録 ===
    // 画面遷移時にも取り除かないもの（他の画面で変更があった場合の更新のため）
    override func initNotify() {
    }
    // この画面に遷移したときに登録するもの
    override func addNotify() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    // 他の画面に遷移するときに消して良いもの
    override func removeNotify() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc func keyboardDidShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let rect = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            let safeAreaB = self.view.safeAreaInsets.bottom
            let szKeyBoard = rect.size
            let szFoot = vwFootArea.frame.size
            tableVW.contentInset.bottom = szKeyBoard.height - szFoot.height + safeAreaB
        }
    }
    @objc func keyboardDidHide(notification: NSNotification) {
      tableVW.contentInset.bottom = 0
    }
    //=======================================================================================================
    override func chkButtonEnable() {
        var isEnable: Bool = true
        if isAccept == false { isEnable = false } //許可していなければ非活性
        if self.bufPassword.count < 4 { isEnable = false } //4文字以下なら非活性
        if self.bufPassword.count > 20 { isEnable = false } //20文字以上なら非活性
        //=== 入力Typeパスワードのリアルタイムバリデーション
        if !ValidateManager.chkValidateTypePassword(typePassword: bufPassword) {
            isEnable = false
            flgValidErrExist = true
        } else {
            flgValidErrExist = false
        }
        //
        let idxPath = IndexPath(row: 0, section: 0)
        if let passwordCell = tableVW.cellForRow(at: idxPath) as? EntryConfirmNotifyEntry1TBCell {
            passwordCell.changeErrorStatus(isValidErrorExist: flgValidErrExist)
            passwordCell.dispCell()
        }
        dispButton(isEnable: isEnable)
    }
}

extension EntryConfirmVC {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = arrData[indexPath.row]
        switch item.type {
        case .notifyEntry1C12:
            let cell: EntryConfirmNotifyEntry1TBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryConfirmNotifyEntry1TBCell", for: indexPath) as! EntryConfirmNotifyEntry1TBCell
            cell.initCell(self, email: profile?.mailAddress ?? "", isValidError: flgValidErrExist)
            cell.dispCell()
            return cell

        case .notifyEntry2C12:
            let cell: EntryConfirmNotifyEntry2TBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryConfirmNotifyEntry2TBCell", for: indexPath) as! EntryConfirmNotifyEntry2TBCell
            cell.initCell(self)
            cell.dispCell()
            return cell

        case .jobCardC9:
            let cell: EntryFormJobCardTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryFormJobCardTBCell", for: indexPath) as! EntryFormJobCardTBCell
            cell.initCell(self.jobCard, isFullDisp: true)
            cell.dispCell()
            return cell

        case .profileC9:
            let cell: EntryConfirmAnyModelTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryConfirmAnyModelTBCell", for: indexPath) as! EntryConfirmAnyModelTBCell
            cell.initCell(.profile, model: self.profile)
            cell.dispCell()
            return cell

        case .resumeC9:
            let cell: EntryConfirmAnyModelTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryConfirmAnyModelTBCell", for: indexPath) as! EntryConfirmAnyModelTBCell
            cell.initCell(.resume, model: self.resume)
            cell.dispCell()
            return cell

        case .careerC9:
            let cell: EntryConfirmAnyModelTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryConfirmAnyModelTBCell", for: indexPath) as! EntryConfirmAnyModelTBCell
            cell.initCell(.career, model: self.career)
            cell.dispCell()
            return cell

        case .entryC12:
            let cell: EntryConfirmAnyModelTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryConfirmAnyModelTBCell", for: indexPath) as! EntryConfirmAnyModelTBCell
            cell.initCell(.entry, model: self.entry)
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
extension EntryConfirmVC: EntryConfirmNotifyEntryDelegate {
    func changePasswordText(text: String) {
        bufPassword = text
        chkButtonEnable()
    }
    func changeAcceptStatus(isAccept: Bool) {
        self.isAccept = isAccept
        chkButtonEnable()
    }
}

//=== APIフェッチ
extension EntryConfirmVC {
    private func fetchPostEntry() {
        guard let _jobCard = self.jobCard else { return }
        guard let _profile = self.profile else { return }
        guard let _resume = self.resume else { return }
        guard let _career = self.career else { return }
        guard let _entry = self.entry else { return }
        let _jobCardCode: String = _jobCard.jobCardCode
        let _typePassword: String = self.bufPassword //半角英数4-20
        let param: WebAPIEntryUserDto = WebAPIEntryUserDto(_jobCardCode, _profile, _resume, _career, _entry, _typePassword)
        SVProgressHUD.show(withStatus: "応募処理")
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        LogManager.appendApiLog("postEntry", param, function: #function, line: #line)
        ApiManager.postEntry(param, isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("postEntry", result, function: #function, line: #line)
            EntryFormManager.deleteCache(jobCardCode: _jobCard.jobCardCode)//応募フォーム情報はクリアして良し
            AnalyticsEventManager.track(type: .completeEntry)
            self.pushViewController(.entryComplete)
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("postEntry", error, function: #function, line: #line)
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
            case 404:
                //let myErr404 = MyErrorDisp(code: 404, title: "type応募", message: "この求人情報は掲載が終了しています", orgErr: nil, arrValidErrMsg: [])
                //self.showError(myErr404)
                let errMsg: String = "この求人情報は掲載が終了しています"
                self.showConfirm(title: "", message: errMsg, onlyOK: true)
            case 401:
                //let myErr401 = MyErrorDisp(code: 401, title: "type応募", message: "typeにログインできませんでした", orgErr: nil, arrValidErrMsg: [])
                //self.showError(myErr401)
                let errMsg: String = "ログインできません。入力内容をご確認ください"
                self.showConfirm(title: "", message: errMsg, onlyOK: true)
            case 400:
                let (dicGrpError, dicError) = ValidateManager.convValidErrMsgEntry(myErr.arrValidErrMsg)
                self.dicGrpValidErrMsg = dicGrpError
                self.dicValidErrMsg = dicError
                self.showError(myErr)
            default:
                self.showError(error)
            }
        }
        .finally {
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        }
    }

}
