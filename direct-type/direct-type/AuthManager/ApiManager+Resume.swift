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
    init() {
        self.init(isEmployed: false, workHistory: [], educationId: "")
    }
    init(_ model: MdlResume, _ editTempCD: [EditableItemKey: EditableItemCurVal]) {
        self.init()
        self.init(isEmployed: true,
            workHistory: [],
            educationId: ""
        )

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
