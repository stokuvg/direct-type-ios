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
        AuthManager.needAuth(true)
        ResumeAPI.resumeControllerGet()
        .done { result in
            print(result)
            let hoge = MdlResume(dto: result)
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
    init() {
        self.init(isEmployed: nil, changeJobCount: nil, workHistory: nil, experienceIndustryId: nil, educationId: nil, finalEducation: nil, toeic: nil, toefl: nil, englishSkillId: nil, otherLanguageSkillId: nil, licenseIds: nil)
    }
    init(_ editTempCD: [EditableItemKey: EditableItemCurVal]) {
        self.init()
        var _workHistory: [WorkHistoryDTO] = []
        for (key, val) in editTempCD {
            print("\t💙💙[\(key): \(val)]💙💙")
            switch key {
            case EditItemMdlResume.employmentStatus.itemKey: self.isEmployed = (val == "1") ? true : false //"1": true, "2":false
            case EditItemMdlResume.changeCount.itemKey: self.changeJobCount = Int(val) ?? 0
            //* 経験職種リスト
            case EditItemMdlResume.lastJobExperiment.itemKey:
                _workHistory.insert(WorkHistoryDTO(job3Id: "1", experienceYears: "3"), at: 0)
            //case EditItemMdlResume.jobExperiments.itemKey: self.hoge = val
//            case EditItemMdlResume.jobExperiments.itemKey: self.experienceIndustryId = val//経験業種ID

            //public var : FinalEducationDTO
//            case EditItemMdlResumeSchool.schoolName.itemKey: self.finalEducation.schoolName = val
//            case EditItemMdlResumeSchool.department.itemKey: self.finalEducation.department = val
//            case EditItemMdlResumeSchool.subject.itemKey: self.finalEducation.faculty = val
//            case EditItemMdlResumeSchool.graduationYear.itemKey: self.finalEducation.guraduationYearMonth = val
            case EditItemMdlResumeSkillLanguage.languageToeicScore.itemKey: self.toeic = Int(val) ?? 0
            case EditItemMdlResumeSkillLanguage.languageToeflScore.itemKey: self.toefl = Int(val) ?? 0
            case EditItemMdlResumeSkillLanguage.languageEnglish.itemKey: self.englishSkillId = val
            case EditItemMdlResumeSkillLanguage.languageStudySkill.itemKey: self.otherLanguageSkillId = val
//            case EditItemMdlResume.employmentStatus.itemKey: self.licenseIds = val.split(separator: "_") as? [String] ?? []

            default: break
            }
        }
        //===直接補填
        self.workHistory = _workHistory
        let finalEducation = FinalEducationDTO(schoolName: "ダミー学校名です", faculty: "医学部", department: "医学科", guraduationYearMonth: "2000-01")
        self.finalEducation = finalEducation
//        self.workHistory.append(WorkHistoryDTO(job3Id: "1", experienceYears: "3"))
    }
}
extension ApiManager {
    class func updateResume(_ param: UpdateResumeRequestDTO, isRetry: Bool = true) -> Promise<Void> {
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
        self.init(isEmployed: false, workHistory: [], educationId: "")
    }
    init(_ editTempCD: [EditableItemKey: EditableItemCurVal]) {
        self.init()
        if let tmp = editTempCD[EditItemMdlFirstInput.employmentStatus.itemKey] {
            self.isEmployed = (tmp == "1") ? true : false //"1": true, "2":false
        }
        var _workHistory: [WorkHistoryDTO] = []
        if let tmp = editTempCD[EditItemMdlFirstInputLastJobExperiments.jobTypeAndJobExperimentYear.itemKey] {
            let ty = EditItemTool.convTypeAndYear(codes: tmp)
            if ty.0.count > 0 && ty.1.count > 0 {
                _workHistory.append(WorkHistoryDTO(job3Id: ty.0.first!, experienceYears: ty.1.first!))
            }
        }
        if let tmp = editTempCD[EditItemMdlFirstInputJobExperiments.jobTypeAndJobExperimentYear.itemKey] {
            let wh = convTypeAndYear(codes: tmp)
            print("[JobExperiment: \(tmp)]", wh.description)
            for item in convTypeAndYear(codes: tmp) {
                _workHistory.append(item)
            }
        }
        self.workHistory = _workHistory
        if let tmp = editTempCD[EditItemMdlFirstInput.school.itemKey] {
            self.educationId = tmp
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
