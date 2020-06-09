//
//  HPreviewTBCell+dispCellValue.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/18.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit


extension HPreviewTBCell {
    func dispCellValue(_ _item: MdlItemH) -> String {
        //あたいがない場合の表示、すべて同じになって良いか？
        if _item.childItems.count == 0 {
            return Constants.SelectItemsValEmpty.disp
        }
        switch _item.type {
        case .undefine:
            return "<未定義>"
        case .fullnameH2:
            if _item.childItems[0].curVal.isEmpty { return "未入力（必須）" } //初回未記入対応
            let bufFullname: String = "\(_item.childItems[0].valDisp) \(_item.childItems[1].valDisp)"
            let bufFullnameKana: String = "\(_item.childItems[2].valDisp) \(_item.childItems[3].valDisp)"
            return "\(bufFullname)（\(bufFullnameKana)）"
        case .birthGenderH2:
            let tmpBirthday: String = _item.childItems[0].curVal
            let date = DateHelper.convStr2Date(tmpBirthday)
            let bufBirthday: String = date.dispYmdJP()
            let bufAge: String = "\(date.age)歳"
            let tmpGender: String = _item.childItems[1].curVal
            let bufGender: String = SelectItemsManager.getCodeDisp(.gender, code: tmpGender)?.disp ?? "--"
            return "\(bufBirthday)（\(bufAge)） / \(bufGender)"
        case .adderssH2:
            let tmp0: String = _item.childItems[0].valDisp.zeroUme(7)
            let buf0: String = _item.childItems[0].curVal.isEmpty ? "" : "〒\(String.substr(tmp0, 1, 3))-\(String.substr(tmp0, 4, 4))"
            let tmp1: String = _item.childItems[1].curVal
            let buf1: String = SelectItemsManager.getCodeDisp(.place, code: tmp1)?.disp ?? "--"
            let buf2: String = _item.childItems[2].valDisp
            let buf3: String = _item.childItems[3].valDisp
            let bufAddress: String = "\(buf1)\(buf2)\(buf3)"
            var arrBuf: [String] = []
            if !buf0.isEmpty { arrBuf.append(buf0)}
            if !bufAddress.isEmpty { arrBuf.append(bufAddress)}
            return arrBuf.count == 0 ? "未入力" : arrBuf.joined(separator: "\n")
        case .emailH2:
            if _item.childItems[0].curVal.isEmpty { return "未入力（必須）" } //初回未記入対応
            return _item.childItems[0].curVal
            
            
        case .employmentH3:
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.employmentStatus, code: tmp0)?.disp ?? ""
            return buf0.isEmpty ? Constants.SelectItemsUndefine.disp : "\(buf0)"
        case .changeCountH3:
            //===単一選択の場合
//            let tmp0: String = _item.childItems[0].curVal
//            let buf0: String = SelectItemsManager.getCodeDisp(.changeCount, code: tmp0)?.disp ?? ""
//            return "\(buf0)"
            //[Dbg: 複数選択の場合
            let tmp0: String = _item.childItems[0].curVal
            var arr0: [String] = []
            for code in tmp0.split(separator: "_").sorted() { //コード順ソートしておく
                let buf: String = SelectItemsManager.getCodeDisp(.changeCount, code: String(code))?.disp ?? ""
                arr0.append(buf)
            }
            let buf0: String = arr0.joined(separator: " ")
            return buf0.isEmpty ? Constants.SelectItemsValEmpty.disp : "\(buf0)"
        case .lastJobExperimentH3:
            let tmp0: String = _item.childItems[0].curVal
            var disp: [String] = []
            for job in tmp0.split(separator: "_") {
                let buf = String(job).split(separator: ":")
                guard buf.count == 2 else { continue }
                let tmp0 = String(buf[0])
                let tmp1 = String(buf[1])
                let buf0: String = SelectItemsManager.getCodeDispSyou(.jobType, code: tmp0)?.disp ?? ""
                let buf1: String = SelectItemsManager.getCodeDisp(.jobExperimentYear, code: tmp1)?.disp ?? ""
                let bufExperiment: String = "\(buf0) \(buf1)"
                disp.append(bufExperiment)
            }
            return disp.count == 0 ? Constants.SelectItemsValEmpty.disp : disp.joined(separator: "\n")
        case .jobExperimentsH3:
            let tmp0: String = _item.childItems[0].curVal
            var disp: [String] = []
            for job in tmp0.split(separator: "_") {
                let buf = String(job).split(separator: ":")
                guard buf.count == 2 else { continue }
                let tmp0 = String(buf[0])
                let tmp1 = String(buf[1])
                let buf0: String = SelectItemsManager.getCodeDispSyou(.jobType, code: tmp0)?.disp ?? ""
                let buf1: String = SelectItemsManager.getCodeDisp(.jobExperimentYear, code: tmp1)?.disp ?? ""
                let bufExperiment: String = "\(buf0) \(buf1)"
                disp.append(bufExperiment)
            }
            return disp.count == 0 ? Constants.SelectItemsValEmpty.disp : disp.joined(separator: "\n")
        case .businessTypesH3:
            var disp: [String] = []
            for businessType in _item.childItems {
                let tmp0: String = businessType.curVal
                let buf0: String = SelectItemsManager.getCodeDispSyou(.businessType, code: tmp0)?.disp ?? ""
                disp.append(buf0)
            }
            return disp.count == 0 ? Constants.SelectItemsValEmpty.disp : disp.joined(separator: "\n")
        case .schoolH3:
            var disp: [String] = []
            let buf0: String = _item.childItems[0].curVal
            let buf1: String = _item.childItems[1].curVal
            let buf2: String = _item.childItems[2].curVal
            let buf3: String = _item.childItems[3].curVal
            if !buf0.isEmpty { disp.append(buf0) }
            if !"\(buf1)\(buf2)".isEmpty { disp.append("\(buf1)\(buf2)") }
            if !buf3.isEmpty { disp.append(buf3) }
            return disp.count == 0 ? Constants.SelectItemsValEmpty.disp : disp.joined(separator: "\n")
        case .skillLanguageH3:
            let tmp0: String = _item.childItems[0].curVal
            let tmp1: String = _item.childItems[1].curVal
            let buf0: String = tmp0.isEmpty ? "--" : tmp0
            let buf1: String = tmp1.isEmpty ? "--" : tmp1
            let bufToeicToefl: String = "TOEIC：\(buf0) / TOEFL：\(buf1)"
            let tmp2: String = _item.childItems[2].curVal
            let buf2: String = SelectItemsManager.getCodeDisp(.skillEnglish, code: tmp2)?.disp ?? ""
            let buf3: String = _item.childItems[3].curVal
            var disp: [String] = []
            disp.append(bufToeicToefl)
            if !buf2.isEmpty { disp.append(buf2) }
            if !buf3.isEmpty { disp.append(buf3) }
            return disp.joined(separator: "\n")
        case .qualificationsH3:
            var disp: [String] = []
            for businessType in _item.childItems {
                let tmp0: String = businessType.curVal
                let buf0: String = SelectItemsManager.getCodeDisp(.qualification, code: tmp0)?.disp ?? ""
                disp.append(buf0)
            }
            return disp.joined(separator: "\n")

        //[C-15]職務経歴書編集
        case .workPeriodC15: //雇用期間
            let tmp0: String = _item.childItems[0].curVal
            let date0 = DateHelper.convStr2Date(tmp0)
            let buf0: String = date0.dispYmdJP()
            let tmp1: String = _item.childItems[1].curVal
            let date1 = DateHelper.convStr2Date(tmp1)
            let buf1: String = date1.dispYmdJP()
            return "\(buf0)〜\(buf1)" //「現在就業中」をどう表す？「直近」の場合で、「開始」はあるが「終了」が未設定の場合か？
        case .employmentTypeC15: //雇用形態
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.employmentType, code: tmp0)?.disp ?? ""
            return "\(buf0)"
        case .salaryC15: //年収
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDisp(.salary, code: tmp0)?.disp ?? ""
            return "\(buf0)"

        //===[F-11]〜サクサク
        case .businessTypesF12: //◆F-12入力（在籍企業の業種）
            //・「在籍企業の業種」を入力する：大分類→小分類で選択する・マスタ選択入力：「K6：業種マスタ」
            let tmp0: String = _item.childItems[0].curVal
            let buf0: String = SelectItemsManager.getCodeDispSyou(.businessType, code: tmp0)?.disp ?? ""
            return "\(buf0)"
        case .workPeriodF14: //◆F-14入力（在籍期間）
            //・「在籍期間」の入力をする：「入社」「退社」の年月を、ドラム選択で入力させる
            let tmp0: String = _item.childItems[0].curVal
            let date0 = DateHelper.convStr2Date(tmp0)
            let buf0: String = date0.dispYmdJP()
            let tmp1: String = _item.childItems[1].curVal
            let date1 = DateHelper.convStr2Date(tmp1)
            let buf1: String = date1.dispYmdJP()
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
            
            print(tmp0, buf0)
            
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
            
        default:
            return _item.childItems[0].curVal
        }
    }
}
