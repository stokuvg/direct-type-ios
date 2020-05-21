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
    /** 年収例コード */
    var salaryCode: Int
    /** 勤務地コード */
    var workPlaceCode: [Int]
    var userFilter: UserFilterInfo
    
    init(jobCardCode: String,displayPeriod:EntryFormInfoDisplayPeriod, companyName: String, jobName:String, mainTitle:String, mainPicture: String, salaryCode:Int, workPlaceCode:[Int], userFilter:UserFilterInfo) {
        self.jobCardCode = jobCardCode
        self.displayPeriod = displayPeriod
        self.companyName = companyName
        self.jobName = jobName
        self.mainTitle = mainTitle
        self.mainPicture = mainPicture
        self.salaryCode = salaryCode
        self.workPlaceCode = workPlaceCode
        self.userFilter = userFilter
    }
    
    //ApiモデルをAppモデルに変換して保持
    convenience init(dto: JobCardBig) {
        
        let _displayPeriod = dto.displayPeriod
        let _userFilter = dto.userFilter
        
        self.init(jobCardCode: dto.jobCardCode, displayPeriod: _displayPeriod, companyName: dto.companyName, jobName: dto.jobName, mainTitle:dto.mainTitle, mainPicture: dto.mainPicture, salaryCode: dto.salaryCode, workPlaceCode: dto.workPlaceCode, userFilter: _userFilter)
    }

    var debugDisp: String {
        return ""
    }
}
