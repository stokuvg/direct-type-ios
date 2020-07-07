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
//=== レコメンド 仕事一覧取得 ===
extension ApiManager {
    class func getRecommendJobs(_ pageNo: Int, isRetry: Bool = true) -> Promise<MdlJobCardList> {
//    class func getJobs(_ param: Void, isRetry: Bool = true) -> Promise<MdlJobCardList> {
        if isRetry {
            return firstly { () -> Promise<MdlJobCardList> in
                retry(args: pageNo, task: getRecommendJobsFetch) { (error) -> Bool in return true }
            }
        } else {
            return getRecommendJobsFetch(pageNo: pageNo)
        }
    }
    
    private class func getRecommendJobsFetch(pageNo: Int) -> Promise<MdlJobCardList> {
        Log.selectLog(logLevel: .debug, "getRecommendJobsFetch start")
        let (promise, resolver) = Promise<MdlJobCardList>.pending()
        AuthManager.needAuth(true)
        JobsAPI.jobsControllerRecommended(page: pageNo)
        .done { result in
            Log.selectLog(logLevel: .debug, "recommended result:\(result)")
//            print(#line, #function, result)
            resolver.fulfill(MdlJobCardList(dto: result)) //変換しておく
        }
        .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
            Log.selectLog(logLevel: .debug, "recommended error:\(error)")
            
            resolver.reject(error)
        }
        .finally {
        }
        return promise
    }
}

//================================================================
//=== 仕事一覧取得 ===
extension ApiManager {
    class func getJobs(_ pageNo: Int, isRetry: Bool = true) -> Promise<MdlJobCardList> {
//    class func getJobs(_ param: Void, isRetry: Bool = true) -> Promise<MdlJobCardList> {
        if isRetry {
            return firstly { () -> Promise<MdlJobCardList> in
                retry(args: pageNo, task: getJobsFetch) { (error) -> Bool in return true }
            }
        } else {
            return getJobsFetch(pageNo: pageNo)
        }
    }
    
    private class func getJobsFetch(pageNo: Int) -> Promise<MdlJobCardList> {
        let (promise, resolver) = Promise<MdlJobCardList>.pending()
        AuthManager.needAuth(true)
        JobsAPI.jobsControllerGet(page: pageNo)
        .done { result in
//            print(#line, #function, result)
            resolver.fulfill(MdlJobCardList(dto: result)) //変換しておく
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
            .done { result in
                resolver.fulfill(MdlJobCardDetail(dto: result))
        }.catch { (error) in
            Log.selectLog(logLevel: .debug, "getJobDetailFetch error:\(error.localizedDescription)")
            
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
//                Log.selectLog(logLevel: .debug, "sendJobSkip result:\(result)")
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
//                Log.selectLog(logLevel: .debug, "sendJobSkipFetch result:\(result)")
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
    class func sendJobKeep(id: String) -> Promise<MdlJobCard> {
        // true:キープ追加,false:キープ削除
        let keepRequest = CreateKeepRequestDTO.init(jobId: id)
        KeepsAPI.keepsControllerCreate(body: keepRequest)
            .done { result in
                Log.selectLog(logLevel: .debug, "keep create result:\(result)")
            }.catch{ (error) in
                
            }.finally {
            }
        return sendCreateJobKeepFetch(id: id)
    }

    private class func sendCreateJobKeepFetch(id: String) -> Promise<MdlJobCard> {
        let (promise, resolver) = Promise<MdlJobCard>.pending()
        AuthManager.needAuth(true)
        let keepRequest = CreateKeepRequestDTO.init(jobId: id)
        KeepsAPI.keepsControllerCreate(body: keepRequest)
            .done { result in
                Log.selectLog(logLevel: .debug, "sendCreateJobKeepFetch result:\(result)")
                resolver.fulfill(MdlJobCard())
        }.catch { (error) in
            resolver.reject(error)
        }.finally {
        }
        
        return promise
    }
    
    class func sendJobDeleteKeep(id: String) -> Promise<Void> {
        return sendDeleteJobKeepFetch(id: id)
    }

    private class func sendDeleteJobKeepFetch(id: String) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        KeepsAPI.keepsControllerDelete(jobId: id)
            .done { result in
                Log.selectLog(logLevel: .debug, "sendDeleteJobKeepFetch result:\(result)")
                resolver.fulfill(Void())
        }.catch { (error) in
            Log.selectLog(logLevel: .debug, "sendDeleteJobKeepFetch error:\(error)")
            resolver.reject(error)
        }.finally {
        }
        
        return promise
    }
}
//================================================================
