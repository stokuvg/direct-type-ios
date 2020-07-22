//
//  ApiManager+Chemistry.swift
//  direct-type
//
//  Created by yamataku on 2020/07/03.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import TudApi

//================================================================
//=== 診断結果取得 ===
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
//================================================================
//=== 診断結果登録 ===
extension ApiManager {
    class func createChemistry(_ param: CreateChemistryRequestDTO, isRetry: Bool = true) -> Promise<Void> {
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: param, task: createChemistryFetch) { (error) -> Bool in return true }
            }
        } else {
            return createChemistryFetch(param: param)
        }
    }
    private class func createChemistryFetch(param: CreateChemistryRequestDTO) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        ChemistryAPI.chemistryControllerCreate(body: param)
        .done { result in
            ApiManager.shared.dicLastUpdate[.topRanker] = Date(timeIntervalSince1970: 0)//モデル更新したので、一覧再取得が必要
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
