//
//  ApiManager+AuthCode.swift
//  direct-type
//
//  Created by yamataku on 2020/06/17.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

//================================================================
//extension ApiManager {
//    class func getAuthCode(_ param: GetAuthCodeRequestDTO, isRetry: Bool = true) -> Promise<Void> {
//        if isRetry {
//            return firstly { () -> Promise<Void> in
//                retry(args: param, task: getAuthCode) { (error) -> Bool in return true }
//            }
//        } else {
//            return getAuthCode(param: param)
//        }
//    }
//    private class func getAuthCode(param: GetAuthCodeRequestDTO) -> Promise<Void> {
//        let (promise, resolver) = Promise<Void>.pending()
//        AuthManager.needAuth(true)
//        AccpuntAPI.authCodeControllerPost(body: param)
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
//extension GetAuthCodeRequestDTO {
//    init(phoneNumber: String) {
//        self.init(phoneNumber: phoneNumber)
//    }
//}
//================================================================
