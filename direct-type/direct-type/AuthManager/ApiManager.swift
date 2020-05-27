//
//  ApiManager.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/25.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

//===== フェッチ抑止処理 =====
//= フェッチ抑止の対象は FetchType を定義し、フェッチ成功時に dicLastUpdate に最終更新日時を保持させておく
//= needFetch でチェックすることで、フェッチが必要かを判定できる
//= 一定時間が経過している場合には、フェッチさせるために、Constants.FetchIntervalSecond で時間を定義している(秒)
//= フェッチ抑止対象に関連するもんを更新した場合、dicLastUpdate に timeIntervalSince1970 を入れておき、フェッチさせる

//===== API更新の要求 =====
//= pushで積まれている画面の、前方の方に更新が必要なことを伝えるため、必要な場合に Notification を投げておく

//===== 標準的なAPIアクセスの記述について =====
//= PromissKit6を用いて記述する
//= APIマネジャー(TodosAPI)を呼び出す会えに、認証が必要か不要かを AuthManager.needAuth で指定する
//= 　⇒ Authmanager が保持する idToken を、Authorization ヘッダの Bearer 認証として設定するようになっている
//= APIアクセスの開始時に通信くるくる表示をし、finally時にくるくる非表示にしている（一連で叩かれる場合などは、これだとダメです）
//=　⇒ 通信くるくるは差し替えやすくするため、いったん MyProgress をかましている（内部でカウントして、先ほどの多段に対応させておくか？）

//===== 複数のAPIを順列で叩く場合 =====
//= addAndEditTest0() に記載例あり
//= エラー発生時に以後の処理はされず、大元にエラーが戻る

//===== 複数のAPIを並列で叩く場合 =====
//= DispatchGroup と DispatchQueue を用いる予定

import PromiseKit
import TudApi

public enum ApiError: Error {
    case badParameter(String)
    case noFetch
    case userDefine(NSError)
    case validation(Error) //ValidationErrorモデルを定義したらそれを返すようにした方がよさげ
    case retryMax(Error)
}

final public class ApiManager {
    //フェッチ抑止制御をするもの
    enum FetchType {
        case todoList
    }
    var dicLastUpdate: [FetchType: Date] = [:]  //フェッチ抑止チェックのため

    public static let shared = ApiManager()
    private init() {
    }
}

extension ApiManager {
    //一覧の更新が必要かチェックしている（フェッチ抑止制御）
    class func needFetch(_ type: FetchType) -> Bool {
        guard let lastUpdate: Date = ApiManager.shared.dicLastUpdate[type] else { return true } //初回で未登録ならフェッチが必要
        let tiLastUpdate: TimeInterval = lastUpdate.timeIntervalSince1970
        let tiCurrent: TimeInterval = Date(timeIntervalSinceNow: 0).timeIntervalSince1970
        let flg = ( (tiCurrent - tiLastUpdate) > Constants.FetchIntervalSecond )
        print("今が: \(tiCurrent) / 最終更新が: \(tiLastUpdate) ... \(tiCurrent - tiLastUpdate) > \(Constants.FetchIntervalSecond) : \(flg)")
        return flg
    }
}

extension ApiManager {
    //宣言で「U ...」として可変長引数を受け取っても、task呼ぶ時に破綻していくのでだめなので固定長にした
    class func retry<T, U>(args: U, task: @escaping (U) -> Promise<T>, preRetry: @escaping (Error) -> Bool) -> Promise<T> {
        var count = 0
        func p() -> Promise<T> {
            count += 1
            return firstly {
                task(args)
            }
            .recover { error -> Promise<T> in
                let myErr = AuthManager.convAnyError(error)
                switch myErr.code {
                case 401:
                    print("401: NotAuthorized ちょっとまってリトライ")
                    break
                case 400: //Validation Errorはリトライしない
                    print("400: Validation Errorはリトライしない（一括チェック）")
                    throw error
                case 404: //404 Error はリトライしない
                    print("404: NotFound はリトライしない")
                    throw error
                case 500: //Network Errorはリトライしない
                    print("500: Network Error はリトライしない")
                    throw error
                default:
                    print("\(myErr.code): \(myErr)")
                    break
                }
                guard preRetry(error) else { throw error }
                guard count < Constants.ApiAutoRetryMax else { throw ApiError.retryMax(error) }
                return after(Constants.ApiAutoRetryDelaySecond).then { (Void) -> Promise<T> in
                    return p() //リトライ前に少し待たせる
                }
            }
        }
        return p()
    }
}
