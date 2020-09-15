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

enum VersionCheckResult {
    case same
    case older(Position)
    case newer(Position)

    enum Position {
        case major
        case minor
        case patch
    }
}

struct VersionInfo {
    var majorVer: Int = 0
    var minorVer: Int = 0
    var patchVer: Int = 0

    init(bufVer: String) {
        let arr = bufVer.split(separator: ".")
        switch arr.count {
        case 0:
            print("Format Error! - [\(bufVer)]")
        case 1:
            majorVer = Int(arr[0]) ?? 0; minorVer = 0; patchVer = 0
        case 2:
            majorVer = Int(arr[0]) ?? 0; minorVer = Int(arr[1]) ?? 0; patchVer = 0
        case 3:
            majorVer = Int(arr[0]) ?? 0; minorVer = Int(arr[1]) ?? 0; patchVer = Int(arr[2]) ?? 0
        default:
            print("Format Error! - [\(bufVer)]")
            majorVer = Int(arr[0]) ?? 0; minorVer = Int(arr[1]) ?? 0; patchVer = Int(arr[2]) ?? 0
        }
    }

    func checkVersion(target: VersionInfo) -> VersionCheckResult {
        switch (self.majorVer, target.majorVer) {
        case (let lv, let rv) where lv < rv: return .older(.major)
        case (let lv, let rv) where lv > rv: return .newer(.major)
        default: break
        }
        switch (self.minorVer, target.minorVer) {
        case (let lv, let rv) where lv < rv: return .older(.minor)
        case (let lv, let rv) where lv > rv: return .newer(.minor)
        default: break
        }
        switch (self.patchVer, target.patchVer) {
        case (let lv, let rv) where lv < rv: return .older(.patch)
        case (let lv, let rv) where lv > rv: return .newer(.patch)
        default: break
        }
        return .same
    }
}

final public class VersionCheckManager {
    var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
    }
    var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    public static let shared = VersionCheckManager()
    private init() {
    }
}
extension VersionCheckManager {
    class func getAppVersion() -> VersionInfo {
        let ver = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
        return VersionInfo(bufVer: ver)
    }
}
extension VersionCheckManager {
    class func getStoreVersion() -> Promise<VersionInfo> {
        let (promise, resolver) = Promise<VersionInfo>.pending()
        TudVerCheckAPI.basePath = "https://itunes.apple.com"
        ItunesAPI.lookupGet(_id: "1525688066", country: "JP")
        .done { result in
            if let bufVer = result.results.first?.version {
                let verStore = VersionInfo(bufVer: bufVer)
                print(result.debugDisp)
                resolver.fulfill(verStore)
            } else {
                resolver.reject(NSError(domain: "Format Error", code: 0, userInfo: nil))
            }
        }
        .catch { (error) in
            resolver.reject(error)
        }
        .finally {
        }
        return promise
    }
    class func getVersionInfo() -> Promise<VersionInfo> {
        let (promise, resolver) = Promise<VersionInfo>.pending()
        TudVerCheckAPI.basePath = "https://s3-ap-northeast-1.amazonaws.com"
        TudVerChkAPI.appInfoDirecttypeNetDirectTypeIosVersionJsonGet()
        .done { result in
            let verJson = VersionInfo(bufVer: result.requiredVersion)
            print(result.debugDisp)
            resolver.fulfill(verJson)
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
