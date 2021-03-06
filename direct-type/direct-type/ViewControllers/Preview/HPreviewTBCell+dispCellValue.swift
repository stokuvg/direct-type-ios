//
//  HPreviewTBCell+dispCellValue.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/18.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit


extension HPreviewTBCell {
    func dispCellValue2(_ _item: MdlItemH) -> String? {
        //あたいがない場合の表示、すべて同じになって良いか？
        if _item.childItems.count == 0 {
            return Constants.SelectItemsValEmpty.disp
        }
        switch _item.type {
        case .undefine:
            return "<未定義>"
        //========================
        //[C-15]職務経歴書編集
        //※ウィンドウの初期表示は「選択してください」
        //タップするとドラムが開き、その初期選択値が、開始は{2018/04}、終了は現在の年月を取得して入れる
        //※退社時期が入社時期より前に設定されている場合はエラー
        case .workPeriodC15:      //===雇用期間
            let tmp0: String = _item.childItems[0].curVal
            let date0 = DateHelper.convStrYM2Date(tmp0)
            if date0 == Constants.SelectItemsUndefineDate { return nil } //初回未記入対応
            let buf0: String = date0.dispYmJP()
            let tmp1: String = _item.childItems[1].curVal
            let date1 = DateHelper.convStrYM2Date(tmp1)
            if date1 == Constants.SelectItemsUndefineDate { return nil } //初回未記入対応
            let buf1: String = date1.dispYmJP()
            return "\(buf0)〜\(buf1)"
        case .companyNameC15:     //===企業名
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            return _item.childItems[0].curVal
        case .employmentTypeC15:  //===雇用形態
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.employmentType, code: tmp0)?.disp ?? ""
            return buf0.isEmpty ? Constants.SelectItemsUndefine.disp : "\(buf0)"
        case .employeesCountC15:  //===従業員数（数値）*これは直接数値入力で良い
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = "\(tmp0)名"
            return "\(buf0)"
        case .salaryC15:          //===年収（数値）
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.salarySelect, code: tmp0)?.disp ?? ""
            return "\(buf0)"
        case .contentsC15:        //===職務内容本文
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            return _item.childItems[0].curVal

