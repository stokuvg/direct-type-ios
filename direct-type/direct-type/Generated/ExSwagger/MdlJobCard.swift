//
//  MdlJobCard.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/21.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient
import TudApi

/** 求人カード (1求人ごと) **/
class MdlJobCard: Codable {

    /** 求人コード */
    var jobCardCode: String
    var displayPeriod: EntryFormInfoDisplayPeriod
    /** 企業名 */
    var companyName: String
    /** 外部表示用職種名 */
    var jobName: String
    /** メイン記事メインタイトル */
    var mainTitle: String
    /** メイン記事写真 */
    var mainPicture: String
    /** 年収下限例コード */
    var salaryMinCode: Int
    /** 年収下限例コード */
    var salaryMaxCode: Int
    /** 年収公開フラグ **/
    var salaryDisplay: Bool
    /** 勤務地コード */
    var workPlaceCode: [Int]
    /** キープ状態 **/
    var keepStatus: Bool
    /** 見送り状態 **/
//    var skipStatus: Bool
    
//    var userFilter: UserFilterInfo
    /** スカウト通知 **/
    var scoutStatus: Bool
    
    init(jobCardCode: String = "",displayPeriod:EntryFormInfoDisplayPeriod = EntryFormInfoDisplayPeriod.init(startAt: "", endAt: ""), companyName: String = "", jobName:String = "", mainTitle:String = "", mainPicture: String = "", salaryMinCode:Int = 0, salaryMaxCode:Int = 0, salaryDisplay:Bool = false, workPlaceCode:[Int] = [], keepStatus:Bool = false, scoutStatus:Bool = false) {
        self.jobCardCode = jobCardCode
        self.displayPeriod = displayPeriod
        self.companyName = companyName
        self.jobName = jobName
        self.mainTitle = mainTitle
        self.mainPicture = mainPicture
        self.salaryMinCode = salaryMinCode
        self.salaryMaxCode = salaryMaxCode
        self.salaryDisplay = salaryDisplay
        self.workPlaceCode = workPlaceCode
        self.keepStatus = keepStatus
//        self.skipStatus = skipStatus
//        self.userFilter = userFilter
        self.scoutStatus = scoutStatus
    }
    
    // TudApiのデータを変換して保持
    convenience init(dto: Job) {
//        Log.selectLog(logLevel: .debug, "MdlJobCard con init start")
        
        let jobCardCode = dto.jobId
        let _displayPeriod = EntryFormInfoDisplayPeriod.init(startAt: dto.pressStartDate, endAt: dto.pressEndDate)
        let minCode = Int(dto.minSalaryId) ?? 0
        let maxCode = Int(dto.maxSalaryId) ?? 0
        
        var placeCodes:[Int] = []
        for i in 0..<dto.place2Ids.count {
            let code = Int(dto.place2Ids[i])
            placeCodes.append(code!)
        }
        
        let keepStatus = dto.isKeep
//        Log.selectLog(logLevel: .debug, "keepStatus:\(keepStatus)")
        
        
        let randomInt = Int.random(in: 0..<2)
        
        let dummyScout = Bool(truncating: randomInt as NSNumber)

        self.init(jobCardCode: jobCardCode, displayPeriod: _displayPeriod, companyName: dto.companyName, jobName: dto.jobName, mainTitle:dto.mainTitle,mainPicture: dto.mainPhotoURL , salaryMinCode: minCode, salaryMaxCode: maxCode, salaryDisplay: dto.isSalaryDisplay,workPlaceCode:placeCodes, keepStatus: keepStatus, scoutStatus: dummyScout)
    }

    var debugDisp: String {
        return ""
    }
}
