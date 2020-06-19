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
////================================================================
////=== 履歴書更新 ===
//extension UpdateResumeRequestDTO {
//    init() {
//        self.init(isEmployed: nil, changeJobCount: nil, workHistory: nil, experienceIndustryId: nil, finalEducation: nil, toeic: nil, toefl: nil, englishSkillId: nil, otherLanguageSkillId: nil, licenseIds: nil)
//    }
//    init(_ editTempCD: [EditableItemKey: EditableItemCurVal]) {
//        self.init()
//        for (key, val) in editTempCD {
//            switch key {
//            case EditItemMdlResume.employmentStatus.itemKey:
//                print("\t💙💙[\(key): \(val)]💙💙")
//            default: break
//            }
//        }
//    }
//}
//extension ApiManager {
//    class func updateResume(_ param: UpdateResumeRequestDTO, isRetry: Bool = true) -> Promise<Void> {
//        if isRetry {
//            return firstly { () -> Promise<Void> in
//                retry(args: param, task: updateResumeFetch) { (error) -> Bool in return true }
//            }
//        } else {
//            return updateResumeFetch(param: param)
//        }
//    }
//    private class func updateResumeFetch(param: UpdateResumeRequestDTO) -> Promise<Void> {
//        let (promise, resolver) = Promise<Void>.pending()
//        AuthManager.needAuth(true)
//        ResumeAPI.resumeControllerUpdate(body: param)
//        .done { result in
//            resolver.fulfill(Void())
//        }
//        .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
//            resolver.reject(error)
//        }
//        .finally {
//        }
//        return promise
//    }
//}
//////================================================================
//================================================================
//=== 履歴書作成 ===
extension CreateResumeRequestDTO {
    init() {
        self.init(isEmployed: false, changeJobCount: 0, workHistory: []
            , experienceIndustryId: "", finalEducation: FinalEducationDTO(schoolName: "", faculty: "", department: "", guraduationYearMonth: ""), toeic: 0, toefl: 0, englishSkillId: "", otherLanguageSkillId: "", licenseIds: [])
    }
    init(_ model: MdlResume, _ editTempCD: [EditableItemKey: EditableItemCurVal]) {
        self.init()
        self.init(isEmployed: true,
            changeJobCount: Int(model.changeCount) ?? 0,
            workHistory: [],
            experienceIndustryId: model.businessTypes.first ?? "",
            finalEducation: FinalEducationDTO(
                schoolName: model.school.schoolName,
                faculty: model.school.department,
                department: model.school.department,
                guraduationYearMonth: model.school.graduationYear ),
            toeic: Int(model.skillLanguage.languageToeicScore) ?? 0,
            toefl: Int(model.skillLanguage.languageToeflScore) ?? 0,
            englishSkillId: model.skillLanguage.languageEnglish,
            otherLanguageSkillId: model.skillLanguage.languageStudySkill,
            licenseIds: []
        )
0
        for (key, val) in editTempCD {
            print("\t💙💙[\(key): \(val)]💙💙")
            switch key {
            case EditItemMdlResume.employmentStatus.itemKey:
                print("\t💙💙[\(key): \(val)]💙💙")
            default: break
            }
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
