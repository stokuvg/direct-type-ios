//
//  AppDefine.swift
//  direct-type
//
//  Created by yamataku on 2020/07/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//
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
        case Develop
        case Release
    }
    //=== Cognito 認証関連 (これと、【awsconfiguration.json】に設定しておく)
    //Develop: 【awsconfiguration_Dev.json】をリネームして利用する
    //Release: 【awsconfiguration_Rel.json】をリネームして利用する
    static var CognitoIdentityPoolId: String {
        switch AppDefine.buildMode {
        case .Develop:  return "ap-northeast-1:4da204bb-c86f-419d-9879-8744af15248f"
        case .Release:  return "ap-northeast-1:c6e549ed-db63-4016-8386-55cad2c2f020"
        }
    }
    //=== AppsFlyerデバッグログフラグ
    static var isDebugForAppsFlyer: Bool {
        switch AppDefine.buildMode {
        case .Develop:  return true
        case .Release:  return false
        }
    }
    //=== TUDAPI通信の定義（末尾に/をつけると405エラー発生となる）
    static var tudApiServer: String {
        switch AppDefine.buildMode {
        case .Develop:  return "https://api.directtype.net"
        case .Release:  return "https://api.directtype.jp"
        }
    }
    //=== レコメンド通信の定義
    static var RecommendServer: String {
        switch AppDefine.buildMode {
        case .Develop:  return "https://directtype-test.silveregg.net"
        case .Release:  return "https://directtype.silveregg.net"
        }
    }
    //=== アプリ呼び出しWebページURL
    static var connectDommain: String {
        switch AppDefine.buildMode {
        case .Develop:  return "directtype.net"
        case .Release:  return "directtype.jp"
        }
    }

}
