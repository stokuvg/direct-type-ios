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
    init() {
        self.init(familyName: nil, firstName: nil, familyNameKana: nil, firstNameKana: nil, birthday: nil, genderId: nil, zipCode: nil, prefectureId: nil, city: nil, town: nil, email: nil)
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
        self.init(familyName: "", firstName: "", familyNameKana: "", firstNameKana: "", birthday: "", genderId: "", zipCode: "", prefectureId: "", city: "", town: "", email: "")
    }
    init(_ profile: MdlProfile) {
        self.init()
        self.familyName = profile.familyName
        self.firstName = profile.firstName
        self.familyNameKana = profile.familyNameKana
        self.firstNameKana = profile.firstNameKana
        self.birthday = profile.birthday.dispYmd()
        self.genderId = profile.gender
        self.zipCode = profile.zipCode
        self.prefectureId = profile.prefecture
        self.city = profile.address1
        self.town = profile.address2
        self.email = profile.mailAddress
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
