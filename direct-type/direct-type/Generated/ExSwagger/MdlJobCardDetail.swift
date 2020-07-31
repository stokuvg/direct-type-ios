//
//  MdlJobCardDetail.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/25.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient
import TudApi

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
    // 日付
    var start_date: String
    var end_date: String
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
    var jobDescription: String
    /** １７．案件例（任意） */
    var jobExample: String
    /** １８．手がける商品・サービス（任意） */
    var product: String
    /** １９．開発環境・業務範囲（任意） */
    var scope: String
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
    var notSuitableUnsuitable: String
    /** ２５．雇用形態コード（必須） */
    var employmentType: String
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
    
    var interviewMemo: String
    var selectionProcess: JobCardDetailSelectionProcess
    var contactInfo: JobCardDetailContactInfo
    var companyDescription: JobCardDetailCompanyDescription
    var userFilter: UserFilterInfo
    
    var entryQuestion1: String?
    var entryQuestion2: String?
    var entryQuestion3: String?


    init(jobCardCode: String = "", jobName: String = "", salaryMinId:Int = 0, salaryMaxId:Int = 0,isSalaryDisplay:Bool = true, salaryOffer: String = "", workPlaceCodes: [Int] = [], companyName: String = "",
         start_date:String = "", end_date:String = "", mainPicture: String = "", subPictures: [String] = [], mainTitle: String = "", mainContents: String = "",
         prCodes: [Int] = [], salarySample: String = "", recruitmentReason: String = "", jobDescription: String = "", jobExample: String = "", product: String = "", scope: String = "",
         spotTitle1: String = "", spotDetail1: String = "", spotTitle2: String = "", spotDetail2: String = "", qualification: String = "", betterSkill: String = "", applicationExample: String = "",
         suitableUnsuitable: String = "", notSuitableUnsuitable:String = "", employmentType: String = "", salary: String = "", bonusAbout: String = "", jobtime: String = "", overtimeCode: Int = 0, overtimeAbout: String = "", workPlace: String = "",
         transport: String = "", holiday: String = "", welfare: String = "", childcare: String = "",
         interviewMemo: String = "",
         selectionProcess: JobCardDetailSelectionProcess = JobCardDetailSelectionProcess.init(selectionProcess1: "", selectionProcess2: "", selectionProcess3: "", selectionProcess4: "", selectionProcess5: "", selectionProcessDetail: ""),
         contactInfo: JobCardDetailContactInfo = JobCardDetailContactInfo.init(companyUrl: "", contactZipcode: "", contactAddress: "", contactPhone: "", contactPerson: "", contactMail: ""),
         companyDescription: JobCardDetailCompanyDescription = JobCardDetailCompanyDescription.init(enterpriseContents: "", mainCustomer: "", mediaCoverage: "", established: "", employeesCount: JobCardDetailCompanyDescriptionEmployeesCount.init(count: "", averageAge: "", genderRatio: "", middleEnter: ""), capital: "", turnover: "", presidentData: JobCardDetailCompanyDescriptionPresidentData.init(presidentName: "", presidentHistory: "")),
         userFilter: UserFilterInfo = UserFilterInfo.init(tudKeepStatus: false, tudSkipStatus: false),
         entryQuestion1: String? = nil, entryQuestion2: String? = nil, entryQuestion3: String? = nil ) {
        
        self.jobCardCode = jobCardCode
        self.jobName = jobName
        self.salaryMinId = salaryMinId
        self.salaryMaxId = salaryMaxId
        self.isSalaryDisplay = isSalaryDisplay
        self.salaryOffer = salaryOffer
        self.workPlaceCodes = workPlaceCodes
        self.companyName = companyName
//        self.displayPeriod = displayPeriod
        self.start_date = start_date
        self.end_date = end_date
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
        self.notSuitableUnsuitable = notSuitableUnsuitable
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
        self.entryQuestion1 = entryQuestion1
        self.entryQuestion2 = entryQuestion2
        self.entryQuestion3 = entryQuestion3
    }
    
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: GetJobsDetailResponseDTO) {
        /*
         /** 求人ID */
         public var jobId: String
         /** 外部表示用職種名 */
         public var jobName: String
         /** 年収マスタ値 */
         public var minSalaryId: String
         /** 年収マスタ値 */
         public var maxSalaryId: String
         /** true: 年収公開, false: 年収非公開 */
         public var isSalaryDisplay: Bool
         /** スカウトによる提示年収＊初回は未使用＊ */
         public var salaryOffer: String
         /** ．勤務地 */
         public var place2Ids: [String]
         /** 企業名 */
         public var companyName: String
         /** 掲載開始日（ISO8601[YYYY-MM-DD]） */
         public var pressStartDate: String
         /** 掲載終了日（ISO8601[YYYY-MM-DD]） */
         public var pressEndDate: String
         /** メイン記事メインタイトル */
         public var mainTitle: String
         /** メイン記事本文 */
         public var mainBody: String
         /** ．勤務地 */
         public var jobPrIds: [String]
         /** 給与例 */
         public var salaryExample: String
         /** 募集背景 */
         public var background: String
         /** 仕事内容 */
         public var jobContents: String
         /** 案件例 */
         public var projectsDealing: String
         /** 手がける商品・サービス */
         public var commodity: String
         /** 開発環境・業務範囲 */
         public var scopeJob: String
         /** 注目ポイント見出し１ */
         public var attentionPointCaption1: String
         /** 注目ポイント本文１ */
         public var attentionPointBody1: String
         /** 注目ポイント見出し２ */
         public var attentionPointCaption2: String
         /** 注目ポイント本文２ */
         public var attentionPointBody2: String
         /** 応募資格 */
         public var applicationSkill: String
         /** 歓迎する経験・スキル */
         public var desirableCapability: String
         /** 過去の採用例 */
         public var adoptionExample: String
         /** この仕事の向き */
         public var suitableForThisJob: String
         /** この仕事の不向き */
         public var notSuitableForThisJob: String
         /** 雇用形態コード */
         public var employmentId: String
         /** 給与 */
         public var salary: String
         /** 賞与について */
         public var bonus: String
         /** 勤務時間 */
         public var officeHours: String
         /** 目安残業時間コード */
         public var indicationOvertimeId: String
         /** 残業について */
         public var overtime: String
         /** 勤務地 */
         public var jobPlace: String
         /** 交通・詳細 */
         public var transportation: String
         /** 休日休暇 */
         public var vacation: String
         /** 待遇・福利厚生 */
         public var jobCondition: String
         /** 産休・育休取得状況 */
         public var maternityChildcare: String
         /** 取材メモ */
         public var interviewBody: String
         /** 選考プロセス１ */
         public var selectionProcessStep1: String
         /** 選考プロセス２ */
         public var selectionProcessStep2: String
         /** 選考プロセス３ */
         public var selectionProcessStep3: String
         /** 選考プロセス４ */
         public var selectionProcessStep4: String
         /** 選考プロセス５ */
         public var selectionProcessStep5: String
         /** 選考プロセス詳細 */
         public var selectionProcess: String
         public var contact: Contact
         /** 事業内容 */
         public var enterpriseContents: String
         /** 主要取引先 */
         public var mainCustomer: String
         /** 事業・サービスのメディア掲載実績 */
         public var mediaCoverageResult: String
         /** 設立 */
         public var established: String
         public var employees: Employees
         /** 資本金 */
         public var capital: String
         /** 売上高 */
         public var turnover: String
         /** 代表者 */
         public var presidentName: String
         /** 代表者略歴 */
         public var presidentHistory: String
         /** true: キープしている, false: キープしていない */
         public var isKeep: Bool
         */
        
//        let _salaryOffer = dto.salaryOffer
        let _salaryOffer = ""
        Log.selectLog(logLevel: .debug, "_salaryOffer:\(String(describing: _salaryOffer))")
        
        let _jobDescription = dto.jobContents
        let _jobExample = dto.projectsDealing
        let _product = dto.commodity
        
        let _spotTitle1 = dto.attentionPointCaption1
        let _spotTitle2 = dto.attentionPointCaption2
        let _spotDetail1 = dto.attentionPointBody1
        let _spotDetail2 = dto.attentionPointBody2
        
        let _scope = dto.scopeJob
        
        let _bonusAbout = dto.bonus
        let _childcare = dto.maternityChildcare
        let _interviewMemo = dto.interviewBody
        
        let _suitableUnsuitable = dto.suitableForThisJob
        let _notSuitableUnsuitable = dto.notSuitableForThisJob
        
//        let _companyDescription = dto.companyDescription
        
        let _emplyees = JobCardDetailCompanyDescriptionEmployeesCount.init(count: dto.employees.employeesAll, averageAge: dto.employees.averageAge, genderRatio: dto.employees.genderRatio, middleEnter: dto.employees.middleEnter)
        let _presidentData = JobCardDetailCompanyDescriptionPresidentData.init(presidentName: dto.presidentName, presidentHistory: dto.presidentHistory)
        
        let _companyDescription = JobCardDetailCompanyDescription.init(
            enterpriseContents: dto.enterpriseContents,
            mainCustomer: dto.mainCustomer,
            mediaCoverage: dto.mediaCoverageResult,
            established: dto.established,
            employeesCount: _emplyees,
            capital: dto.capital,
            turnover: dto.turnover,
            presidentData: _presidentData)
        
        var _place2Ids:[Int] = []
        for i in 0..<dto.place2Ids.count {
            let place2Id = Int(dto.place2Ids[i])
            _place2Ids.append(place2Id!)
        }
        
        var _prIds:[Int] = []
        for i in 0..<dto.jobPrIds.count {
            guard let prId = Int(dto.jobPrIds[i]) else { continue }
            _prIds.append(prId)
        }
        
        let _mainPicture = dto.mainPhotoURL 
        let _subPictures:[String] = dto.subPhotoURLs 
        
        let _employmendIds = dto.employmentId
//        let _employmentId = Int(dto.employmentId) ?? 0
        let _overtimeCode = Int(dto.indicationOvertimeId)
        
        let _selectionProcess = JobCardDetailSelectionProcess.init(selectionProcess1: dto.selectionProcessStep1, selectionProcess2: dto.selectionProcessStep2, selectionProcess3: dto.selectionProcessStep3, selectionProcess4: dto.selectionProcessStep4, selectionProcess5: dto.selectionProcessStep5, selectionProcessDetail: dto.selectionProcess)
        
        let _contactInfo = JobCardDetailContactInfo.init(companyUrl: dto.contact.homepageUrl, contactZipcode: dto.contact.zip, contactAddress: dto.contact.address, contactPhone: dto.contact.tel, contactPerson: dto.contact.person, contactMail: dto.contact.email)
        
        let _userFileter = UserFilterInfo.init(tudKeepStatus: dto.isKeep, tudSkipStatus: false)
        
        let _entryQuestion1 = dto.entryQuestion1
        let _entryQuestion2 = dto.entryQuestion2
        let _entryQuestion3 = dto.entryQuestion3

        self.init(
            jobCardCode: dto.jobId,
            jobName: dto.jobName,
            salaryMinId: Int(dto.minSalaryId)!, salaryMaxId: Int(dto.maxSalaryId)!, isSalaryDisplay: dto.isSalaryDisplay,
            salaryOffer: _salaryOffer,
            workPlaceCodes: _place2Ids,
            companyName: dto.companyName,
            start_date: dto.pressStartDate, end_date: dto.pressEndDate,
            mainPicture: _mainPicture, subPictures: _subPictures,
            mainTitle: dto.mainTitle, mainContents: dto.mainBody,
            prCodes: _prIds, salarySample: dto.salaryExample,
            recruitmentReason: dto.background, jobDescription: _jobDescription,
            jobExample: _jobExample, product: _product, scope: _scope, spotTitle1: _spotTitle1, spotDetail1: _spotDetail1, spotTitle2: _spotTitle2, spotDetail2: _spotDetail2,
            qualification: dto.applicationSkill, betterSkill: dto.desirableCapability, applicationExample: dto.adoptionExample,
            suitableUnsuitable: _suitableUnsuitable, notSuitableUnsuitable: _notSuitableUnsuitable,
            employmentType: _employmendIds, salary: dto.salary, bonusAbout: _bonusAbout, jobtime: dto.officeHours,
            overtimeCode: _overtimeCode!, overtimeAbout: dto.overtime, workPlace: dto.jobPlace,
            transport: dto.transportation, holiday: dto.vacation, welfare: dto.jobCondition,
            childcare: _childcare, interviewMemo: _interviewMemo, selectionProcess: _selectionProcess,
            contactInfo: _contactInfo, companyDescription: _companyDescription, userFilter: _userFileter,
            entryQuestion1: _entryQuestion1, entryQuestion2: _entryQuestion2, entryQuestion3: _entryQuestion3 )
    }

    var debugDisp: String {
        return ""
    }
}
