//
//  APIManager+Withdraw.swift
//  direct-type
//
//  Created by yamataku on 2020/07/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import TudApi

extension ApiManager {
    class func sendDeleteAccount() -> Promise<Void> {
        return sendDeleteAccountFetch()
    }

    private class func sendDeleteAccountFetch() -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        WithdrawAPI.withdrawControllerDelete()
            .done { result in
                resolver.fulfill(Void())
        }.catch { (error) in
            resolver.reject(error)
        }.finally {}
        
        return promise
    }
}
