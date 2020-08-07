//
//  RecommendManager.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import PromiseKit
import SERecommend
import AWSMobileClient

final public class RecommendManager {
    enum SpecType {
        case ap111  //▼HOME上部枠：ap111  spec=ap111&num=【要求数】
        case ap112  //▼HOME下部枠：ap112  spec=ap112&num=【要求数】
        case ap211  //▼相性診断完了枠：ap211  spec=ap211&num=【要求数】
        case ap341  //▼案件詳細(トラッキング）：ap341 prod=【閲覧中の案件ID】&spec=ap341&num=0
        case ap511  //▼応募完了枠：ap511    prod=【応募完了した案件ID1】&spec=ap511&num=【要求数】
        case ap711  //▼検索結果枠：ap711    spec=ap711&num=【要求数】
        
        var specID: String {
            switch self {
            case .ap111:    return "ap111"
            case .ap112:    return "ap112"
            case .ap211:    return "ap211"
            case .ap341:    return "ap341"
            case .ap511:    return "ap511"
            case .ap711:    return "ap711"
            }
        }
    }
    
    public static let shared = RecommendManager()
    private init() {
    }
}
extension RecommendManager {
    class func fetchRecommend(type: RecommendManager.SpecType, jobID: String) -> Promise<Void> {
        switch type {
        case .ap341:
            return getRecommendFetch(spec: type.specID, jobID: jobID, num: 0)
        case .ap511:
            return getRecommendFetch(spec: type.specID, jobID: jobID)
        case .ap111, .ap112, .ap211, .ap711:
            return getRecommendFetch(spec: type.specID)
        }
    }
    class func clickRecommend(type: RecommendManager.SpecType, jobID: String) -> Promise<Void> {
        switch type {
        case .ap341:
            return clickRecommendFetch(spec: type.specID, jobID: jobID)
        default:
            let (promise, resolver) = Promise<Void>.pending()
            resolver.fulfill(Void())
            return promise
        }
    }
}

extension RecommendManager {
    private class func getRecommendFetch(spec: String, jobID: String? = nil, num: Int = 100) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        let sub: String = AWSMobileClient.default().username ?? ""
        SERecommendAPI.basePath = AppDefine.RecommendServer
        RecommendAPI.pycre5JsonRecommendGet(merch: "directtype", cookie: sub, spec: spec, prod: jobID, num: num)
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
    private class func clickRecommendFetch(spec: String, jobID: String) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        let sub: String = AWSMobileClient.default().username ?? ""
        let orderId: String = Date().RecommendParamOrderID
        SERecommendAPI.basePath = AppDefine.RecommendServer
        RecommendAPI.pycre5PurchaseGet(prod: jobID, merch: "directtype", sku: jobID, order: orderId, qty: 1, price: 1, cust: sub, cookie: sub, device: "a")
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
