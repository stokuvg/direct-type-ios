//
//  VersionCheckManager.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/09/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation
import PromiseKit
import TudVerCheck

final public class VersionCheckManager {
    public static let shared = VersionCheckManager()
    private init() {
    }
}

extension VersionCheckManager {
    class func getStoreVersion() -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        TudVerCheckAPI.basePath = "https://itunes.apple.com"
        ItunesAPI.lookupGet(_id: "1525688066", country: "JO")
        .done { result in
            print(result.debugDisp)
            resolver.fulfill(Void())
        }
        .catch { (error) in
            resolver.reject(error)
        }
        .finally {
        }
        return promise
    }
    class func getVersionInfo() -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        TudVerCheckAPI.basePath = "https://s3-ap-northeast-1.amazonaws.com"
        TudVerChkAPI.appInfoDirecttypeNetDirectTypeIosVersionJsonGet()
        .done { result in
            print(result.debugDisp)
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

extension GetStoreAppInfoResponseDTO {
    var debugDisp: String {
        var disp: [String] = []
        for (n, item) in results.enumerated() {
            disp.append(String(repeating: "=", count: 22))
            disp.append("[trackId: \(item.trackId)]")
            disp.append("[trackName: \(item.trackName)]")
            disp.append("[初回リリース日時: \(item.releaseDate)]")
            disp.append("[公開中の最新バージョン: \(item.version)]")
            disp.append("[最新バージョン公開日時: \(item.currentVersionReleaseDate)]")
        }
        return disp.joined(separator: "\n")
    }
}
extension GetTudVersionCheckResponseDTO {
    var debugDisp: String {
        var disp: [String] = []
        disp.append(String(repeating: "=", count: 22))
        disp.append("[チェック対象バージョン: \(requiredVersion)]")
        disp.append("[動作フラグ: \(type)]")
        disp.append("[AppStoreへの誘導URL: \(updateUrl)]")
        return disp.joined(separator: "\n")
    }
}
