//
//  ApiManager+Career.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/05.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import TudApi

//================================================================
//=== Api12_職務経歴書の取得 ===
extension ApiManager {
    class func getCareer(_ param: Void, isRetry: Bool = true) -> Promise<MdlCareer> {
        if isRetry {
            return firstly { () -> Promise<MdlCareer> in
                retry(args: param, task: getCareerFetch) { (error) -> Bool in return true }
            }
        } else {
            return getCareerFetch(param: param)
        }
    }
    private class func getCareerFetch(param: Void) -> Promise<MdlCareer> {
        let (promise, resolver) = Promise<MdlCareer>.pending()
        AuthManager.needAuth(true)
        CareerAPI.careerControllerGet()
        .done { result in
            print(#line, #function, result)
            resolver.fulfill(MdlCareer(dto: result)) //変換しておく
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
//extension CareerHistoryDTO {
//    init() {
//        self.init()
//
//        }
//    }
//    init(_ editTempCD: [EditableItemKey: EditableItemCurVal]) {
//        self.init()
//        for (key, val) in editTempCD {
//            switch key {
//            case EditItemMdlCareer.familyName.itemKey: self.familyName = val
//            case EditItemMdlCareer.firstName.itemKey: self.firstName = val
//            case EditItemMdlCareer.familyNameKana.itemKey: self.familyNameKana = val
//            case EditItemMdlCareer.firstNameKana.itemKey: self.firstNameKana = val
//            case EditItemMdlCareer.birthday.itemKey: self.birthday = val
//            case EditItemMdlCareer.gender.itemKey: self.genderId = val
//            case EditItemMdlCareer.zipCode.itemKey: self.zipCode = val
//            case EditItemMdlCareer.prefecture.itemKey: self.prefectureId = val
//            case EditItemMdlCareer.address1.itemKey: self.city = val
//            case EditItemMdlCareer.address2.itemKey: self.town = val
//            case EditItemMdlCareer.mailAddress.itemKey: self.email = val
//            default: break
//            }
//        }
//    }
//}
//extension ApiManager {
//    class func updateCareer(_ param: UpdateCareerRequestDTO, isRetry: Bool = true) -> Promise<Void> {
//        if isRetry {
//            return firstly { () -> Promise<Void> in
//                retry(args: param, task: updateCareerFetch) { (error) -> Bool in return true }
//            }
//        } else {
//            return updateCareerFetch(param: param)
//        }
//    }
//    private class func updateCareerFetch(param: UpdateCareerRequestDTO) -> Promise<Void> {
//        let (promise, resolver) = Promise<Void>.pending()
//        AuthManager.needAuth(true)
//        CareerAPI.CareerControllerUpdate(body: param)
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
////================================================================
////=== プロフィール作成 ===
//extension CreateCareerRequestDTO {
//    init() {
//        self.init(familyName: "", firstName: "", familyNameKana: "", firstNameKana: "", birthday: "", genderId: "", zipCode: "", prefectureId: "", city: "", town: "", email: "")
//    }
//    init(_ Career: MdlCareer) {
//        self.init()
//        self.familyName = Career.familyName
//        self.firstName = Career.firstName
//        self.familyNameKana = Career.familyNameKana
//        self.firstNameKana = Career.firstNameKana
//        self.birthday = Career.birthday.dispYmd()
//        self.genderId = Career.gender
//        self.zipCode = Career.zipCode
//        self.prefectureId = Career.prefecture
//        self.city = Career.address1
//        self.town = Career.address2
//        self.email = Career.mailAddress
//    }
//
//}
//
//
//    
extension ApiManager {
    class func createCareer(_ param: CreateCareerRequestDTO, isRetry: Bool = true) -> Promise<Void> {
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: param, task: createCareerFetch) { (error) -> Bool in return true }
            }
        } else {
            return createCareerFetch(param: param)
        }
    }
    private class func createCareerFetch(param: CreateCareerRequestDTO) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        CareerAPI.careerControllerCreate(body: param)
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
