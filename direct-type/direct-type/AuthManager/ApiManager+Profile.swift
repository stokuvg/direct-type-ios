//
//  ApiManager+Profile.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import TudApi

//================================================================
//=== プロフィール取得 ===
extension ApiManager {
    class func getProfile(_ param: Void, isRetry: Bool = true) -> Promise<MdlProfile> {
        if isRetry {
            return firstly { () -> Promise<MdlProfile> in
                retry(args: param, task: getProfileFetch) { (error) -> Bool in return true }
            }
        } else {
            return getProfileFetch(param: param)
        }
    }
    private class func getProfileFetch(param: Void) -> Promise<MdlProfile> {
        let (promise, resolver) = Promise<MdlProfile>.pending()
        AuthManager.needAuth(true)
        ProfileAPI.profileControllerGet()
        .done { result in
            resolver.fulfill(MdlProfile(dto: result)) //変換しておく
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
//=== プロフィール更新 ===
extension UpdateProfileRequestDTO {
    public init() {
        self.init(nickname: nil, hopeJobPlaceIds: nil, salaryId: nil, familyName: nil, firstName: nil, familyNameKana: nil, firstNameKana: nil, birthday: nil, genderId: nil, zipCode: nil, prefectureId: nil, city: nil, town: nil, email: nil)
    }
    init(_ editTempCD: [EditableItemKey: EditableItemCurVal]) {
        self.init()
        for (key, val) in editTempCD {
            switch key {
            case EditItemMdlProfile.familyName.itemKey: self.familyName = val
            case EditItemMdlProfile.firstName.itemKey: self.firstName = val
            case EditItemMdlProfile.familyNameKana.itemKey: self.familyNameKana = val
            case EditItemMdlProfile.firstNameKana.itemKey: self.firstNameKana = val
            case EditItemMdlProfile.birthday.itemKey: self.birthday = val
            case EditItemMdlProfile.gender.itemKey: self.genderId = val
            case EditItemMdlProfile.zipCode.itemKey: self.zipCode = val
            case EditItemMdlProfile.prefecture.itemKey: self.prefectureId = val
            case EditItemMdlProfile.address1.itemKey: self.city = val
            case EditItemMdlProfile.address2.itemKey: self.town = val
            case EditItemMdlProfile.mailAddress.itemKey: self.email = val
            default: break
            }
        }
    }
}
extension ApiManager {
    class func updateProfile(_ param: UpdateProfileRequestDTO, isRetry: Bool = true) -> Promise<Void> {
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: param, task: updateProfileFetch) { (error) -> Bool in return true }
            }
        } else {
            return updateProfileFetch(param: param)
        }
    }
    private class func updateProfileFetch(param: UpdateProfileRequestDTO) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        ProfileAPI.profileControllerUpdate(body: param)
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
//=== プロフィール作成 ===
extension CreateProfileRequestDTO {
    init() {
        self.init(nickname: "", hopeJobPlaceIds: [], salaryId: "", birthday: "", genderId: "")
    }
//    init(_ profile: MdlProfile) {
//        self.init()
//        self.nickname = profile.nickname
//        self.hopeJobPlaceIds = profile.hopeJobPlaceIds
//        self.birthday = profile.birthday.dispYmd()
//        self.genderId = profile.gender
//    }
    init(_ editTempCD: [EditableItemKey: EditableItemCurVal]) {
        self.init()
        if let tmp = editTempCD[EditItemMdlFirstInput.nickname.itemKey] {
            self.nickname = tmp
        }
        if let tmp = editTempCD[EditItemMdlFirstInput.birthday.itemKey] {
            self.birthday = tmp
        }
        if let tmp = editTempCD[EditItemMdlFirstInput.gender.itemKey] {
            self.genderId = tmp
        }
        var _hopeJobPlaceIds: [Code] = []
        if let tmp = editTempCD[EditItemMdlFirstInput.hopeArea.itemKey] {
            for code in tmp.split(separator: EditItemTool.SplitMultiCodeSeparator) {
                _hopeJobPlaceIds.append(String(code))
            }
        }
        self.hopeJobPlaceIds = _hopeJobPlaceIds
        if let tmp = editTempCD[EditItemMdlFirstInput.salary.itemKey] {
            self.salaryId = tmp
        }
        self.hopeJobPlaceIds = _hopeJobPlaceIds
    }
}


    
extension ApiManager {
    class func createProfile(_ param: CreateProfileRequestDTO, isRetry: Bool = true) -> Promise<Void> {
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: param, task: createProfileFetch) { (error) -> Bool in return true }
            }
        } else {
            return createProfileFetch(param: param)
        }
    }
    private class func createProfileFetch(param: CreateProfileRequestDTO) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        ProfileAPI.profileControllerCreate(body: param)
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
////================================================================
////================================================================
