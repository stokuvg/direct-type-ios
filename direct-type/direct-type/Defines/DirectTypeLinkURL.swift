//
//  DirectTypeLinkURL.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/08/05.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

//NOTE: 「リンク先URL定義」シートに記載したものと同じ状況で定義しておく
enum DirectTypeLinkURL {
    case TypeEntryPasswordForgot    //[C-12]『応募確認』「パスワード再発行の導線」
    case TypeEntryPersonalInfo      //[C-12]『応募確認』「個人情報」
    case TypeEntryMemberPolicy      //[C-12]『応募確認』「会員規約」
    case RegistPrivacyPolicy        //[A-3]『初回認証』「プライバシーポリシー」
    case RegistAgreement            //[A-3]『初回認証』「利用規約」
    case RegistPhoneReason          //[A-3]『初回認証』「電話番号の確認が必要な理由」
    case LoginPrivacyPolicy         //[B-1]『ログイン』「プライバシーポリシー」
    case LoginAgreement             //[B-1]『ログイン』「利用規約」
    case LoginPhoneReason           //[B-1]『ログイン』「電話番号の確認が必要な理由」
    case AproachAbout               //[H-9]『アプローチ設定』「こちら」
    case SettingsFAQ                //[H-8]『設定Top』「よくある質問・ヘルプ」
    case SettingsHowTo              //[H-8]『設定Top』「使い方」
    case SettingsPrivacyPolicy      //[H-8]『設定Top』「プライバシーポリシー」
    case SettingsAgreement          //[H-8]『設定Top』「利用規約」
    case Help                       //[A-4][B-3] ヘルプ

    //リンクテキスト
    var dispText: String {
        switch self {
        case .TypeEntryPasswordForgot:
            return "パスワードが分からない"
        case .TypeEntryPersonalInfo:
            return "個人情報"
        case .TypeEntryMemberPolicy:
            return "会員規約"
        case .RegistPrivacyPolicy: fallthrough
        case .LoginPrivacyPolicy:
            return "プライバシーポリシー"
        case .RegistAgreement: fallthrough
        case .LoginAgreement:
            return "利用規約"
        case .RegistPhoneReason: fallthrough
        case .LoginPhoneReason:
            return "電話番号の確認が必要な理由"
        case .AproachAbout:
            return "こちら"
        case .SettingsFAQ:
            return "よくある質問・ヘルプ"
        case .SettingsHowTo:
            return "使い方"
        case .SettingsPrivacyPolicy:
            return "プライバシーポリシー"
        case .SettingsAgreement:
            return "利用規約"
        case .Help:
            return "ヘルプ"
        }
        
    }
    
//    static var connectDommain:String = "directtype.net" // 仮環境
//    static var connectDommain:String = "directtype.jp" // 本番
    static var connectDommain: String = AppDefine.connectDommain

    //リンク先URLテキスト
    var urlText: String {
        switch self {
        //===type応募時
            case .TypeEntryPasswordForgot:
                return "https://type.jp/reminder/input.do"
            case .TypeEntryPersonalInfo:
                return "https://type.jp/s/kojin/"
            case .TypeEntryMemberPolicy:
                return "https://type.jp/help/category_14.html"
        //===ユーザ作成、ログイン
            case .LoginPrivacyPolicy, .RegistPrivacyPolicy:
                return "https://" + DirectTypeLinkURL.connectDommain + "/privacy/index.html"
            case .RegistAgreement: fallthrough
            case .LoginAgreement, .SettingsAgreement:
                return "https://" + DirectTypeLinkURL.connectDommain + "/policy/index.html"
            case .RegistPhoneReason, .LoginPhoneReason:
                return "https://" + DirectTypeLinkURL.connectDommain + "/help/index.html#001"
        //===アプローチ設定
            case .AproachAbout:
                return "https://" + DirectTypeLinkURL.connectDommain + "/help/index.html#002"
        //===設定項目
            case .SettingsFAQ:
                return "https://" + DirectTypeLinkURL.connectDommain + "/help/index.html"
            case .SettingsHowTo:
                return "https://" + DirectTypeLinkURL.connectDommain + "/tutorial/index.html"
            case .SettingsPrivacyPolicy:
                return "https://" + DirectTypeLinkURL.connectDommain + "/privacy/index.html"
        //===ヘルプ
            case .Help:
                return "https://" + DirectTypeLinkURL.connectDommain + "/help/index.html#003"
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
        case .RegistPrivacyPolicy:      return .appWebBrowser
        case .RegistAgreement:          return .appWebBrowser
        case .RegistPhoneReason:        return .appWebBrowser
        case .LoginPrivacyPolicy:       return .appWebBrowser
        case .LoginAgreement:           return .appWebBrowser
        case .LoginPhoneReason:         return .appWebBrowser
        case .AproachAbout:             return .appWebBrowser
        case .SettingsFAQ:              return .appWebBrowser
        case .SettingsHowTo:            return .appWebBrowser
        case .SettingsPrivacyPolicy:    return .appWebBrowser
        case .SettingsAgreement:        return .appWebBrowser
        case .Help:                     return .appWebBrowser
        }
    }
}
