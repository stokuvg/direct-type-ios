//
//  Constants.swift
//  AmplifySample
//
//  Created by ms-mb014 on 2020/01/31.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

struct Constants {
//    //Suggest検索関連
//    static let SuggestCellHeight: CGFloat = 25.0 //表示項目数の高さ
//    static let SuggestSearchResultMax: Int = 100 //結果の表示項目数の最大
//    static let SuggestSearchDispLineMax: Int = 5 //結果の表示行数の最大（超えた場合はスクロール）
    
    //選択しなどでマスタからの選択だった場合の文言
    static let SelectItemsUndefine: CodeDisp = CodeDisp("", "<未選択>")  //未定義な値だった場合
    
    static let SelectItemsNotSelect: String = "選択しない"   //ユーザが「選択しない」を選んだ場合

    //[Debug] Debug時以外はfalseにすべきフラグで設定しておく
    static let DbgAutoPushVC: Bool = false
    static let DbgDispStatus: Bool = true
    static let DbgSkipLocalValidate: Bool = false
    static let DbgCmnInputDefault: Bool = false
}
