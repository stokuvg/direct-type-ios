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

class EntryVC: PreviewBaseVC {
    var jobCard: MdlJobCardDetail? = nil//応募への遷移元は、求人カード詳細のみでOK?
    var profile: MdlProfile? = nil
    var resume: MdlResume? = nil
    var career: MdlCareer? = nil
    var entry: MdlEntry? = nil

    override func actCommit(_ sender: UIButton) {
        if validateLocalModel() {
            tableVW.reloadData()
            return
        }
    }
    //共通プレビューをOverrideして利用する
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCommit.setTitle(text: "応募する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
    }
    override func initData() {
        title = "[C-9] 応募フォーム"

        //###[Dbg]ダミーデータ投入 ___
        //いろいろモデル読み込む
        let entry = MdlEntry(ownPR: "自己PRテキストのダミー", hopeArea: ["13", "18"], hopeSalary: "8", exQuestion1: "拡張質問　その1", exQuestion2: nil, exQuestion3: "拡張質問　その3", exAnswer1: "回答1", exAnswer2: "回答2", exAnswer3: "回答3")
        self.entry = entry
        
//        self.entry?.exQuestion1 = nil
//        self.entry?.exQuestion2 = nil
//        self.entry?.exQuestion3 = nil
        //###[Dbg] ダミーデータ投入 ^^^

        
    }
    override func dispData() {
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        self.arrData.removeAll()//いったん全件を削除しておく
        editableModel.arrData.removeAll()//こちらで管理させる？！
        
        //====== [C-9]応募フォーム
        //===４．応募先求人
        arrData.append(MdlItemH(.jobCardC9, "", childItems: [
            EditableItemH(type: .model, editItem: EditItemMdlEntry.jobCard, val: "【モデルダミー】"),
        ]))
        //===５．プロフィール（一部必須）
        arrData.append(MdlItemH(.profileC0, "", childItems: [
            EditableItemH(type: .model, editItem: EditItemMdlEntry.profile, val: "【モデルダミー】"),
        ]))
        //===６．履歴書（一部必須）
        arrData.append(MdlItemH(.resumeC9, "", childItems: [
            EditableItemH(type: .model, editItem: EditItemMdlEntry.resume, val: "【モデルダミー】"),
        ]))
        //===７．職務経歴書（一部必須）
        arrData.append(MdlItemH(.careerC9, "", childItems: [
            EditableItemH(type: .model, editItem: EditItemMdlEntry.career, val: "【モデルダミー】"),
        ]))
        //===１２．独自質問（必須）
        var exQA: [EditableItemH] = []
        if let exQuestion = entry?.exQuestion1 {
            exQA.append(EditableItemH(type: .readonly, editItem: EditItemMdlEntry.exQuestionAnswer1, val: exQuestion))
            exQA.append(EditableItemH(type: .inputMemo, editItem: EditItemMdlEntry.exQuestionAnswer1, val: entry?.exAnswer1 ?? ""))
        }
        if let exQuestion = entry?.exQuestion2 {
            exQA.append(EditableItemH(type: .readonly, editItem: EditItemMdlEntry.exQuestionAnswer2, val: exQuestion))
            exQA.append(EditableItemH(type: .inputMemo, editItem: EditItemMdlEntry.exQuestionAnswer2, val: entry?.exAnswer2 ?? ""))
        }
        if let exQuestion = entry?.exQuestion3 {
            exQA.append(EditableItemH(type: .readonly, editItem: EditItemMdlEntry.exQuestionAnswer3, val: exQuestion))
            exQA.append(EditableItemH(type: .inputMemo, editItem: EditItemMdlEntry.exQuestionAnswer3, val: entry?.exAnswer3 ?? ""))
        }
        if exQA.count > 0 {
            arrData.append(MdlItemH(.exQuestionC9, "", childItems: exQA))
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
//        fetchGetProfile()
    }
}

//=== APIフェッチ
