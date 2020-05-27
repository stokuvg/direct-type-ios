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
        self.init(password: "Dummy123$", lastname: "", firstname: "", lastnameKana: "", firstnameKana: "", sex: "", email: "", emailMobile: "", birthday: "", zip: "", areaValue: "", address: "", tel: "", mobile: "", educationValue: "", educationName: "", educationDivision: "", graduationY: "", graduationM: "", educationNote: nil, workStatus: "", changeJobCount: "", userOldJob3List: [], userOldIndustryList: [], toeic: nil, toefl: nil, englishSkillValue: nil, otherLanguage: nil, license: nil, jobId: "", experienceCompanyList: [], userSkillList: nil, userLicenseList: nil, skillsheetFreeword: nil, entryEtc: nil, entryPlaceList: nil, salaryId: nil, changeTimeId: nil, entryContactList: nil, entryAnswer1: "", entryAnswer2: "", entryAnswer3: "")
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
