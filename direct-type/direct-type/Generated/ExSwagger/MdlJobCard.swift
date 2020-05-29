//
//  MdlJobCard.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/21.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

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
    var skipStatus: Bool
    
    var userFilter: UserFilterInfo
    
    init(jobCardCode: String = "",displayPeriod:EntryFormInfoDisplayPeriod = EntryFormInfoDisplayPeriod.init(startAt: "", endAt: ""), companyName: String = "", jobName:String = "", mainTitle:String = "", mainPicture: String = "", salaryMinCode:Int = 0, salaryMaxCode:Int = 0, salaryDisplay:Bool = false, workPlaceCode:[Int] = [], keepStatus:Bool = false, skipStatus:Bool = false, userFilter:UserFilterInfo = UserFilterInfo(tudKeepStatus: false, tudSkipStatus: false)) {
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
        self.skipStatus = skipStatus
        self.userFilter = userFilter
    }
    
    //ApiモデルをAppモデルに変換して保持
    convenience init(dto: JobCardBig) {
        
        let _displayPeriod = dto.displayPeriod
        let _userFilter = dto.userFilter
        
        let minCode = dto.minSalaryId!
        let maxCode = dto.maxSalaryId!
        let salaryDisplay = dto.isSalaryDisplay!
        let keep = dto.keepStatus
        let skip = dto.skipStatus
        
        self.init(jobCardCode: dto.jobCardCode, displayPeriod: _displayPeriod, companyName: dto.companyName, jobName: dto.jobName, mainTitle:dto.mainTitle, mainPicture: dto.mainPicture, salaryMinCode: minCode, salaryMaxCode: maxCode, salaryDisplay: salaryDisplay, workPlaceCode: dto.workPlaceCode, keepStatus: keep, skipStatus: skip, userFilter: _userFilter)
    }

    var debugDisp: String {
        return ""
    }
}
