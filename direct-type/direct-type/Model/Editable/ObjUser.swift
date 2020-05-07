//
//  ObjDbg.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/03/11.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import Foundation

struct ObjUser: EditableObj {
    var userId: String = ""
    var nameKana: String = ""   //名前（カタカナ）
    var email: String = ""      //メールアドレス
    var phone: String = ""      //電話番号
    var prefecture: String = "" //都道府県
    
    var debugDisp: String {
        return "[\(userId)] [\(nameKana)] [\(email)] / [\(phone)] [\(prefecture)]"
    }
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nameKana = "name_kana"
        case email
        case phone
        case prefecture
    }
}

//=== 開発用の項目と定義など
//ObjUserと対応させる
enum EditItemUser: String, EditItemProtocol {
    case userId
    case nameKana
    case email
    case phone
    case prefecture
    //表示名
    var dispName: String {
        switch self {
        case .userId:       return "ユーザID"
        case .nameKana:     return "名前（全角カタカナ）"
        case .email:        return "メールアドレス"
        case .phone:        return "電話番号"
        case .prefecture:   return "都道府県"
        }
    }
    //Placeholder Text
    var placeholder: String {
       switch self {
        case .userId:       return "ユーザID を入力"
        case .nameKana:     return "名前（全角カタカナ） を入力"
        case .email:        return "メールアドレス を入力"
        case .phone:        return "電話番号 を入力"
        case .prefecture:   return "都道府県 を入力"
        }
    }
    var itemKey: String {
        return "User_\(self.rawValue)" //ここでUniqになるようにしておく
    }
}
extension ObjUser{
    var jsonObj: [String: Codable] {
        var item: [String: Codable] = [:]
        item[EditItemUser.userId.rawValue] = self.userId
        item[EditItemUser.nameKana.rawValue] = self.nameKana
        item[EditItemUser.email.rawValue] = self.email
        item[EditItemUser.phone.rawValue] = self.phone
        item[EditItemUser.prefecture.rawValue] = self.prefecture
        return item
    }
}

