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

struct VersionInfo {
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

    var majorVer: Int = 0
    var minorVer: Int = 0
    var patchVer: Int = 0

    init(bufVer: String) {
        let arr = bufVer.split(separator: ".")
        switch arr.count { //存在しない場所は「0」としておく
        case 0: majorVer = 0; minorVer = 0; patchVer = 0
        case 1: majorVer = Int(arr[0]) ?? 0; minorVer = 0; patchVer = 0
        case 2: majorVer = Int(arr[0]) ?? 0; minorVer = Int(arr[1]) ?? 0; patchVer = 0
        case 3: majorVer = Int(arr[0]) ?? 0; minorVer = Int(arr[1]) ?? 0; patchVer = Int(arr[2]) ?? 0
        default: majorVer = Int(arr[0]) ?? 0; minorVer = Int(arr[1]) ?? 0; patchVer = Int(arr[2]) ?? 0
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
    enum UpdateType {
        case none
        case optional
        case force
    }

    struct UpdateDialog {
        var updateTitle: String = Constants.TudUpdateDialogTitle
        var updateMessage: String = Constants.TudUpdateDialogMessage
        var appStoreUrl: String = Constants.TudUpdateAppStoreUrl
    }
    var updateDialog: UpdateDialog = UpdateDialog()

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
    //===アプリのバンドル情報を取得する
    //versionInfo: VersionInfo バージョン情報
    class func getAppVersion() -> VersionInfo {
        let ver = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
        return VersionInfo(bufVer: ver)
    }
}
extension VersionCheckManager {
    //===Apple提供 iTunesSearch/Lookupでストア公開中の情報を取得する
    //versionInfo: VersionInfo バージョン情報
    //storeAppInfo: GetStoreAppInfoResponseDTO アプリ情報の抜粋モデル
    class func getStoreVersion() -> Promise<(VersionInfo, GetStoreAppInfoResponseDTO)> {
        let (promise, resolver) = Promise<(VersionInfo, GetStoreAppInfoResponseDTO)>.pending()
        TudVerCheckAPI.basePath = AppDefine.ItunesLookupServerPath
        ItunesAPI.lookupGet(_id: AppDefine.ItunesLookupAppId, country: AppDefine.ItunesLookupCountry)
        .done { result in
            if let bufVer = result.results.first?.version {
                let verStore = VersionInfo(bufVer: bufVer)
                resolver.fulfill((verStore, result))
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
    //===Tud定義アップデート情報ファイルを取得する
    //versionInfo: VersionInfo バージョン情報
    //isFroce: Bool 強制アップデートするか、しないか
    class func getVersionInfo() -> Promise<(VersionInfo, Bool)> {
        let (promise, resolver) = Promise<(VersionInfo, Bool)>.pending()
        TudVerCheckAPI.basePath = AppDefine.tudUpdateInfoServerPath
        TudUpdateInfoAPI.jsonPathJsonNameGet(jsonPath: AppDefine.tudUpdateInfoJsonPath, jsonName: AppDefine.tudUpdateInfoJsonName)
        .done { result in
            //===ダイアログ文言などを定義に従って変更しておく
            VersionCheckManager.shared.updateDialog.updateTitle = result.dialogTitle ?? ""
            VersionCheckManager.shared.updateDialog.updateMessage = result.dialogMessage
            VersionCheckManager.shared.updateDialog.appStoreUrl = result.updateUrl
            let isForceUpdate: Bool = result.forceUpdate
            //===返却はバージョン番号のみ
            let verJson = VersionInfo(bufVer: result.requiredVersion)
            resolver.fulfill((verJson, isForceUpdate))
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
extension GetUpdateInfoResponseDTO {
    var debugDisp: String {
        var disp: [String] = []
        disp.append(String(repeating: "=", count: 22))
        disp.append("[チェック対象バージョン: \(requiredVersion)]")
        disp.append("[強制アップデートフラグ: \(forceUpdate)]")
        disp.append("[誘導ダイアログタイトル: \(dialogTitle ?? "")]")
        disp.append("[誘導ダイアログメッセージ: \(dialogMessage)]")
        disp.append("[AppStoreへの誘導URL: \(updateUrl)]")
        return disp.joined(separator: "\n")
    }
}
