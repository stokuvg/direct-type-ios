//
//  ApiManager+Approach.swift
//  direct-type
//
//  Created by yamataku on 2020/06/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import Foundation
import TudApi

//================================================================
//=== アプローチ取得 ===
extension ApiManager {
    class func getApproach(_ param: Void, isRetry: Bool = true) -> Promise<MdlApproach> {
        if isRetry {
            return firstly { () -> Promise<MdlApproach> in
                retry(args: param, task: getApproachFetch) { (error) -> Bool in return true }
            }
        } else {
            return getApproachFetch(param: param)
        }
    }
    private class func getApproachFetch(param: Void) -> Promise<MdlApproach> {
        let (promise, resolver) = Promise<MdlApproach>.pending()
        AuthManager.needAuth(true)
        SettingsAPI.settingsControllerGet()
        .done { result in
            resolver.fulfill(MdlApproach(dto: result)) //変換しておく
        }
        .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
            resolver.reject(error)
        }
        .finally {
        }
        return promise
    }
}

extension ApiManager {
    class func createApproach(_ param: CreateSettingsRequestDTO, isRetry: Bool = true) -> Promise<Void> {
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: param, task: createApproachFetch) { (error) -> Bool in return true }
            }
        } else {
            return createApproachFetch(param: param)
        }
    }
    private class func createApproachFetch(param: CreateSettingsRequestDTO) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        SettingsAPI.settingsControllerCreate(body: param)
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

extension ApiManager {
    class func updateApproach(_ param: UpdateSettingsRequestDTO, isRetry: Bool = true) -> Promise<Void> {
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: param, task: updateApproachFetch) { (error) -> Bool in return true }
            }
        } else {
            return updateApproachFetch(param: param)
        }
    }
    private class func updateApproachFetch(param: UpdateSettingsRequestDTO) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        SettingsAPI.settingsControllerUpdate(body: param)
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
//================================================================
