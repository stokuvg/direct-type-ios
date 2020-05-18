//
//  SnoothCareerPreviewVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

//===[F-11]〜サクサク
class SnoothCareerPreviewVC: PreviewBaseVC {
    var detail: MdlCareerCard? = nil
    //共通プレビューをOverrideして利用する
    override func initData() {
        //ダミーデータ投入しておく
        let careerCard: CareerCard =
            CareerCard(workPeriod: CareerCardWorkPeriod(startYear: "2016", startMonth: "04", endYear: "2020", endMonth: "03"),
                       companyName: "ほにゃらら産業合資会社",
                       employmentType: 2,
                       employeesCount: 2,
                       salary: 8,
                       contents: String(repeating: "職業経歴本文が入ります。",  count: 13) )
        detail = MdlCareerCard(dto: careerCard)
        //========
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        guard let _detail = detail else { return }
    }
    override func dispData() {
        title = "[F-11]「サクサク職歴」"
    }
}
