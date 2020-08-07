//
//  ApiManager+Keeps.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/06/11.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import TudApi

//================================================================
//=== キープ一覧取得 ===
extension ApiManager {
    class func getKeeps(_ pageNo: Int, isRetry: Bool = true) -> Promise<MdlKeepList> {
        if isRetry {
            return firstly { () -> Promise<MdlKeepList> in
                retry(args: pageNo, task: getKeepsFetch) { (error) -> Bool in return true }
            }
        } else {
            return getKeepsFetch(pageNo: pageNo)
        }
    }

    private class func getKeepsFetch(pageNo: Int) -> Promise<MdlKeepList> {
        let (promise, resolver) = Promise<MdlKeepList>.pending()
        AuthManager.needAuth(true)
        KeepsAPI.keepsControllerGet(page: pageNo)
        .done { result in
//            Log.selectLog(logLevel: .debug, "result:\(result)")
            for item in result.keepJobs {
                KeepManager.shared.setKeepStatusByFetch(jobCardID: item.jobId, status: true) //キープ一覧にあるものはキープ済み
            }
            resolver.fulfill(MdlKeepList(dto: result)) //変換しておく
        }
        .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
            resolver.reject(error)
        }
        .finally {
        }
        return promise
    }
}
