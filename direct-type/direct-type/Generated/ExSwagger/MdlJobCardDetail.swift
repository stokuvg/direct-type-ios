//
//  MdlJobCardDetail.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/25.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class MdlJobCardDetail: Codable {

    /** 求人コード */
    var jobCardCode: String
    /** ６．職種名 */
    var jobName: String
    /** ７．給与＊年収例コード＊ */
    var salaryMinId: Int
    var salaryMaxId: Int
    /** 給与公開フラグ */
    var isSalaryDisplay: Bool
    /** スカウトによる提示年収＊初回は未使用＊ */
    var salaryOffer: String
    /** ８．勤務地 */
    var workPlaceCodes: [Int]
    /** ９．社名＊外部表示用職種名＊ */
    var companyName: String
    var displayPeriod: JobCardDetailDisplayPeriod
    /** １１．求人メイン画像＊メイン記事写真＊ */
    var mainPicture: String
    /** サブ画像 **/
    var subPictures: [String]
    /** メイン記事メインタイトル */
    var mainTitle: String
    /** メイン記事本文 */
    var mainContents: String
    var prCodes: [Int]
    /** １４．給与例 */
    var salarySample: String
    /** 15．募集背景（必須） */
    var recruitmentReason: String
    /** １６．仕事内容（必須） */
    var jobDescription: JobCardDetailJobDescription
    /** １７．案件例（任意） */
    var jobExample: JobCardDetailJobExample
    /** １８．手がける商品・サービス（任意） */
    var product: [JobCardDetailProduct]
    /** １９．開発環境・業務範囲（任意） */
    var scope: [JobCardDetailScope]
    /** 注目ポイント見出し１ */
    var spotTitle1: String
    /** 注目ポイント本文１ */
    var spotDetail1: String
    /** 注目ポイント見出し２ */
    var spotTitle2: String
    /** 注目ポイント本文２ */
    var spotDetail2: String
    /** ２１．応募資格（必須） */
    var qualification: String
    /** ２２．歓迎する経験・スキル（任意） */
    var betterSkill: String
    /** ２３．過去の採用例（任意） */
    var applicationExample: String
    /** ２４．この仕事の向き・不向き（任意） */
    var suitableUnsuitable: String
    /** ２５．雇用形態コード（必須） */
    var employmentType: Int
    /** ２6．給与（必須）＊「想定給与」＊ */
    var salary: String
    /** ２７．賞与について（任意） */
    var bonusAbout: String
    /** 28．勤務時間（必須） */
    var jobtime: String
    /** 目安残業時間 */
    var overtimeCode: Int
    /** 残業について */
    var overtimeAbout: String
    /** 30．勤務地（必須） */
    var workPlace: String
    /** ３１．交通・詳細（必須） */
    var transport: String
    /** ＊３２．休日休暇（必須） */
    var holiday: String
    /** ＊３３．待遇・福利厚生（必須） */
    var welfare: String
    /** ３４．産休・育休取得状況（任意） */
    var childcare: String
    
    var interviewMemo: JobCardDetailInterviewMemo
    var selectionProcess: JobCardDetailSelectionProcess
    var contactInfo: JobCardDetailContactInfo
    var companyDescription: JobCardDetailCompanyDescription
    var userFilter: UserFilterInfo

    init(jobCardCode: String, jobName: String, salaryMinId:Int, salaryMaxId:Int,isSalaryDisplay:Bool, salaryOffer: String, workPlaceCodes: [Int], companyName: String, displayPeriod: JobCardDetailDisplayPeriod, mainPicture: String, subPictures: [String], mainTitle: String, mainContents: String, prCodes: [Int], salarySample: String, recruitmentReason: String, jobDescription: JobCardDetailJobDescription, jobExample: JobCardDetailJobExample, product: [JobCardDetailProduct], scope: [JobCardDetailScope], spotTitle1: String, spotDetail1: String, spotTitle2: String, spotDetail2: String, qualification: String, betterSkill: String, applicationExample: String, suitableUnsuitable: String, employmentType: Int, salary: String, bonusAbout: String, jobtime: String, overtimeCode: Int, overtimeAbout: String, workPlace: String, transport: String, holiday: String, welfare: String, childcare: String, interviewMemo: JobCardDetailInterviewMemo, selectionProcess: JobCardDetailSelectionProcess, contactInfo: JobCardDetailContactInfo, companyDescription: JobCardDetailCompanyDescription, userFilter: UserFilterInfo) {
        
        self.jobCardCode = jobCardCode
        self.jobName = jobName
        self.salaryMinId = salaryMinId
        self.salaryMaxId = salaryMaxId
        self.isSalaryDisplay = isSalaryDisplay
        self.salaryOffer = salaryOffer
        self.workPlaceCodes = workPlaceCodes
        self.companyName = companyName
        self.displayPeriod = displayPeriod
        self.mainPicture = mainPicture
        self.subPictures = subPictures
        self.mainTitle = mainTitle
        self.mainContents = mainContents
        self.prCodes = prCodes
        self.salarySample = salarySample
        self.recruitmentReason = recruitmentReason
        self.jobDescription = jobDescription
        self.jobExample = jobExample
        self.product = product
        self.scope = scope
        self.spotTitle1 = spotTitle1
        self.spotDetail1 = spotDetail1
        self.spotTitle2 = spotTitle2
        self.spotDetail2 = spotDetail2
        self.qualification = qualification
        self.betterSkill = betterSkill
        self.applicationExample = applicationExample
        self.suitableUnsuitable = suitableUnsuitable
        self.employmentType = employmentType
        self.salary = salary
        self.bonusAbout = bonusAbout
        self.jobtime = jobtime
        self.overtimeCode = overtimeCode
        self.overtimeAbout = overtimeAbout
        self.workPlace = workPlace
        self.transport = transport
        self.holiday = holiday
        self.welfare = welfare
        self.childcare = childcare
        self.interviewMemo = interviewMemo
        self.selectionProcess = selectionProcess
        self.contactInfo = contactInfo
        self.companyDescription = companyDescription
        self.userFilter = userFilter
    }
    
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: JobCardDetail) {
        
        let _jobDescription = dto.jobDescription!
        let _jobExample = dto.jobExample!
        let _product = dto.product
        
        let _spotTitle1 = dto.spotTitle1
        let _spotTitle2 = dto.spotTitle2
        let _spotDetail1 = dto.spotDetail1
        let _spotDetail2 = dto.spotDetail2
        
        let _scope = dto.scope
        
        let _bonusAbout = dto.bonusAbout
        let _childcare = dto.childcare
        let _interviewMemo = dto.interviewMemo
        
        let _suitableUnsuitable = dto.suitableUnsuitable
        let _companyDescription = dto.companyDescription
        
        self.init(jobCardCode: dto.jobCardCode, jobName: dto.jobName, salaryMinId: dto.salaryMinId, salaryMaxId: dto.salaryMaxId, isSalaryDisplay: dto.isSalaryDisplay!, salaryOffer: dto.salaryOffer,                  workPlaceCodes: dto.workPlaceCodes, companyName: dto.companyName, displayPeriod: dto.displayPeriod, mainPicture: dto.mainPicture, subPictures: dto.subPictures,                  mainTitle: dto.mainTitle, mainContents: dto.mainContents, prCodes: dto.prCodes, salarySample: dto.salarySample, recruitmentReason: dto.recruitmentReason, jobDescription: _jobDescription, jobExample: _jobExample, product: _product,                  scope: _scope, spotTitle1: _spotTitle1, spotDetail1: _spotDetail1, spotTitle2: _spotTitle2, spotDetail2: _spotDetail2,                  qualification: dto.qualification, betterSkill: dto.betterSkill, applicationExample: dto.applicationExample, suitableUnsuitable: _suitableUnsuitable,                  employmentType: dto.employmentType, salary: dto.salary, bonusAbout: _bonusAbout, jobtime: dto.jobtime, overtimeCode: dto.overtimeCode,                  overtimeAbout: dto.overtimeAbout, workPlace: dto.workPlace, transport: dto.transport, holiday: dto.holiday, welfare: dto.welfare,                  childcare: _childcare, interviewMemo: _interviewMemo, selectionProcess: dto.selectionProcess, contactInfo: dto.contactInfo,                  companyDescription: _companyDescription!, userFilter: dto.userFilter)
    }

    var debugDisp: String {
        return ""
    }
}
