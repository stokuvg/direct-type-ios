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
        let mode: Int = 1 //（仮）
        let page: Int = 1 //（仮）
        AuthManager.needAuth(true)
        JobsAPI.jobsControllerGet(mode: mode, page: page)
        .done { result in
//            print(#line, #function, result)
            resolver.fulfill(MdlJobCardList(dto: result)) //変換しておく
//            resolver.fulfill(MdlJobCardList())
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
//=== 仕事詳細取得 ===
extension ApiManager {
//    class func getJobDetail(_ param: Void, isRetry: Bool = true) -> Promise<MdlJobCardDetail> {
    class func getJobDetail(_ jobId: String, isRetry: Bool = true) -> Promise<MdlJobCardDetail> {
        if isRetry {
            return firstly { () -> Promise<MdlJobCardDetail> in
//                retry(args: param, task: getJobDetailFetch) { (error) -> Bool in return true }
                retry(args: jobId, task: getJobDetailFetch) { (error) -> Bool in return true }
            }
        } else {
            return getJobDetailFetch(jobId: jobId)
//            return getJobDetailFetch(param: param)
        }
    }
    
    private class func getJobDetailFetch(jobId: String) -> Promise<MdlJobCardDetail> {
//    private class func getJobDetailFetch(param: Void) -> Promise<MdlJobCardDetail> {
        let (promise, resolver) = Promise<MdlJobCardDetail>.pending()
        AuthManager.needAuth(true)
        JobsAPI.jobsControllerDetail(jobId: jobId)
//        JobsAPI.jobsControllerGet(mode: mode, page: page)
            .done { result in
                resolver.fulfill(MdlJobCardDetail(dto: result))
        }.catch { (error) in
            Log.selectLog(logLevel: .debug, "error:\(error.localizedDescription)")
            
            resolver.reject(error)
        }.finally {
        }
        return promise
    }
}
//================================================================
extension ApiManager {
    
    class func sendJobSkip(id: String) -> Promise<MdlJobCard>{
        let skipRequest = CreateSkipRequestDTO.init(jobId: id)
        SkipAPI.skipControllerCreate(body: skipRequest)
            .done { result in
                Log.selectLog(logLevel: .debug, "result:\(result)")
            }.catch{ (error) in
                
            }.finally {
                
            }
        return sendJobSkipFetch(id: id)
    }
    
    private class func sendJobSkipFetch(id: String) -> Promise<MdlJobCard> {
        let (promise, resolver) = Promise<MdlJobCard>.pending()
        AuthManager.needAuth(true)
        let skipRequest = CreateSkipRequestDTO.init(jobId: id)
        SkipAPI.skipControllerCreate(body: skipRequest)
            .done { result in
                Log.selectLog(logLevel: .debug, "result:\(result)")
                resolver.fulfill(MdlJobCard())
        }.catch { (error) in
            resolver.reject(error)
        }.finally {
        }
        return promise
    }
}

//================================================================
extension ApiManager {
    class func sendJobKeep(id: String, flag: Bool) -> Promise<MdlJobCard> {
        // true:キープ追加,false:キープ削除
        if flag == true {
            let keepRequest = CreateKeepRequestDTO.init(jobId: id)
            KeepsAPI.keepsControllerCreate(body: keepRequest)
                .done { result in
                    Log.selectLog(logLevel: .debug, "keep create result:\(result)")
                }.catch{ (error) in
                    
                }.finally {
                }
            return sendCreateJobKeepFetch(id: id)
        } else {
            KeepsAPI.keepsControllerDelete(jobId: id)
            .done { result in
                Log.selectLog(logLevel: .debug, "keep delete result:\(result)")
            }.catch{ (error) in
                
            }.finally {
                
            }
            return sendDeleteJobKeepFetch(id: id)
        }
    }

    private class func sendCreateJobKeepFetch(id: String) -> Promise<MdlJobCard> {
        let (promise, resolver) = Promise<MdlJobCard>.pending()
        AuthManager.needAuth(true)
        let keepRequest = CreateKeepRequestDTO.init(jobId: id)
        KeepsAPI.keepsControllerCreate(body: keepRequest)
            .done { result in
                Log.selectLog(logLevel: .debug, "result:\(result)")
                resolver.fulfill(MdlJobCard())
        }.catch { (error) in
            resolver.reject(error)
        }.finally {
        }
        
        return promise
    }

    private class func sendDeleteJobKeepFetch(id: String) -> Promise<MdlJobCard> {
        let (promise, resolver) = Promise<MdlJobCard>.pending()
        AuthManager.needAuth(true)
        KeepsAPI.keepsControllerDelete(jobId: id)
            .done { result in
                Log.selectLog(logLevel: .debug, "result:\(result)")
                resolver.fulfill(MdlJobCard())
        }.catch { (error) in
            resolver.reject(error)
        }.finally {
        }
        
        return promise
    }
}
//================================================================
