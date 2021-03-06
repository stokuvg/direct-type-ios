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
enum ProfileApiError: Int {
    case invalidation = 400
    case notAuthorized = 401
    case notFount = 404
    case oldAuthCode = 410
    case internalError = 500
}
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
        if Constants.DbgFetchDummyData { resolver.fulfill(MdlProfile.dummyData()) }//!!![Dbg: 開発用ダミー返却]
        AuthManager.needAuth(true)
//        TudApiAPI.basePath = AppDefine.tudApiServer
        ProfileAPI.profileControllerGet()
        .done { result in
            ApiManager.shared.dicLastUpdate[.profile] = Date()//取得できたので、最終取得日時を更新
            let profile = MdlProfile(dto: result)
            if profile.hopeJobPlaceIds.count == 0 { //フェッチ取得して「希望勤務地」が「空」の場合には、アプリ内では「勤務地にはこだわらない」が選ばれているものとして扱わせる
                profile.hopeJobPlaceIds.append(Constants.ExclusiveSelectCodeDisp.code)
            }
             resolver.fulfill(profile) //変換しておく
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
        self.init(nickname: nil, hopeJobPlaceIds: nil, familyName: nil, firstName: nil, familyNameKana: nil, firstNameKana: nil, birthday: nil, genderId: nil, zipCode: nil, prefectureId: nil, city: nil, town: nil, email: nil)
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
            case EditItemMdlProfile.hopeJobArea.itemKey:
                var _hopeJobPlaceIds: [Code] = []
                for code in val.split(separator: EditItemTool.SplitMultiCodeSeparator) {
                    if code == Constants.ExclusiveSelectCodeDisp.code {
                        // アプリ独自の特別なコードなので、サーバへは登録しない
                    } else {
                        _hopeJobPlaceIds.append(String(code))
                    }
                }
                self.hopeJobPlaceIds = _hopeJobPlaceIds
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
//        TudApiAPI.basePath = AppDefine.tudApiServer
        ProfileAPI.profileControllerUpdate(body: param)
        .done { result in
            ApiManager.shared.dicLastUpdate[.profile] = Date(timeIntervalSince1970: 0)//モデル更新したので、一覧再取得が必要
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
        self.init(nickname: "", hopeJobPlaceIds: [], birthday: "", genderId: "")
    }
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
                if code == Constants.ExclusiveSelectCodeDisp.code {
                    // アプリ独自の特別なコードなので、サーバへは登録しない
                } else {
                    _hopeJobPlaceIds.append(String(code))
                }
            }
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
//        TudApiAPI.basePath = AppDefine.tudApiServer
        ProfileAPI.profileControllerCreate(body: param)
        .done { result in
            ApiManager.shared.dicLastUpdate[.profile] = Date(timeIntervalSince1970: 0)//モデル更新したので、一覧再取得が必要
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
