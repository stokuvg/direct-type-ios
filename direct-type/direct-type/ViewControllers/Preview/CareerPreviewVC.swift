//
//  CareerPreviewVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

//===[C-15]「職務経歴書確認」＊単独
class CareerPreviewVC: PreviewBaseVC {
    var detail: MdlCareerCard? = nil
    //共通プレビューをOverrideして利用する
    override func initData() {
        //ダミーデータ投入しておく
        let careerCard: CareerCard =
            CareerCard(workPeriod: CareerCardWorkPeriod(startYear: "2016", startMonth: "04", endYear: "2020", endMonth: "03"),
                       companyName: "ほにゃらら産業合資会社",
                       employmentType: 2,
                       employeesCount: 256,
                       salary: 8,
                       contents: String(repeating: "職業経歴本文が入ります。",  count: 13) )
        detail = MdlCareerCard(dto: careerCard)
        //========
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        guard let _detail = detail else { return }
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
            EditableItemH(type: .selectDrum, editItem: EditItemCareerCard.employmentType, val: _detail.employmentType),
        ]))
        //case .employeesCount:   return "従業員数"
        arrData.append(MdlItemH(.employeesCountC15, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemCareerCard.employeesCount, val: _detail.employeesCount),
        ]))
        //case .salary:           return "年収"
        arrData.append(MdlItemH(.salaryC15, "", childItems: [
            EditableItemH(type: .selectDrum, editItem: EditItemCareerCard.salary, val: _detail.salary),
        ]))
        //case .contents:         return "職務内容本文"
        arrData.append(MdlItemH(.contentsC15, "", childItems: [
            EditableItemH(type: .inputMemo, editItem: EditItemCareerCard.contents, val: _detail.contents),
        ]))
    }
    override func dispData() {
        title = "[C-15]「職務経歴書確認」"
    }
}