        //========================
        //=== [C-9]応募フォーム
        case .jobCardC9:      //４．応募先求人
            if _item.childItems[0].curVal.isEmpty { return "【モデル】" }
            return "【モデル】差し替え"
        case .profileC9:      //５．プロフィール（一部必須）
            if _item.childItems[0].curVal.isEmpty { return "【モデル】" }
            return "【モデル】差し替え"
        case .resumeC9:       //６．履歴書（一部必須）
            if _item.childItems[0].curVal.isEmpty { return "【モデル】" }
            return "【モデル】差し替え"
        case .careerC9:       //７．職務経歴書（一部必須）
            if _item.childItems[0].curVal.isEmpty { return "【モデル】" }
            return "【モデル】差し替え"
        case .exQuestionC9:   //１２．独自質問（必須）
            var disp: [String] = []
            for item in _item.childItems {
                disp.append(item.curVal)
            }
            return disp.count == 0 ? "非表示にすべきもの" : disp.joined(separator: "\n")
        case .ownPRC9:        //９．自己PR文字カウント
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            return _item.childItems[0].curVal
        case .hopeAreaC9:     //１０．希望勤務地（任意）
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            if _item.childItems[0].curVal == Constants.ExclusiveSelectCodeDisp.code {
                return Constants.ExclusiveSelectCodeDisp.disp
            }
            let tmp0: String = _item.childItems[0].curVal
            var arr0: [String] = []
            for cd in SelectItemsManager.convCodeDisp(.entryPlace, tmp0) { //マスタ順ソートしておく
                arr0.append(cd.disp)
            }
            let buf0: String = arr0.joined(separator: " / ")
            return buf0.isEmpty ? Constants.SelectItemsValEmpty.disp : "\(buf0)"
        case .hopeSalaryC9:   //１１．希望年収（任意）
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.salaryCode, code: tmp0)?.disp ?? ""
            return "\(buf0)"

        //========================
        case .fullnameH2:
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let bufFullname: String = "\(_item.childItems[0].valDisp) \(_item.childItems[1].valDisp)"
            let bufFullnameKana: String = "\(_item.childItems[2].valDisp) \(_item.childItems[3].valDisp)"
            return "\(bufFullname)（\(bufFullnameKana)）"
        case .birthH2:
            let tmpBirthday: String = _item.childItems[0].curVal
            let date = DateHelper.convStrYMD2Date(tmpBirthday)
            if date == Constants.SelectItemsUndefineDate { return nil } //初回未記入対応
            let bufBirthday: String = date.dispYmdJP()
            let bufAge: String = "\(date.age)歳"
            return "\(bufBirthday)（\(bufAge)）"
        case .genderH2:
            let tmpGender: String = _item.childItems[0].curVal
            let bufGender: String = SelectItemsManager.getCodeDisp(.gender, code: tmpGender)?.disp ?? "--"
            return "\(bufGender)"
        case .adderssH2:
            let tmp0: String = _item.childItems[0].valDisp.zeroUme(7)
            let buf0: String = _item.childItems[0].curVal.isEmpty ? "" : "〒\(String.substr(tmp0, 1, 3))-\(String.substr(tmp0, 4, 4))"
            let tmp1: String = _item.childItems[1].curVal
            let buf1: String = SelectItemsManager.getCodeDisp(.place, code: tmp1)?.disp ?? ""
            let buf2: String = _item.childItems[2].valDisp
            let buf3: String = _item.childItems[3].valDisp
            let bufAddress: String = "\(buf1)\(buf2)\(buf3)"
            var arrBuf: [String] = []
            if !buf0.isEmpty { arrBuf.append(buf0)}
            if !bufAddress.isEmpty { arrBuf.append(bufAddress)}
            return arrBuf.count == 0 ? nil : arrBuf.joined(separator: "\n")
        case .emailH2:
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            return _item.childItems[0].curVal
        case .hopeAreaH2:
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            if _item.childItems[0].curVal == Constants.ExclusiveSelectCodeDisp.code {
                return Constants.ExclusiveSelectCodeDisp.disp
            }
            var arr0: [String] = []
            for cd in SelectItemsManager.convCodeDisp(.entryPlace, tmp0) { //マスタ順ソートしておく
                arr0.append(cd.disp)
            }
            let buf0: String = arr0.joined(separator: " / ")
            return buf0.isEmpty ? Constants.SelectItemsValEmpty.disp : "\(buf0)"
        //========================
        //=== [H-3]履歴書編集
        case .employmentH3:           //===(3a)就業状況
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.employmentStatus, code: tmp0)?.disp ?? ""
            return buf0.isEmpty ? Constants.SelectItemsUndefine.disp : "\(buf0)"
        case .currentSalaryH3:        //===現在の年収
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.salarySelect, code: tmp0)?.disp ?? ""
            return buf0.isEmpty ? Constants.SelectItemsUndefine.disp : "\(buf0)"
        case .changeCountH3:          //===(3b)転職回数
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.changeCount, code: tmp0)?.disp ?? ""
            return "\(buf0)"
        case .lastJobExperimentA11: fallthrough
        case .lastJobExperimentH3:    //===(3c)直近の経験職種
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            let disp = EditItemTool.dispTypeAndYear(codes: tmp0, .jobType, .jobExperimentYear)
            return disp.count == 0 ? Constants.SelectItemsValEmpty.disp : disp.joined(separator: "\n")
        case .jobExperimentsA14: fallthrough
        case .jobExperimentsH3:       //===(3d)その他の経験職種
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            let disp = EditItemTool.dispTypeAndYear(codes: tmp0, .jobType, .jobExperimentYear)
            return disp.count == 0 ? Constants.SelectItemsValEmpty.disp : disp.joined(separator: "\n")
        case .businessTypesH3:        //===(3e)経験業種
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            let disp = EditItemTool.dispType(codes: tmp0, .businessType)
            return disp.count == 0 ? Constants.SelectItemsValEmpty.disp : disp.joined(separator: "\n")
        case .schoolH3:               //===(3f)最終学歴（childItems[0]は非表示）
            var disp: [String] = []
            let buf0: String = _item.childItems[1].curVal
            let buf1: String = _item.childItems[2].curVal
            let buf2: String = _item.childItems[3].curVal
            let buf3: String = _item.childItems[4].curVal
            if !buf0.isEmpty { disp.append(buf0) }
            if !"\(buf1)\(buf2)".isEmpty { disp.append("\(buf1)\(buf2)") }
            let date3 = DateHelper.convStrYM2Date(buf3)
            if date3 == Constants.SelectItemsUndefineDate {
            } else {
                disp.append("\(date3.dispYmJP())卒業")
            }
            return disp.count == 0 ? nil : disp.joined(separator: "\n")
        case .skillLanguageH3:        //===(3g)語学
            var tmp0: String = _item.childItems[0].curVal
            var tmp1: String = _item.childItems[1].curVal
            tmp0 = (tmp0 == "0" ? "" : tmp0)
            tmp1 = (tmp1 == "0" ? "" : tmp1)
            let buf0: String = tmp0.isEmpty ? "--" : "\(tmp0)点"
            let buf1: String = tmp1.isEmpty ? "--" : "\(tmp1)点"
            let bufToeicToefl: String = "TOEIC：\(buf0) / TOEFL：\(buf1)"
            let tmp2: String = _item.childItems[2].curVal
            let buf2: String = SelectItemsManager.getCodeDisp(.skillEnglish, code: tmp2)?.disp ?? ""
            let buf3: String = _item.childItems[3].curVal
            var disp: [String] = []
            disp.append(bufToeicToefl)
            if !buf2.isEmpty { disp.append("英語：\(buf2)") }
            if !buf3.isEmpty { disp.append(buf3) }
            return disp.joined(separator: "\n")
        case .qualificationsH3:       //===(3h)資格
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            var disp: [String] = []
            for item in SelectItemsManager.convCodeDisp(.qualification, _item.childItems[0].curVal) {
                let buf0: String = item.disp
                disp.append(buf0)
            }
            return disp.joined(separator: " / ")
        case .ownPrH3:                  //===(3i)自己PR
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            return _item.childItems[0].curVal

        //========================
        //===[F-11]〜サクサク
        case .businessTypesF12: //◆F-12入力（在籍企業の業種）
            //・「在籍企業の業種」を入力する：大分類→小分類で選択する・マスタ選択入力：「K6：業種マスタ」
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDispSyou(.businessType, code: tmp0)?.disp ?? ""
            return "\(buf0)"
        case .workPeriodF14: //◆F-14入力（在籍期間）
            //・「在籍期間」の入力をする：「入社」「退社」の年月を、ドラム選択で入力させる
            let tmp0: String = _item.childItems[0].curVal
            let date0 = DateHelper.convStrYM2Date(tmp0)
            let buf0: String = date0.dispYmJP()
            let tmp1: String = _item.childItems[1].curVal
            let date1 = DateHelper.convStrYM2Date(tmp1)
            let buf1: String = date1.dispYmJP()
            return "\(buf0)〜\(buf1)"
        case .employmentTypeF15: //◆F-15入力（雇用形態）
            //・「雇用形態」の入力をする・マスタ選択入力：「雇用形態マスタ」
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.employmentType, code: tmp0)?.disp ?? ""
            return "\(buf0)"
        case .managementsF16: //◆F-16入力（マネジメント経験）
            //・「マネジメント経験」の入力をする・単一選択で即遷移する
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.management, code: tmp0)?.disp ?? ""
            return "\(buf0)"
        case .pcSkillF22: //◆F-22職種別入力（PCスキル）
            //・「PCスキル」の入力をする：「Excel」「Word」「PowerPoint」・それぞれドラム選択
            let tmp0: String = _item.childItems[0].curVal
            let tmp1: String = _item.childItems[1].curVal
            let tmp2: String = _item.childItems[2].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.pcSkillExcel, code: tmp0)?.disp ?? ""
            let buf1: String = SelectItemsManager.getCodeDisp(.pcSkillWord, code: tmp1)?.disp ?? ""
            let buf2: String = SelectItemsManager.getCodeDisp(.pcSkillPowerPoint, code: tmp2)?.disp ?? ""
            var disp: [String] = []
            disp.append("Excel: \(buf0)")
            disp.append("Word: \(buf1)")
            disp.append("PowerPoint: \(buf2)")
            return disp.joined(separator: "\n")
        //========================
        //[A系統]初回入力
        case .nicknameA6:             //=== [A-5/6] 入力（ニックネーム）
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            return _item.childItems[0].curVal
        case .genderA7:               //=== [A-7] 入力（性別）
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応（スキップ可能から必須になった）
            let tmpGender: String = _item.childItems[0].curVal
            let bufGender: String = SelectItemsManager.getCodeDisp(.gender, code: tmpGender)?.disp ?? "--"
            return "\(bufGender)"
        case .birthdayA8:             //=== [A-8] 入力（生年月日）
            let tmpBirthday: String = _item.childItems[0].curVal
            let date = DateHelper.convStrYMD2Date(tmpBirthday)
            if date == Constants.SelectItemsUndefineDate { return nil} //初回未記入対応
            let bufBirthday: String = date.dispYmdJP()
            let bufAge: String = "\(date.age)歳"
            return "\(bufBirthday)（\(bufAge)）"
        case .hopeAreaA9:             //=== [A-9] 入力（希望勤務地）
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            if _item.childItems[0].curVal == Constants.ExclusiveSelectCodeDisp.code {
                return Constants.ExclusiveSelectCodeDisp.disp
            }
            let tmp0: String = _item.childItems[0].curVal
            var arr0: [String] = []
            for cd in SelectItemsManager.convCodeDisp(.entryPlace, tmp0) { //マスタ順ソートしておく
                arr0.append(cd.disp)
            }
            let buf0: String = arr0.joined(separator: " / ")
            return buf0.isEmpty ? Constants.SelectItemsValEmpty.disp : "\(buf0)"
        case .schoolA10:              //=== [A-10] 入力（最終学歴）
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.schoolType, code: tmp0)?.disp ?? ""
            return "\(buf0)"
        case .employmentStatusA21:    //=== [A-21] 入力（就業状況）
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.employmentStatus, code: tmp0)?.disp ?? ""
            return "\(buf0)"
        //case .lastJobExperimentA11   //=== [A-11] 入力（直近経験職種）[A-12] 入力（直近の職種の経験年数）
        case .currentSalaryA13:              //=== [A-13] 入力（現在の年収）
            if _item.childItems[0].curVal.isEmpty { return nil } //初回未記入対応
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.salarySelect, code: tmp0)?.disp ?? ""
            return "\(buf0)"
        //case jobExperimentsA14      //=== [A-14] 入力（追加経験職種）
        //========================
        //========================

        default:
            return _item.childItems[0].curVal
        }
    }
}
