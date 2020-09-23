//
//  AppDefine.swift
//  direct-type
//
//  Created by yamataku on 2020/07/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//
//このファイルでは、BuildModeに応じて変わる設定値を記述する（主にエンドポイント関連など）
//NOTE: ビルド定義の切り替え方法
//【switchDev.sh】で開発用のモードに切り替える。それ以後は【rebuildAll.sh】を実行
//【switchRel.sh】でリリース用のモードに切り替える。それ以後は【rebuildAll.sh】を実行
//▼補足：
//これらのスクリプトを実行すると、「_BuildMode」フォルダにあるファイルをモードに応じてコピーする
//【awsconfiguration.json】は、AWSMobileClientが利用するCognito認証用の定義ファイル
//【BuildMode.swift】は、下記で定義している「AppDefine」でのモード指定。
//　⇒これに応じて値が切り替わるため、適宜Stagingなども増やして対応させていく


import Foundation

// アプリ内全体の設定フラグなどを集約するためのファイル
extension AppDefine {
    enum BuildMode {
        case ApiDev
        case Develop
        case Release
    }
    //=== Cognito 認証関連 (これと、【awsconfiguration.json】に設定しておく)
    //Develop: 【awsconfiguration_Dev.json】をリネームして利用する
    //Release: 【awsconfiguration_Rel.json】をリネームして利用する
    static var CognitoIdentityPoolId: String {
        switch AppDefine.buildMode {
        case .ApiDev:   return "ap-northeast-1:4da204bb-c86f-419d-9879-8744af15248f"
        case .Develop:  return "ap-northeast-1:4da204bb-c86f-419d-9879-8744af15248f"
        case .Release:  return "ap-northeast-1:c6e549ed-db63-4016-8386-55cad2c2f020"
        }
    }
    //=== AWSデバッグログフラグ
    static var isDebugForAWS: Bool {
        switch AppDefine.buildMode {
        case .ApiDev :  return true
        case .Develop:  return true
        case .Release:  return false
        }
    }
    //======= AppsFlyer定義
    //=== AppsFlyer定数定義（現在はDevもRelも一緒でOK）
    static var AppsFlyerTracker_appsFlyerDevKey = "hC9KqefECmBi3yLRDofayS"
    static var AppsFlyerTracker_appleAppID = "id1525688066"
    //=== AppsFlyerデバッグログフラグ（Suffixの切り替えに用いている）
    static var isDebugForAppsFlyer: Bool {
        switch AppDefine.buildMode {
        case .ApiDev :  return true
        case .Develop:  return true
        case .Release:  return false
        }
    }
    //======== SwaggerClient制御（api.jsonでの初期値を上書きして呼び出すため）
    //＊末尾に/をつけると405エラー発生となる
    //=== TUDAPI通信の定義
    static var tudApiServer: String {
        switch AppDefine.buildMode {
        case .ApiDev :  return "https://dev-api-m.directtype.net/v1.0"//開発
        case .Develop:  return "https://api-m.directtype.net/v1.0"//検証
        case .Release:  return "https://api-m.directtype.jp/v1.0"//本番
        }
    }
    //=== レコメンド通信の定義
    static var RecommendServer: String {
        switch AppDefine.buildMode {
        case .ApiDev :  return "https://directtype-test.silveregg.net"
        case .Develop:  return "https://directtype-test.silveregg.net"
        case .Release:  return "https://directtype.silveregg.net"
        }
    }
    //=== アップデート情報の定義
    static var tudUpdateInfoServerPath: String {
        switch AppDefine.buildMode {
        case .ApiDev :  return "https://s3-ap-northeast-1.amazonaws.com"//開発
        case .Develop:  return "https://s3-ap-northeast-1.amazonaws.com"//検証
        case .Release:  return "https://s3-ap-northeast-1.amazonaws.com"//本番
        }
    }
    static var tudUpdateInfoJsonPath: String {
        switch AppDefine.buildMode {
        case .ApiDev :  return "app-info.directtype.net"//開発
        case .Develop:  return "app-info.directtype.net"//検証
        case .Release:  return "app-info.directtype.jp"//本番
        }
    }
    static let tudUpdateInfoJsonName: String = "direct-type-ios-version.json"
    //=== AppStore公開中の情報取得 (iTunesSearch lookup)
    static let ItunesLookupServerPath: String = "https://itunes.apple.com"
    static let ItunesLookupAppId: String = "1525688066"
    static let ItunesLookupCountry: String = "JP"

    //======== その他のサイト定義
    //=== アプリ呼び出しWebページURL
    static var connectDommain: String {
        switch AppDefine.buildMode {
        case .ApiDev :  return "directtype.net"
        case .Develop:  return "directtype.net"
        case .Release:  return "directtype.jp"
        }
    }

}
