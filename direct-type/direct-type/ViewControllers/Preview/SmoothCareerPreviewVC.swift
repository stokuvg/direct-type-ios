//
//  SmoothCareerPreviewVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

//===[F-11]〜サクサク
class SmoothCareerPreviewVC: PreviewBaseVC {
    var detail: MdlAppSmoothCareer? = nil
    //共通プレビューをOverrideして利用する
    override func initData() {
        //ダミーデータ投入しておく
        let tmpStartDate: String = "2015-04-01"
        let dateStartDate = DateHelper.convStr2Date(tmpStartDate)
        let tmpEndDate: String = "2020-05-01"
        let dateEndDate = DateHelper.convStr2Date(tmpEndDate)
        let bufWorkBackgroundDetail: MdlAppSmoothCareerWorkBackgroundDetail =
        MdlAppSmoothCareerWorkBackgroundDetail(businessType: "2", experienceManagement: "3", skillExcel: "4", skillWord: "4", skillPowerPoint: "4")
        let smoothCareer: MdlAppSmoothCareer =
        MdlAppSmoothCareer(componyDescription: MdlAppSmoothCareerComponyDescription(companyName: "篠原重工株式会社", employeesCount: "512", workPeriod: MdlAppSmoothCareerComponyDescriptionWorkPeriod(workStartDate: dateStartDate, workEndDate: dateEndDate), employmentType: "1"), workBackgroundDetail: bufWorkBackgroundDetail, salary: "1")
        detail = smoothCareer
        //========
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        guard let _detail = detail else { return }
        //◆F-11入力（勤務先企業名）
        //・テキスト入力（サジェスト付き）：「企業名」でサジェスト
        arrData.append(MdlItemH(.companyNameF11, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlAppSmoothCareerComponyDescription.companyName, val: _detail.componyDescription.companyName),
        ]))
        //◆F-12入力（在籍企業の業種）
        //・「在籍企業の業種」を入力する：大分類→小分類で選択する・マスタ選択入力：「K6：業種マスタ」
        arrData.append(MdlItemH(.businessTypesF12, "", childItems: [
            EditableItemH(type: .selectSpecisl, editItem: EditItemMdlAppSmoothCareerWorkBackgroundDetail.businessType, val: _detail.workBackgroundDetail.businessType),
        ]))
        //◆F-13入力（社員数）
        //・「社員数」の入力をする・数値入力：「8桁以上はエラー（従業員数の最大が230万人）」
        arrData.append(MdlItemH(.employeesCountF13, "", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlAppSmoothCareerComponyDescription.employeesCount, val: _detail.componyDescription.employeesCount),
        ]))
        //◆F-14入力（在籍期間）
        //・「在籍期間」の入力をする：「入社」「退社」の年月を、ドラム選択で入力させる
        arrData.append(MdlItemH(.workPeriodF14, "", childItems: [
            EditableItemH(type: .selectDrumYMD, editItem: EditItemMdlAppSmoothCareerComponyDescriptionWorkPeriod.workStartDate, val: _detail.componyDescription.workPeriod.workStartDate.dispYmd()),
            EditableItemH(type: .selectDrumYMD, editItem: EditItemMdlAppSmoothCareerComponyDescriptionWorkPeriod.workEndDate, val: _detail.componyDescription.workPeriod.workEndDate.dispYmd()),
        ]))
        //◆F-15入力（雇用形態）
        //・「雇用形態」の入力をする・マスタ選択入力：「雇用形態マスタ」
        arrData.append(MdlItemH(.employmentTypeF15, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlAppSmoothCareerComponyDescription.employmentType, val: _detail.componyDescription.employmentType),
        ]))
        //◆F-16入力（マネジメント経験）
        //・「マネジメント経験」の入力をする・単一選択で即遷移する
        //・以下の選択肢から一つ選択　※マスタなしで、以下の選択肢を使用
        //マネジメント経験はない
        //ある（～5人）
        //ある（6～10人）
        //ある（11人～）
        arrData.append(MdlItemH(.managementsF16, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlAppSmoothCareerWorkBackgroundDetail.experienceManagement, val: _detail.workBackgroundDetail.experienceManagement),
        ]))
        //◆F-22職種別入力（PCスキル）
        //・「PCスキル」の入力をする：「Excel」「Word」「PowerPoint」・それぞれドラム選択
        arrData.append(MdlItemH(.pcSkillF22, "", childItems: [
            EditableItemH(type: .selectSingle, editItem: EditItemMdlAppSmoothCareerWorkBackgroundDetail.skillExcel, val: _detail.workBackgroundDetail.skillExcel),
            EditableItemH(type: .selectSingle, editItem: EditItemMdlAppSmoothCareerWorkBackgroundDetail.skillWord, val: _detail.workBackgroundDetail.skillWord),
            EditableItemH(type: .selectSingle, editItem: EditItemMdlAppSmoothCareerWorkBackgroundDetail.skillPowerPoint, val: _detail.workBackgroundDetail.skillPowerPoint),
        ]))
    }
    override func dispData() {
        title = "[F-11]「サクサク職歴」"
    }
}
