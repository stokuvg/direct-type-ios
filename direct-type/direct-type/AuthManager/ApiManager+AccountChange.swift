//
//  ApiManager+AccountChange.swift
//  direct-type
//
//  Created by yamataku on 2020/07/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import TudApi
import PromiseKit

extension ApiManager {
    class func accountMigrate(_ param: AccountMigrateRequest, isRetry: Bool = true) -> Promise<Void> {
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: param, task: accountMigrateFetch) { (error) -> Bool in return true }
            }
        } else {
            return accountMigrateFetch(param: param)
        }
    }
    private class func accountMigrateFetch(param: AccountMigrateRequest) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        AccountAPI.accountControllerMigrate(body: param)
        .done { result in
            resolver.fulfill(Void())
        }
        .catch { (error) in
            resolver.reject(error)
        }
        .finally {
        }
        return promise
    }
    
    class func accountMigrateAnswer(_ param: AccountMigrateAnswerRequest, isRetry: Bool = true) -> Promise<Void> {
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: param, task: accountMigrateAnswerFetch) { (error) -> Bool in return true }
            }
        } else {
            return accountMigrateAnswerFetch(param: param)
        }
    }
    private class func accountMigrateAnswerFetch(param: AccountMigrateAnswerRequest) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        AccountAPI.accountControllerMigrateAnswer(body: param)
        .done { result in
            resolver.fulfill(Void())
        }
        .catch { (error) in
            resolver.reject(error)
        }
        .finally {
        }
        return promise
    }
}
