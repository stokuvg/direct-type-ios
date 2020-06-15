//
//  ApiManager+Approach.swift
//  direct-type
//
//  Created by yamataku on 2020/06/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import Foundation

//================================================================
//=== アプローチ取得 ===
//extension ApiManager {
//    class func getProfile(_ param: Void, isRetry: Bool = true) -> Promise<MdlApproach> {
//        if isRetry {
//            return firstly { () -> Promise<MdlProfile> in
//                retry(args: param, task: getApproachFetch) { (error) -> Bool in return true }
//            }
//        } else {
//            return getProfileFetch(param: param)
//        }
//    }
//    private class func getApproachFetch(param: Void) -> Promise<MdlApproach> {
//        let (promise, resolver) = Promise<MdlApproach>.pending()
//        AuthManager.needAuth(true)
//        ApproachAPI.profileControllerGet()
//        .done { result in
//            resolver.fulfill(MdlProfile(dto: result)) //変換しておく
//        }
//        .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
//            resolver.reject(error)
//        }
//        .finally {
//        }
//        return promise
//    }
//}
//================================================================
//=== アプローチ更新 ===
//extension UpdateProfileRequestDTO {
//    public init() {
//        self.init(nickname: nil, hopeJobPlaceIds: nil, salaryId: nil, familyName: nil, firstName: nil, familyNameKana: nil, firstNameKana: nil, birthday: nil, genderId: nil, zipCode: nil, prefectureId: nil, city: nil, town: nil, email: nil)
//    }
//    init(_ editTempCD: [EditableItemKey: EditableItemCurVal]) {
//        self.init()
//        for (key, val) in editTempCD {
//            switch key {
//            case EditItemMdlProfile.familyName.itemKey: self.familyName = val
//            case EditItemMdlProfile.firstName.itemKey: self.firstName = val
//            case EditItemMdlProfile.familyNameKana.itemKey: self.familyNameKana = val
//            case EditItemMdlProfile.firstNameKana.itemKey: self.firstNameKana = val
//            case EditItemMdlProfile.birthday.itemKey: self.birthday = val
//            case EditItemMdlProfile.gender.itemKey: self.genderId = val
//            case EditItemMdlProfile.zipCode.itemKey: self.zipCode = val
//            case EditItemMdlProfile.prefecture.itemKey: self.prefectureId = val
//            case EditItemMdlProfile.address1.itemKey: self.city = val
//            case EditItemMdlProfile.address2.itemKey: self.town = val
//            case EditItemMdlProfile.mailAddress.itemKey: self.email = val
//            default: break
//            }
//        }
//    }
//}
//extension ApiManager {
//    class func updateProfile(_ param: UpdateProfileRequestDTO, isRetry: Bool = true) -> Promise<Void> {
//        if isRetry {
//            return firstly { () -> Promise<Void> in
//                retry(args: param, task: updateProfileFetch) { (error) -> Bool in return true }
//            }
//        } else {
//            return updateProfileFetch(param: param)
//        }
//    }
//    private class func updateProfileFetch(param: UpdateProfileRequestDTO) -> Promise<Void> {
//        let (promise, resolver) = Promise<Void>.pending()
//        AuthManager.needAuth(true)
//        ProfileAPI.profileControllerUpdate(body: param)
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
//================================================================
