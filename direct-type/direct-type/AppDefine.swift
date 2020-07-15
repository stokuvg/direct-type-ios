//
//  AppDefine.swift
//  direct-type
//
//  Created by yamataku on 2020/07/01.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

// アプリ内全体の設定フラグなどを集約するためのファイル
struct AppDefine {
    // AppsFlyerデバッグログフラグ
    static let isDebugForAppsFlyer = false
    // TODO: パスワードは毎回自動生成する必要があるため、強度の検討が完了した後に自動生成ロジックを実装する
    // 参照: https://type.qiita.com/y_kawamata/items/e251d8904820d5b5ceaf
    static let password = "Abcd123$"
}

//NOTE: 「リンク先URL定義」シートに記載したものと同じ状況で定義しておく
enum DirectTypeLinkURL {
    case TypeEntryPasswordForgot    //[C-12]『応募確認』「パスワード再発行の導線」
    case TypeEntryPersonalInfo      //[C-12]『応募確認』「個人情報」
    case TypeEntryMemberPolicy      //[C-12]『応募確認』「会員規約」
    //リンクテキスト
    var dispText: String {
        switch self {
        case .TypeEntryPasswordForgot:
            return "転職サイトtypeに登録済みのパスワードがわからない場合"
        case .TypeEntryPersonalInfo:
            return "転職サイトtypeの個人情報の取り扱いについて"
        case .TypeEntryMemberPolicy:
            return "転職サイトtypeの会員規約"
        }
    }
    //リンク先URLテキスト
    var urlText: String {
        switch self {
        case .TypeEntryPasswordForgot:
            return "https://type.jp/reminder/input.do"
        case .TypeEntryPersonalInfo:
            return "https://type.jp/s/kojin/"
        case .TypeEntryMemberPolicy:
            return "https://type.jp/help/category_14.html"
        }
    }
    var url: URL? {
        return URL(string: urlText)
    }
    //アプリ内部ブラウザで表示するか、外部ブラウザで表示するか
    enum LinkType {
        case appWebBrowser  //内部ブラウザ
        case openBrowser    //外部ブラウザ
    }
    var linkType: LinkType {
        switch self {
        case .TypeEntryPasswordForgot:  return .openBrowser
        case .TypeEntryPersonalInfo:    return .openBrowser
        case .TypeEntryMemberPolicy:    return .openBrowser
        }
    }
}
