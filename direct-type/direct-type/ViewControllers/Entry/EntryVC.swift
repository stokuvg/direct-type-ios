//
//  EntryVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//
//### [C-9] 応募フォーム
//◆C-9応募フォーム
//・項目8、相性診断の実施で自己PR生成があるので関連性あり。誘導はなし
//・【未決】応募完了するまでに入力されたものの保持
//・【未決】typeへの応募連携
//・【未決】応募未完了な状態で、複数案件への応募フォームへの入力などが許容されるのか
//
//▼処理概要：
//・指定求人に応募をするための情報を入力させる
//▽特殊処理：
//・「プロフィール」「履歴書」「職務経歴書」が、「未入力あり」か取得し、表示に反映する
//
//▼必要データ：
//▽前画面より：
//・項目4、「応募先求人」情報：「社名」「職種名」「掲載終了予定（掲載中のtype求人の子フォルダ終了日）」
//▽画面表示時フェッチ：
//1・情報取得（応募先求人）：項目4関連の情報をAPIで再取得させるか、前の画面から引き継ぐか。特定求人IDなどで応募させたい場合にはAPIが必要
//2・情報取得：「プロフィール」「履歴書」「職務経歴書」の状態取得 （＊詳細情報は[C-12]で取得する）
//3・企業からの質問項目の取得：企業が独自に設定する質問事項の「設問テキスト」の取得、0〜3件
//4・応募フォーム下書き情報の取得：ユーザが入力している情報を、サーバ側に一時保存する場合
//
//▼使用API：
//1・情報取得（応募先求人）：項目4関連の情報をAPIで再取得させるか、前の画面から引き継ぐか。特定求人IDなどで応募させたい場合にはAPIが必要
//2・情報取得：「プロフィール」「履歴書」「職務経歴書」の状態取得 （＊詳細情報は[C-12]で取得する）
//3・企業からの質問項目の取得：企業が独自に設定する質問事項の「設問テキスト」の取得、0〜3件
//4・応募フォーム下書き情報の取得：ユーザが入力している情報を、サーバ側に一時保存する場合
//ーーー
//5・応募フォーム下書き情報の更新：ユーザが入力している情報を、サーバ側に一時保存する場合
//
//▼動作：
//？？？・画面遷移する場合、下書き情報を保存して遷移する
//・[C-9#5]「プロフィール」をタップすると、[C-10]（[H-2]）へ遷移する
//・[C-9#6]「履歴書」をタップすると、[C-11]（[H-3]）へ遷移する
//・[C-9#7]「職務経歴書」をタップすると、[C-12]へ遷移する
//・[C-9#8]「」をタップすると、《共通：項目編集ポップアップ》を表示し、値を変更できる
//・[C-9#10]「希望勤務地」をタップすると、《共通：項目編集ポップアップ：複数選択》を表示し、値を変更できる
//・[C-9#11]「希望年収」をタップすると、《共通：項目編集ポップアップ：単一選択》を表示し、値を変更できる
//・[C-9#12]「企業からの質問項目(n)」をタップすると、《共通：項目編集ポップアップ：自由入力》を表示し、値を変更できる
//
//▼その他メモ：
//・アプリ統一デザインでの、項目編集ポップアップを想定


import UIKit
import TudApi
import SVProgressHUD

class EntryVC: PreviewBaseVC {
    var jobCard: MdlJobCardDetail? = nil//応募への遷移元は、求人カード詳細のみでOK?
    var profile: MdlProfile? = nil
    var resume: MdlResume? = nil
    var career: MdlCareer? = nil
    var entry: MdlEntry? = nil
    var transitionSource: AnalyticsEventType.RouteType = .unknown

