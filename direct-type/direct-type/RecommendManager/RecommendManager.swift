//
//  RecommendManager.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import PromiseKit
import RecommendApi
import AWSMobileClient

final public class RecommendManager {
    enum SpecType {
//        case click
//        case api111
//        case ap111
//        case ap112
//        case ap211
        case ap341
//        case ap511
//        case ap711
        
    }
    public static let shared = RecommendManager()
    private init() {
    }
}
extension RecommendManager {
    class func fetchRecommend(type: RecommendManager.SpecType, jobID: String) -> Promise<Void> {
        let sub: String = AWSMobileClient.default().username ?? ""
        switch type {
        case .ap341:
            return getCareerFetch(jobID: jobID, sub: sub, spec: "ap341")
        }
    }
}

//AWSMobileClient.default().username
extension RecommendManager {
    private class func getCareerFetch(jobID: String, sub: String, spec: String) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()


        print(jobID, sub, spec)


        RecomendAPI.dummpycre5ClickGet(prod: jobID, merch: "directtype", cookie: sub)
        .done { result in
            resolver.fulfill(Void())
        }
        .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            print(error.localizedDescription)
            print(myErr.debugDisp)
            
            
            
            resolver.reject(error)
        }
        .finally {
        }
        return promise
    }
}
