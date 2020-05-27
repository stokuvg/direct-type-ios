//
//  ApiManager+Jobs.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import TudApi

//================================================================
//=== 仕事一覧取得 ===
extension ApiManager {
    class func getJobs(_ param: Void, isRetry: Bool = true) -> Promise<MdlJobCardList> {
        if isRetry {
            return firstly { () -> Promise<MdlJobCardList> in
                retry(args: param, task: getJobsFetch) { (error) -> Bool in return true }
            }
        } else {
            return getJobsFetch(param: param)
        }
    }
    private class func getJobsFetch(param: Void) -> Promise<MdlJobCardList> {
        let (promise, resolver) = Promise<MdlJobCardList>.pending()
        AuthManager.needAuth(true)
        JobsAPI.jobsControllerGet()
        .done { result in
            print(result)
            resolver.fulfill(MdlJobCardList()) //変換しておく
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
