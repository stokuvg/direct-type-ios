//
//  ApiManager+Chemistry.swift
//  direct-type
//
//  Created by yamataku on 2020/07/03.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import TudApi

extension ApiManager {
        class func getChemistry(_ param: Void, isRetry: Bool = true) -> Promise<MdlChemistry> {
        if isRetry {
            return firstly { () -> Promise<MdlChemistry> in
                retry(args: param, task: getChemistryFetch) { (error) -> Bool in return true }
            }
        } else {
            return getChemistryFetch(param: param)
        }
    }
    private class func getChemistryFetch(param: Void) -> Promise<MdlChemistry> {
        let (promise, resolver) = Promise<MdlChemistry>.pending()
        AuthManager.needAuth(true)
        ChemistryAPI.chemistryControllerGet()
        .done { result in
            ApiManager.shared.dicLastUpdate[.topRanker] = Date()//取得できたので、最終取得日時を更新
            resolver.fulfill(MdlChemistry(dto: result))
        }
        .catch { (error) in
            resolver.reject(error)
        }
        .finally {
        }
        return promise
    }
}
