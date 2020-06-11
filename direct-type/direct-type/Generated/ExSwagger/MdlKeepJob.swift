//
//  MdlKeepJob.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/11.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import TudApi

class MdlKeepJob: Codable {

    /** 求人ID */
    var jobId: String
    /** 外部表示用職種名 */
    var jobName: String
    /** 掲載開始日（ISO8601[YYYY-MM-DD]） */
    var pressStartDate: String
    /** 掲載終了日（ISO8601[YYYY-MM-DD]） */
    var pressEndDate: String
    /** メイン記事メインタイトル */
    var mainTitle: String
    /** 求人メイン画像URL */
    var mainPhotoURL: String
    /** 年収マスタ値 */
    var minSalaryId: String
    /** 年収マスタ値 */
    var maxSalaryId: String
    /** true: 年収公開, false: 年収非公開 */
    var isSalaryDisplay: Bool
    /** 企業名 */
    var companyName: String

    init(jobId: String, jobName: String, pressStartDate: String, pressEndDate: String, mainTitle: String, mainPhotoURL: String, minSalaryId: String, maxSalaryId: String, isSalaryDisplay: Bool, companyName: String) {
        self.jobId = jobId
        self.jobName = jobName
        self.pressStartDate = pressStartDate
        self.pressEndDate = pressEndDate
        self.mainTitle = mainTitle
        self.mainPhotoURL = mainPhotoURL
        self.minSalaryId = minSalaryId
        self.maxSalaryId = maxSalaryId
        self.isSalaryDisplay = isSalaryDisplay
        self.companyName = companyName
    }
    // TudApiのデータを変換して保持
    convenience init(dto: KeepJob) {
        
        self.init(jobId: dto.jobId, jobName: dto.jobName,pressStartDate:dto.pressStartDate,pressEndDate:dto.pressEndDate, mainTitle:dto.mainTitle,mainPhotoURL: dto.mainPhotoURL , minSalaryId: dto.minSalaryId, maxSalaryId: dto.maxSalaryId, isSalaryDisplay: dto.isSalaryDisplay, companyName: dto.companyName)
    }
}
