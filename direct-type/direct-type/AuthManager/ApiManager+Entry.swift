//
//  ApiManager+Entry.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import TudApi

//================================================================
//=== 応募 ===
extension WebAPIEntryUserDto {
    init() {
        self.init(password: "", lastname: "", firstname: "", lastnameKana: "", firstnameKana: "", sex: "", email: "", emailMobile: "", birthday: "", zip: "", areaValue: "", address: "", tel: "", mobile: "", educationValue: "", educationName: "", educationDivision: "", graduationY: "", graduationM: "", educationNote: nil, workStatus: "", changeJobCount: "", userOldJob3List: [], userOldIndustryList: [], toeic: nil, toefl: nil, englishSkillValue: nil, otherLanguage: nil, license: nil, jobId: "", experienceCompanyList: [], userSkillList: nil, userLicenseList: nil, skillsheetFreeword: nil, entryEtc: nil, entryPlaceList: nil, salaryId: nil, changeTimeId: nil, entryContactList: nil, entryAnswer1: "", entryAnswer2: "", entryAnswer3: "")
    }
    init(_ jobCardCode: String, _ profile: MdlProfile, _ resume: MdlResume, _ career: MdlCareer, _ editTempCD: [EditableItemKey: EditableItemCurVal], _ typePassword: String) {
        self.init()
        
        self.password = typePassword //入力させたもの
        
        self.lastname = profile.familyName
        self.firstname = profile.firstName
        self.lastnameKana = profile.familyNameKana
        self.firstnameKana = profile.firstNameKana
        self.sex = profile.gender
        self.email = profile.mailAddress
//        self.emailMobile = XXX
        self.birthday = profile.birthday.dispYmd()
        print(String(repeating: "=", count: 22))
        print(self.birthday)
        print(String(repeating: "=", count: 22))
        
        
        if profile.zipCode.count == 7 {
            let zip3: String = String.substr(profile.zipCode, 1, 3)
            let zip4: String = String.substr(profile.zipCode, 4, 4)
            self.zip = "\(zip3)-\(zip4)"
        }
        self.areaValue = profile.prefecture
        self.address = "\(profile.address1)\(profile.address2)"
//        self.tel = XXX
        self.mobile = profile.mobilePhoneNo
        self.educationValue = resume.educationId //これはFirstInputで入力
        self.educationName = resume.school.schoolName
        self.educationDivision = "\(resume.school.faculty)\(resume.school.department)"
        let graduationYM: Date = DateHelper.convStrYM2Date(resume.school.graduationYear)
        self.graduationY = graduationYM.dispYear()
        self.graduationM = graduationYM.dispMonth() //0埋め不要
//        self.educationNote = XXX
        self.workStatus = resume.employmentStatus
        self.changeJobCount = resume.changeCount
        /** 経験職種(userOldJob3)を参照 */
        var _userOldJob3List: [UserOldJob3] = []
        _userOldJob3List.append(UserOldJob3(job3Id: resume.lastJobExperiment.jobType, experienceYears: resume.lastJobExperiment.jobExperimentYear))
        for item in resume.jobExperiments {
            _userOldJob3List.append(UserOldJob3(job3Id: item.jobType, experienceYears: item.jobExperimentYear))
        }
        self.userOldJob3List = _userOldJob3List
        /** 経験業種(userOldIndustry)を参照 */
        var _userOldIndustryList: [UserOldIndustry] = []
        for item in resume.businessTypes {
            _userOldIndustryList.append(UserOldIndustry(industryId: item))
        }
        self.userOldIndustryList = _userOldIndustryList
        self.toeic = resume.skillLanguage.languageToeicScore
        self.toefl = resume.skillLanguage.languageToeflScore
        self.englishSkillValue = resume.skillLanguage.languageEnglish
        self.otherLanguage = resume.skillLanguage.languageStudySkill
//        public var license: String?
//        self.license = "tmp"
        self.jobId = jobCardCode
        /** 職務経歴書(experienceCompany)を参照 */
        var _experienceCompanyList: [ExperienceCompany] = []
        for item in career.businessTypes {
            let expCompany = ExperienceCompany(company: item.companyName, startworkY: item.workPeriod.startDate.dispYear(), startworkM: item.workPeriod.startDate.dispMonth(), endworkY: item.workPeriod.endDate.dispYear(), endworkM: item.workPeriod.endDate.dispMonth(), employees: item.employeesCount, employmentId: item.employmentType, salary: item.salary, workNote: item.contents)
            _experienceCompanyList.append(expCompany)
        }
        self.experienceCompanyList = _experienceCompanyList
//        /** スキルシート(userSkill)を参照 */
//        var _userSkillList: [UserSkill] = []
//        self.userSkillList = _userSkillList
//        /** ライセンス(userLicense)を参照 */
//        var _userLicenseList: [UserLicense] = []
//        self.userLicenseList = _userLicenseList
//        self.skillsheetFreeword = XXX
        if let tmp = editTempCD[EditItemMdlEntry.ownPR.itemKey] {
            self.entryEtc = tmp
        }
        var _entryPlaceList: [EntryPlace] = []
        if let tmp = editTempCD[EditItemMdlEntry.hopeArea.itemKey] {
            for code in tmp.split(separator: EditItemTool.SplitMultiCodeSeparator) {
                _entryPlaceList.append(EntryPlace(placeId: String(code)))
            }
        }        
        self.entryPlaceList = _entryPlaceList
        if let tmp = editTempCD[EditItemMdlEntry.hopeSalary.itemKey] {
            self.salaryId = tmp
        }
//        /** 転職時期マスタより選択。 */
//        public var changeTimeId: String?
//        self.changeTimeId = XXX
//        /** 希望連絡先(entryContact)を参照 */
//        public var entryContactList: [EntryContact]?
//        self.entryContactList = XXX
        if let tmp = editTempCD[EditItemMdlEntry.exQuestionAnswer1.itemKey] {
            self.entryAnswer1 = tmp
        }
        if let tmp = editTempCD[EditItemMdlEntry.exQuestionAnswer2.itemKey] {
            self.entryAnswer2 = tmp
        }
        if let tmp = editTempCD[EditItemMdlEntry.exQuestionAnswer3.itemKey] {
            self.entryAnswer3 = tmp
        }
    }
}
extension ApiManager {
    class func postEntry(_ param: WebAPIEntryUserDto, isRetry: Bool = true) -> Promise<Void> {
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: param, task: postEntryFetch) { (error) -> Bool in return true }
            }
        } else {
            return postEntryFetch(param: param)
        }
    }
    private class func postEntryFetch(param: WebAPIEntryUserDto) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        EntryAPI.entryControllerEntry(body: param)
        .done { result in
            resolver.fulfill(Void())
        }
        .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
            resolver.reject(error)
        }
        .finally {
        }
        return promise
    }
}

//================================================================
//================================================================
//================================================================
