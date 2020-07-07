//
//  ApiManager+Activity.swift
//  direct-type
//
//  Created by yamataku on 2020/07/07.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import TudApi

extension ApiManager {
    class func createActivity(isRetry: Bool = true) -> Promise<Void> {
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: (), task: createActivityFetch) { (error) -> Bool in return true }
            }
        } else {
            return createActivityFetch()
        }
    }
    private class func createActivityFetch() -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        ActivityAPI.activityControllerCreate()
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
