//
//  MdlKeepJob.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/11.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient
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
    var salaryMinCode: Int
    /** 年収マスタ値 */
    var salaryMaxCode: Int
    /** true: 年収公開, false: 年収非公開 */
    var isSalaryDisplay: Bool
    /** 企業名 */
    var companyName: String
    
    // 勤務地一覧
    var areaNames:[String]
    
    // キープフラグ
    var keepStatus:Bool
    
    /** スカウト通知 **/
    var scoutStatus: Bool
    /** エントリー済 **/
    var entryStatus: Bool

    init(jobId: String = "", jobName: String = "", pressStartDate: String = "", pressEndDate: String = "", mainTitle: String = "", mainPhotoURL: String = "", salaryMinCode: Int = 0, salaryMaxCode: Int = 0, isSalaryDisplay: Bool = false, companyName: String = "", areaNames: [String] = [], keepStatus:Bool = true, scoutStatus:Bool = false, entryStatus:Bool = false) {
        self.jobId = jobId
        self.jobName = jobName
        self.pressStartDate = pressStartDate
        self.pressEndDate = pressEndDate
        self.mainTitle = mainTitle
        self.mainPhotoURL = mainPhotoURL
        self.salaryMinCode = salaryMinCode
        self.salaryMaxCode = salaryMaxCode
        self.isSalaryDisplay = isSalaryDisplay
        self.companyName = companyName
        
        self.areaNames = areaNames
        
        self.keepStatus = keepStatus
        
        self.scoutStatus = scoutStatus
        
        self.entryStatus = entryStatus
    }
    // TudApiのデータを変換して保持
    convenience init(dto: KeepJob) {
        
        let _minSalaryId = Int(dto.minSalaryId)
        let _maxSalaryId = Int(dto.maxSalaryId)
        
        let randomInt = Int.random(in: 0..<2)
        let dummyScout = Bool(truncating: randomInt as NSNumber)
        
        let entryRandomInt = Int.random(in: 0..<2)
        let dummyEntry = Bool(truncating: entryRandomInt as NSNumber)
        
        self.init(jobId: dto.jobId, jobName: dto.jobName,pressStartDate:dto.pressStartDate,pressEndDate:dto.pressEndDate, mainTitle:dto.mainTitle,mainPhotoURL: dto.mainPhotoURL , salaryMinCode: _minSalaryId!, salaryMaxCode: _maxSalaryId!, isSalaryDisplay: dto.isSalaryDisplay, companyName: dto.companyName, areaNames:dto.place2Ids, scoutStatus: dummyScout, entryStatus: dummyEntry)
    }
}
