//
//  ApiManager+Resume.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/05.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import TudApi

//================================================================
//=== 履歴書取得 ===
extension ApiManager {
    class func getResume(_ param: Void, isRetry: Bool = true) -> Promise<MdlResume> {
        if isRetry {
            return firstly { () -> Promise<MdlResume> in
                retry(args: param, task: getResumeFetch) { (error) -> Bool in return true }
            }
        } else {
            return getResumeFetch(param: param)
        }
    }
    private class func getResumeFetch(param: Void) -> Promise<MdlResume> {
        let (promise, resolver) = Promise<MdlResume>.pending()
        if Constants.DbgFetchDummyData { resolver.fulfill(MdlResume.dummyData()) }//!!![Dbg: 開発用ダミー返却]
        AuthManager.needAuth(true)
        ResumeAPI.resumeControllerGet()
        .done { result in
            print(#line, #function, param)
            resolver.fulfill(MdlResume(dto: result)) //変換しておく
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
//=== 履歴書更新 ===
extension UpdateResumeRequestDTO {
    private func convTypeAndYear(codes: String) -> ([WorkHistoryDTO]) {
        var workHistory: [WorkHistoryDTO] = []
        for job in codes.split(separator: EditItemTool.SplitMultiCodeSeparator) {
            let buf = String(job).split(separator: EditItemTool.SplitTypeYearSeparator)
            guard buf.count == 2 else { continue }
            workHistory.append(WorkHistoryDTO(job3Id: String(buf[0]), experienceYears: String(buf[1])))
        }
        return workHistory
    }

    init() {
        self.init(isEmployed: nil, changeJobCount: nil, workHistory: nil, experienceIndustryIds: nil, educationId: nil, finalEducation: nil, toeic: nil, toefl: nil, englishSkillId: nil, otherLanguageSkillId: nil, licenseIds: nil, selfPR: nil, currentSalary: nil)
    }

    init(_ resume: MdlResume, _ editTempCD: [EditableItemKey: EditableItemCurVal]) {
        self.init()
        if let tmp = editTempCD[EditItemMdlResume.employmentStatus.itemKey] {//就業状況
            self.isEmployed = (tmp == "1") ? true : false // 1: 就業中, 0: 就業していない
        }
        if let tmp = editTempCD[EditItemMdlResume.changeCount.itemKey] {//転職回数
            self.changeJobCount = Int(tmp)
        }
        var _workHistory: [WorkHistoryDTO] = []// 経験職種リスト
        if let tmp = editTempCD[EditItemMdlResumeLastJobExperiment.jobTypeAndJobExperimentYear.itemKey] {
            for item in convTypeAndYear(codes: tmp) {
                _workHistory.append(item)
            }
        } else {
            _workHistory.append(WorkHistoryDTO(job3Id: resume.lastJobExperiment.jobType, experienceYears: resume.lastJobExperiment.jobExperimentYear))
        }
        if let tmp = editTempCD[EditItemMdlResumeJobExperiments.jobTypeAndJobExperimentYear.itemKey] {
            for item in convTypeAndYear(codes: tmp) {
                _workHistory.append(item)
            }
        } else {
            for item in resume.jobExperiments {
                _workHistory.append(WorkHistoryDTO(job3Id: item.jobType, experienceYears: item.jobExperimentYear))
            }
        }
        if _workHistory.count > 0 {
            self.workHistory = _workHistory
        } else {
            self.workHistory = nil
        }
        if let tmp = editTempCD[EditItemMdlResume.businessTypes.itemKey] {
            var _experienceIndustryIds: [Code] = []
            for code in tmp.split(separator: EditItemTool.SplitMultiCodeSeparator) {
                _experienceIndustryIds.append(String(code))
            }
            self.experienceIndustryIds = _experienceIndustryIds// 経験業種ID
        }
        if let tmp = editTempCD[EditItemMdlResume.school.itemKey] {// 学種コード
            self.educationId = tmp
        }
        let _schoolName = editTempCD[EditItemMdlResumeSchool.schoolName.itemKey] ?? resume.school.schoolName
        let _faculty = editTempCD[EditItemMdlResumeSchool.faculty.itemKey] ?? resume.school.faculty
        let _department = editTempCD[EditItemMdlResumeSchool.department.itemKey] ?? resume.school.department
        let _guraduationYearMonth = editTempCD[EditItemMdlResumeSchool.graduationYear.itemKey] ?? resume.school.graduationYear
        let _finalEducation = FinalEducationDTO(schoolName: _schoolName, faculty: _faculty, department: _department, guraduationYearMonth: _guraduationYearMonth)
        self.finalEducation = _finalEducation
        if let tmp = editTempCD[EditItemMdlResumeSkillLanguage.languageToeicScore.itemKey] {//TOEICスコア
            self.toeic = Int(tmp)
        }
        if let tmp = editTempCD[EditItemMdlResumeSkillLanguage.languageToeflScore.itemKey] {//TOEFLスコア
            self.toefl = Int(tmp)
        }
        if let tmp = editTempCD[EditItemMdlResumeSkillLanguage.languageEnglish.itemKey] {//英語スキルID
            self.englishSkillId = tmp
        }
        if let tmp = editTempCD[EditItemMdlResumeSkillLanguage.languageStudySkill.itemKey] {//その他言語スキルID
            self.otherLanguageSkillId = tmp
        }
        var _licenseIds: [Code] = []
        if let tmp = editTempCD[EditItemMdlResume.qualifications.itemKey] {//保有資格IDリスト
            for code in tmp.split(separator: EditItemTool.SplitMultiCodeSeparator) {
                _licenseIds.append(String(code))
            }
            self.licenseIds = _licenseIds
        }
        if let tmp = editTempCD[EditItemMdlResume.ownPr.itemKey] {// 自己PR
            self.selfPR = tmp
        }
        if let tmp = editTempCD[EditItemMdlResume.currentSalary.itemKey] {// 現在の年収
            self.currentSalary = tmp
        }
    }
}


extension ApiManager {
    class func updateResume(_ param: UpdateResumeRequestDTO, isRetry: Bool = true) -> Promise<Void> {
        print(#line, #function, param)
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: param, task: updateResumeFetch) { (error) -> Bool in return true }
            }
        } else {
            return updateResumeFetch(param: param)
        }
    }
    private class func updateResumeFetch(param: UpdateResumeRequestDTO) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        ResumeAPI.resumeControllerUpdate(body: param)
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
//=== 履歴書作成 ===
extension CreateResumeRequestDTO {
    private func convTypeAndYear(codes: String) -> ([WorkHistoryDTO]) {
        var workHistory: [WorkHistoryDTO] = []
        for job in codes.split(separator: EditItemTool.SplitMultiCodeSeparator) {
            let buf = String(job).split(separator: EditItemTool.SplitTypeYearSeparator)
            guard buf.count == 2 else { continue }
            workHistory.append(WorkHistoryDTO(job3Id: String(buf[0]), experienceYears: String(buf[1])))
        }
        return workHistory
    }

    init() {
        self.init(isEmployed: false, workHistory: [], educationId: "", currentSalary: "")
    }
    init(_ editTempCD: [EditableItemKey: EditableItemCurVal]) {
        self.init()
        if let tmp = editTempCD[EditItemMdlFirstInput.employmentStatus.itemKey] {
            self.isEmployed = (tmp == "1") ? true : false // 1: 就業中, 0: 就業していない
        }
        var _workHistory: [WorkHistoryDTO] = []
        if let tmp = editTempCD[EditItemMdlFirstInputLastJobExperiments.jobTypeAndJobExperimentYear.itemKey] {
            for item in convTypeAndYear(codes: tmp) {
                _workHistory.append(item)
            }
        }
        if let tmp = editTempCD[EditItemMdlFirstInputJobExperiments.jobTypeAndJobExperimentYear.itemKey] {
            for item in convTypeAndYear(codes: tmp) {
                _workHistory.append(item)
            }
        }
        self.workHistory = _workHistory
        if let tmp = editTempCD[EditItemMdlFirstInput.school.itemKey] {
            self.educationId = tmp
        }
        if let tmp = editTempCD[EditItemMdlFirstInput.salary.itemKey] {
            self.currentSalary = tmp
        }
    }
}
extension ApiManager {
    class func createResume(_ param: CreateResumeRequestDTO, isRetry: Bool = true) -> Promise<Void> {
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: param, task: createResumeFetch) { (error) -> Bool in return true }
            }
        } else {
            return createResumeFetch(param: param)
        }
    }
    private class func createResumeFetch(param: CreateResumeRequestDTO) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        ResumeAPI.resumeControllerRegister(body: param)
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
////================================================================
