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
    
    /*
     // TudApi Job
     /** 求人ID */
     public var jobId: String
     /** 外部表示用職種名 */
     public var jobName: String
     /** 掲載開始日（ISO8601[YYYY-MM-DD]） */
     public var pressStartDate: String
     /** 掲載終了日（ISO8601[YYYY-MM-DD]） */
     public var pressEndDate: String
     /** メイン記事メインタイトル */
     public var mainTitle: String
     /** 年収マスタ値 */
     public var minSalaryId: String
     /** 年収マスタ値 */
     public var maxSalaryId: String
     /** true: 年収公開, false: 年収非公開 */
     public var isSalaryDisplay: Bool
     /** 企業名 */
     public var companyName: String
     /** true: キープしている, false: キープしていない */
     public var isKeep: Bool
     */

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
    
    init(jobCardCode: String = "",displayPeriod:EntryFormInfoDisplayPeriod = EntryFormInfoDisplayPeriod.init(startAt: "", endAt: ""), companyName: String = "", jobName:String = "", mainTitle:String = "", mainPicture: String = "", salaryMinCode:Int = 0, salaryMaxCode:Int = 0, salaryDisplay:Bool = false, workPlaceCode:[Int] = [], keepStatus:Bool = false) {
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
    }
    
    // TudApiのデータを変換して保持
    convenience init(dto: Job) {
        /*
         /** 求人ID */
         public var jobId: String
         /** 外部表示用職種名 */
         public var jobName: String
         /** 掲載開始日（ISO8601[YYYY-MM-DD]） */
         public var pressStartDate: String
         /** 掲載終了日（ISO8601[YYYY-MM-DD]） */
         public var pressEndDate: String
         /** メイン記事メインタイトル */
         public var mainTitle: String
         /** 年収マスタ値 */
         public var minSalaryId: String
         /** 年収マスタ値 */
         public var maxSalaryId: String
         /** true: 年収公開, false: 年収非公開 */
         public var isSalaryDisplay: Bool
         /** 企業名 */
         public var companyName: String
         /** true: キープしている, false: キープしていない */
         public var isKeep: Bool
         */
        
        let jobCardCode = dto.jobId
        let _displayPeriod = EntryFormInfoDisplayPeriod.init(startAt: dto.pressStartDate, endAt: dto.pressEndDate)
        let minCode = Int(dto.minSalaryId)
        let maxCode = Int(dto.maxSalaryId)
        
        var placeCodes:[Int] = []
        for i in 0..<dto.place2Ids.count {
            let code = Int(dto.place2Ids[i])
            placeCodes.append(code!)
        }

        self.init(jobCardCode: jobCardCode, displayPeriod: _displayPeriod, companyName: dto.companyName, jobName: dto.jobName, mainTitle:dto.mainTitle,mainPicture: dto.mainPhotoURL , salaryMinCode: minCode!, salaryMaxCode: maxCode!, salaryDisplay: dto.isSalaryDisplay,workPlaceCode:placeCodes, keepStatus: dto.isKeep)
    }

    var debugDisp: String {
        return ""
    }
}
