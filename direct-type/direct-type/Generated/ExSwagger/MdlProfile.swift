//
//  MdlProfile.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//
//アプリ用のモデル<MdlHoge>と、入力編集用のモデル<EditItemHoge>

import UIKit
import SwaggerClient

class MdlProfile: Codable {
    /** 氏 */
     var familyName: String = ""
    /** 名 */
     var firstName: String = ""
    /** 氏（カナ） */
     var familyNameKana: String = ""
    /** 名（カナ） */
     var firstNameKana: String = ""

    var birthday: Date = Date(timeIntervalSince1970: 0)
    /** 性別 */
     var gender: Code = ""
    /** 郵便番号 */
     var zipCode: String = ""
    /** 都道府県 */
     var prefecture: Code = ""
    /** 市区町村 */
     var address1: String = ""
    /** 丁目・番地・建物名など */
     var address2: String = ""
    /** メールアドレス */
     var mailAddress: String = ""
    /** 携帯電話番号（変更不可：認証アカウントと同一） */
     var mobilePhoneNo: String = ""

    init(familyName: String, firstName: String, familyNameKana: String, firstNameKana: String, birthday: Date, gender: Code, zipCode: String, prefecture: Code, address1: String, address2: String, mailAddress: String, mobilePhoneNo: String) {
        self.familyName = familyName
        self.firstName = firstName
        self.familyNameKana = familyNameKana
        self.firstNameKana = firstNameKana
        self.birthday = birthday
        self.gender = gender
        self.zipCode = zipCode
        self.prefecture = prefecture
        self.address1 = address1
        self.address2 = address2
        self.mailAddress = mailAddress
        self.mobilePhoneNo = mobilePhoneNo
    }
    //ApiモデルをAppモデルに変換して保持させる
    convenience init(dto: Profile) {
        let bufDate = dto.birthday.dispYmd
        let _date = DateHelper.convStr2Date(bufDate)
        let _gender = "\(dto.gender)"
        let _prefecture = "\(dto.prefecture)"
        self.init(familyName: dto.familyName, firstName: dto.firstName, familyNameKana: dto.familyNameKana, firstNameKana: dto.firstNameKana, birthday: _date, gender: _gender, zipCode: dto.zipCode, prefecture: _prefecture, address1: dto.address1, address2: dto.address2, mailAddress: dto.mailAddress, mobilePhoneNo: dto.mobilePhoneNo)
    }

    var debugDisp: String {
        return "[\(familyName) \(firstName)（\(familyNameKana) \(firstNameKana)）"
    }
}

//=== 編集用の項目と定義など
enum EditItemMdlProfile: String, EditItemProtocol {
    case familyName
    case firstName
    case familyNameKana
    case firstNameKana
    case birthday
    case gender
    case zipCode
    case prefecture
    case address1
    case address2
    case mailAddress
    case mobilePhoneNo
    //表示名
    var dispName: String {
        switch self {
        case .familyName:       return "氏"
        case .firstName:        return "名"
        case .familyNameKana:   return "氏（カナ）"
        case .firstNameKana:    return "名（カナ）"
        case .birthday:         return "誕生日"
        case .gender:           return "性別"
        case .zipCode:          return "郵便番号"
        case .prefecture:       return "都道府県"
        case .address1:         return "市区町村"
        case .address2:         return "丁目・番地・建物名など"
        case .mailAddress:      return "メールアドレス"
        case .mobilePhoneNo:    return "帯電話番号（変更不可：認証アカウントと同一）"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .gender: return .gender
        case .prefecture: return .place
        default: return .undefine
        }
    }
    //Placeholder Text
    var placeholder: String {
        return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
}

extension ProfileBirthday {
    var dispYmd: String {
        return "\(birthdayYear.zeroUme(4))-\(birthdayMonth.zeroUme(2))-\(birthdayDay.zeroUme(2))"
    }
}
