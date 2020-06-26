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
    init(_ editTempCD: [EditableItemKey: EditableItemCurVal]) {
        self.init()
        
        if let tmp = editTempCD[EditItemMdlProfile.familyName.itemKey] {
            self.lastname = tmp
        }
        if let tmp = editTempCD[EditItemMdlProfile.firstName.itemKey] {
            self.firstname = tmp
        }
        if let tmp = editTempCD[EditItemMdlProfile.familyNameKana.itemKey] {
            self.lastnameKana = tmp
        }
        if let tmp = editTempCD[EditItemMdlProfile.firstNameKana.itemKey] {
            self.firstnameKana = tmp
        }
        if let tmp = editTempCD[EditItemMdlProfile.gender.itemKey] {
            self.sex = tmp
        }
        if let tmp = editTempCD[EditItemMdlProfile.mailAddress.itemKey] {
            self.email = tmp
        }
//        if let tmp = editTempCD[EditItemMdlProfile.XXX.itemKey] {
//            self.emailMobile = tmp
//        }
        if let tmp = editTempCD[EditItemMdlProfile.birthday.itemKey] {
            self.birthday = tmp
        }
        if let tmp = editTempCD[EditItemMdlProfile.zipCode.itemKey] {
            self.zip = tmp
        }
        if let tmp = editTempCD[EditItemMdlProfile.prefecture.itemKey] {
            self.areaValue = tmp
        }
        let _address1: String = editTempCD[EditItemMdlProfile.address1.itemKey] ?? ""
        let _address2: String = editTempCD[EditItemMdlProfile.address2.itemKey] ?? ""
        let _address: String = "\(_address1)\(_address2)"
        self.address = _address
//        if let tmp = editTempCD[EditItemMdlProfile.XXX.itemKey] {
//            self.tel = tmp
//        }
        if let tmp = editTempCD[EditItemMdlProfile.mobilePhoneNo.itemKey] {
            self.mobile = tmp
        }
        if let tmp = editTempCD[EditItemMdlFirstInput.school.itemKey] {//!!!
            self.educationValue = tmp //これはProfileモデルより（FirstInputで入力
        }
        if let tmp = editTempCD[EditItemMdlResumeSchool.schoolName.itemKey] {
            self.educationName = tmp
        }
        if let tmp = editTempCD[EditItemMdlResumeSchool.faculty.itemKey] {
            let tmp2 = editTempCD[EditItemMdlResumeSchool.department.itemKey] ?? ""
            self.educationDivision = "\(tmp)\(tmp2)っっx"
        }
        if let tmp = editTempCD[EditItemMdlResumeSchool.graduationYear.itemKey] {
            let tmpY = "2000"//!!!
            let tmpM = "04"
            self.graduationY = tmpY
            self.graduationM = tmpM //0埋め不要
        }
//        if let tmp = editTempCD[EditItemMdlProfile.XXX.itemKey] {
//            self.educationNote = tmp
//        }
        if let tmp = editTempCD[EditItemMdlResume.employmentStatus.itemKey] {
            self.workStatus = tmp
        }
        if let tmp = editTempCD[EditItemMdlResume.changeCount.itemKey] {
            self.changeJobCount = tmp
        }
//        public var userOldJob3List: [UserOldJob3]

//        if let tmp = editTempCD[EditItemMdlResume.userOldJob3List[].itemKey] {
//            self.userOldJob3List = tmp
//        }
//        if let tmp = editTempCD[EditItemMdlProfile.userOldIndustryList[].itemKey] {
//            self.userOldIndustryList = tmp
//        }
//        if let tmp = editTempCD[EditItemMdlResume.toeic.itemKey] {
//            self.toeic = tmp
//        }
//        if let tmp = editTempCD[EditItemMdlProfile.toefl.itemKey] {
//            self.toefl = tmp
//        }
//        if let tmp = editTempCD[EditItemMdlProfile.englishSkillValue.itemKey] {
//            self.englishSkillValue = tmp
//        }
//        if let tmp = editTempCD[EditItemMdlProfile.otherLanguage.itemKey] {
//            self.otherLanguage = tmp
//        }
//        if let tmp = editTempCD[EditItemMdlProfile.license.itemKey] {
//            self.license = tmp
//            if let tmp = editTempCD[EditItemMdlProfile.jobId.itemKey] {
//                self.jobId = tmp
//            }
//            if let tmp = editTempCD[EditItemMdlProfile.experienceCompanyList[].itemKey] {
//                self.experienceCompanyList = tmp
//            }
//            if let tmp = editTempCD[EditItemMdlProfile.userSkillList[].itemKey] {
//                self.userSkillList = tmp
//            }
//            if let tmp = editTempCD[EditItemMdlProfile.userLicenseList[].itemKey] {
//                self.userLicenseList = tmp
//            }
//            if let tmp = editTempCD[EditItemMdlProfile.skillsheetFreeword.itemKey] {
//                self.skillsheetFreeword = tmp
//            }
//            if let tmp = editTempCD[EditItemMdlProfile.entryEtc.itemKey] {
//                self.entryEtc = tmp
//            }
//            if let tmp = editTempCD[EditItemMdlProfile.entryPlaceList.itemKey] {
//                self.entryPlaceList = tmp
//            }
//            if let tmp = editTempCD[EditItemMdlProfile.salaryId.itemKey] {
//                self.salaryId = tmp
//            }
//            if let tmp = editTempCD[EditItemMdlProfile.changeTimeId.itemKey] {
//                self.changeTimeId = tmp
//            }
//            if let tmp = editTempCD[EditItemMdlProfile.entryContactList.itemKey] {
//                self.entryContactList = tmp
//            }
//            if let tmp = editTempCD[EditItemMdlProfile.entryAnswer1.itemKey] {
//                self.entryAnswer1 = tmp
//            }
//            if let tmp = editTempCD[EditItemMdlProfile.entryAnswer2.itemKey] {
//                self.entryAnswer2 = tmp
//            }
//            if let tmp = editTempCD[EditItemMdlProfile.entryAnswer3.itemKey] {
//                self.entryAnswer3 = tmp
//            }
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
