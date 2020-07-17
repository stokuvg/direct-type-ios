//
//  Constants.swift
//  AmplifySample
//
//  Created by ms-mb014 on 2020/01/31.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

// TODO: 今後アプリ内の設定フラグなどは「AppDefine」クラスに徐々に移管していくため、このファイルには新規のプロパティを追加しない
struct Constants {
    //安全なダミー番号: https://stabucky.com/wp/archives/6180
    static let Auth_username: String = "+8190012345678" //安全なダミー番号: https://stabucky.com/wp/archives/6180
    static var Auth_password: String {
        return AppDefine.password
    }

    
    //=== レコメンド通信の定義
    //      - url: 'https://directtype.silveregg.net'
    //        description: 本番環境
    //      - url: 'https://directtype-test.silveregg.net'
    //        description: テスト環境
    static let RecommendServer: String = "https://directtype-test.silveregg.net"

    
    //=== 通信関連の設定値
    static let FetchIntervalSecond: TimeInterval = 10 * 60 // 10minutes経つまで、フェッチを抑止する(APIError.noFetchを返す)
    static let ApiAutoRetryMax: Int = 3 // 自動リトライ回数（初回含めているので、2以上じゃないとidTokenリフレッシュができない）
    // ⇒ 401の場合だけは、かならずリトライを１回は試みると内部で処理しておくべきか？（サインイン頻度の仕様によって考慮する）
    static let ApiAutoRetryDelaySecond: DispatchTimeInterval = .seconds(1) // 自動リトライ間隔
    //=== 認証関連 (これと、【awsconfiguration.json】に設定しておく)
    static let CognitoIdentityPoolId: String = "ap-northeast-1:4da204bb-c86f-419d-9879-8744af15248f"
    

    //制限値の定数定義
    static let SelectMultidMaxUndefine: Int = 9999 //最大選択数未定義の場合
    static let CareerCardMax: Int = 10 //職務経歴書カードの登録際台数
    //応募や職歴などでのダミー文字列
    static let TypeDummyStrings: String = "▲▽"
    

    //「年」「月」選択Picker用定義
    static let years: [Int] = (1900...2100).map { $0 }
    static let months: [Int] = (1...12).map { $0 }
    //無指定だったときの日時
    static let DefaultSelectWorkPeriodStartDate: Date = DateHelper.convStrYM2Date("2018-04")//初期選択値
    static let DefaultSelectWorkPeriodEndDate: Date = DateHelper.convStrYM2Date("9999-12")//就業中の場合は9999-12とする
    static let DefaultSelectWorkPeriodEndDateJP: String = "就業中"//就業中の場合は9999-12とする
    static let ExclusiveSelectCodeDisp: CodeDisp = CodeDisp("0", "勤務地にはこだわらない")
    static let SelectItemsUndefineDate: Date = DateHelper.convStrYMD2Date("1800-01-01")
    static let SelectItemsUndefineDateJP: String = "未設定"
    static let SelectItemsUndefineBirthday: Date = DateHelper.convStrYMD2Date("1996-01-01")//誕生日の場合の初期値
    //選択肢などでマスタからの選択だった場合の文言
    static let SelectItemsUndefine: CodeDisp = CodeDisp("", "<未選択>")  //未定義な値だった場合
    //プレビュ・編集などでの未設定時（初期値）での表示文字列
    static let SelectItemsValEmpty: CodeDisp = CodeDisp("", "<未入力>")
    
    static let SelectItemsNotSelect: String = "選択しない"   //ユーザが「選択しない」を選んだ場合

    //[Debug] Debug時以外はfalseにすべきフラグで設定しておく
    static let DbgAutoPushVC: Bool = false
    static let DbgAutoPushVCNum: Int = 1 //0:なし, 1:プロフィール, 2:履歴書, 3:職歴, 4:サクサク職歴, 5:初回入力, 6: 職歴一覧, 7: 応募フォーム
    static let DbgDispStatus: Bool = false
    static let DbgFetchDummyData: Bool = false //フェッチ時にローカルで用意したダミーデータを返却する場合
}

