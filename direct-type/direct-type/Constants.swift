//
//  Constants.swift
//  AmplifySample
//
//  Created by ms-mb014 on 2020/01/31.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

typealias BigDecimal = Double

struct Constants {
    //=== 通信関連の設定値
    static let FetchIntervalSecond: TimeInterval = 10 * 60 // 10minutes経つまで、フェッチを抑止する(APIError.noFetchを返す)
    static let ApiAutoRetryMax: Int = 1 // 自動リトライ回数（初回含めているので、2以上じゃないとidTokenリフレッシュができない）
    // ⇒ 401の場合だけは、かならずリトライを１回は試みると内部で処理しておくべきか？（サインイン頻度の仕様によって考慮する）
    static let ApiAutoRetryDelaySecond: DispatchTimeInterval = .seconds(1) // 自動リトライ間隔
    //=== 認証関連 (これと、【awsconfiguration.json】に設定しておく)
    static let CognitoIdentityPoolId: String = "ap-northeast-1:4da204bb-c86f-419d-9879-8744af15248f"
//    //Suggest検索関連
//    static let SuggestCellHeight: CGFloat = 25.0 //表示項目数の高さ
//    static let SuggestSearchResultMax: Int = 100 //結果の表示項目数の最大
//    static let SuggestSearchDispLineMax: Int = 5 //結果の表示行数の最大（超えた場合はスクロール）
    
    //選択しなどでマスタからの選択だった場合の文言
    static let SelectItemsUndefine: CodeDisp = CodeDisp("", "<未選択>")  //未定義な値だった場合
    
    static let SelectItemsNotSelect: String = "選択しない"   //ユーザが「選択しない」を選んだ場合

    //[Debug] Debug時以外はfalseにすべきフラグで設定しておく
    static let DbgAutoSelTabVC: Bool = false
    static let DbgAutoPushVC: Bool = true
    static let DbgAutoPushVCNum: Int = 1  //0:なし, 1:プロフィール, 2:履歴書, 3:職歴, 4:サクサク職歴
    
    static let DbgDispStatus: Bool = false
    static let DbgSkipLocalValidate: Bool = false
    static let DbgCmnInputDefault: Bool = false
}