    override func actCommit(_ sender: UIButton) {
        if validateLocalModel() {
            tableVW.reloadData()
            return
        }
        //===entryだけは、編集中の値を適用したモデルを生成する必要あり（or editTemp情報も渡すか）
        var _entry: MdlEntry? = entry
        if let tmp = editableModel.editTempCD[EditItemMdlEntry.exQuestionAnswer1.itemKey] { _entry?.exAnswer1 = tmp }
        if let tmp = editableModel.editTempCD[EditItemMdlEntry.exQuestionAnswer2.itemKey] { _entry?.exAnswer2 = tmp }
        if let tmp = editableModel.editTempCD[EditItemMdlEntry.exQuestionAnswer3.itemKey] { _entry?.exAnswer3 = tmp }
        if let tmp = editableModel.editTempCD[EditItemMdlEntry.ownPR.itemKey] { _entry?.ownPR = tmp }
        if let tmp = editableModel.editTempCD[EditItemMdlEntry.hopeSalary.itemKey] { _entry?.hopeSalary = tmp }
        var _hopeArea: [Code] = []
        if let tmp = editableModel.editTempCD[EditItemMdlEntry.hopeArea.itemKey] {
            for code in tmp.split(separator: EditItemTool.SplitMultiCodeSeparator) {
                _hopeArea.append(String(code))
            }
        }
        _entry?.hopeArea = _hopeArea
        //===独自質問はjobCardDetailに含まれているので、MdlEntryにも持たせておく
        if let tmp = jobCard?.entryQuestion1 { _entry?.exQuestion1 = tmp }
        if let tmp = jobCard?.entryQuestion2 { _entry?.exQuestion2 = tmp }
        if let tmp = jobCard?.entryQuestion3 { _entry?.exQuestion3 = tmp }
        pushViewController(.entryConfirm, model: (jobCard, profile, resume, career, _entry))
    }
    //共通プレビューをOverrideして利用する
    override func viewDidLoad() {
        super.viewDidLoad()
        if transitionSource != .unknown {
            AnalyticsEventManager.track(type: .toJobDetail, with: transitionSource.parameter)
        }
    }
    func initData(_ jobCard: MdlJobCardDetail) {
        title = "応募フォーム"
        self.jobCard = jobCard
        self.entry = MdlEntry()
        //===独自質問はjobCardDetailに含まれているので、MdlEntryにも持たせておく
        if let tmp = jobCard.entryQuestion1 { entry?.exQuestion1 = tmp }
        if let tmp = jobCard.entryQuestion2 { entry?.exQuestion2 = tmp }
        if let tmp = jobCard.entryQuestion3 { entry?.exQuestion3 = tmp }
    }
    override func dispData() {
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        self.arrData.removeAll()//いったん全件を削除しておく
        editableModel.arrData.removeAll()//こちらで管理させる？！
        
        //=== 応募用の自己PR膏肓が空だった場合に、 履歴書のものを適用しておく
        //８．自己PR（任意）
        //・マイページ内の自己PR（H-3履歴書確認）に入力がある場合、その内容を表示
        //・このページ上で自由に編集も可能
        //・ここで編集した内容はマイページ上の自己PRには反映されない
        //    ※あくまで応募先企業に向けたPR内容として個別編集させる想定
        if let entryOwnPR = entry?.ownPR {
            if entryOwnPR.isEmpty {
                entry?.ownPR = resume?.ownPr ?? ""
            }
        }
        

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
        if let exQuestion = entry?.exQuestion1, !exQuestion.isEmpty {
            exQA.append(MdlItemH(.exQAItem1C9, exQuestion, childItems: [
                EditableItemH(type: .inputMemo, editItem: EditItemMdlEntry.exQuestionAnswer1, val: entry?.exAnswer1 ?? "", exQuestion: exQuestion),
            ], model: career))
        }
        if let exQuestion = entry?.exQuestion2, !exQuestion.isEmpty {
            exQA.append(MdlItemH(.exQAItem2C9, exQuestion, childItems: [
                EditableItemH(type: .inputMemo, editItem: EditItemMdlEntry.exQuestionAnswer2, val: entry?.exAnswer2 ?? "", exQuestion: exQuestion),
            ], model: career))
        }
        if let exQuestion = entry?.exQuestion3, !exQuestion.isEmpty {
            exQA.append(MdlItemH(.exQAItem3C9, exQuestion, childItems: [
                EditableItemH(type: .inputMemo, editItem: EditItemMdlEntry.exQuestionAnswer3, val: entry?.exAnswer3 ?? "", exQuestion: exQuestion),
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
        chkButtonEnable()
    }
    //========================================
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispButton(isEnable: false)//いったん無効にしておく
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchGetEntryAll()
    }
    override func chkButtonEnable() {
        var isEnable: Bool = true
        if let profile = profile {
            if profile.requiredComplete == false { isEnable = false }
        } else { isEnable = false }
        if let resume = resume {
            if resume.requiredComplete == false { isEnable = false }
        } else { isEnable = false }
        if let career = career {
            if career.requiredComplete == false { isEnable = false }
        } else { isEnable = false }

        dispButton(isEnable: isEnable)
    }
    private func dispButton(isEnable: Bool) {
        if isEnable {
            btnCommit.isEnabled = true
            btnCommit.setTitle(text: "応募確認画面へ", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
            btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
            
        } else {
            btnCommit.isEnabled = false
            btnCommit.setTitle(text: "応募確認画面へ", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
            btnCommit.backgroundColor = UIColor.init(colorType: .color_close)
            
        }
    }
}

extension EntryVC {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = arrData[indexPath.row]
        switch item.type {

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
extension EntryVC {
    private func fetchGetEntryAll() {
        fetchGetProfile()//ここから多段で実施してる
    }
    private func fetchGetProfile() {
        SVProgressHUD.show(withStatus: "情報の取得")
        ApiManager.getProfile(Void(), isRetry: true)
        .done { result in
            self.profile = result
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            print(myErr)
        }
        .finally {
            self.fetchGetResume()
        }
    }
    private func fetchGetResume() {
        ApiManager.getResume(Void(), isRetry: true)
        .done { result in
            self.resume = result
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            print(myErr)
        }
        .finally {
            self.fetchGetCareerList()
        }
    }
    private func fetchGetCareerList() {
        ApiManager.getCareer(Void(), isRetry: true)
        .done { result in
            self.career = result
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            print(myErr)
        }
        .finally {
            self.dispData()
            SVProgressHUD.dismiss()
        }
    }
}

