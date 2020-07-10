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
