//
//  ApiManager+PhoneNumber.swift
//  direct-type
//
//  Created by yamataku on 2020/06/17.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import TudApi

//================================================================
//extension ApiManager {
//    class func postPhoneNumber(_ param: UpdatePhoneNumberRequestDTO, isRetry: Bool = true) -> Promise<Void> {
//        if isRetry {
//            return firstly { () -> Promise<Void> in
//                retry(args: param, task: postPhoneNumber) { (error) -> Bool in return true }
//            }
//        } else {
//            return postPhoneNumber(param: param)
//        }
//    }
//    private class func postPhoneNumber(param: UpdatePhoneNumberRequestDTO) -> Promise<Void> {
//        let (promise, resolver) = Promise<Void>.pending()
//        AuthManager.needAuth(true)
//        AccpuntAPI.phoneNumberControllerPost(body: param)
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
//=== 電話番号変更 ===
//extension UpdatePhoneNumberRequestDTO {
//    init(phoneNumber: String) {
//        self.init(phoneNumber: phoneNumber)
//    }
//}
//================================================================
