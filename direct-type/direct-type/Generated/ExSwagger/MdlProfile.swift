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
     var gender: Int = 0
    /** 郵便番号 */
     var zipCode: String = ""
    /** 都道府県 */
     var prefecture: Int = 0
    /** 市区町村 */
     var address1: String = ""
    /** 丁目・番地・建物名など */
     var address2: String = ""
    /** メールアドレス */
     var mailAddress: String = ""
    /** 携帯電話番号（変更不可：認証アカウントと同一） */
     var mobilePhoneNo: String = ""

    enum CodingKeys: String, CodingKey {
        case familyName = "family_name"
        case firstName = "first_name"
        case familyNameKana = "family_name_kana"
        case firstNameKana = "first_name_kana"
        case birthday
        case gender
        case zipCode = "zip_code"
        case prefecture
        case address1
        case address2
        case mailAddress = "mail_address"
        case mobilePhoneNo = "mobile_phone_no"
    }
    
    public init(familyName: String, firstName: String, familyNameKana: String, firstNameKana: String, birthday: Date, gender: Int, zipCode: String, prefecture: Int, address1: String, address2: String, mailAddress: String, mobilePhoneNo: String) {
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

    convenience init(dto: Profile) {
        let bufDate = dto.birthday.dispYmd
        let date = DateHelper.convStr2Date(bufDate)
        self.init(familyName: dto.familyName, firstName: dto.firstName, familyNameKana: dto.familyNameKana, firstNameKana: dto.firstNameKana, birthday: date, gender: dto.gender, zipCode: dto.zipCode, prefecture: dto.prefecture, address1: dto.address1, address2: dto.address2, mailAddress: dto.mailAddress, mobilePhoneNo: dto.mobilePhoneNo)
    }

    var debugDisp: String {
        return "[\(familyName) \(firstName)（\(familyNameKana) \(firstNameKana)）"
    }
}

//=== 開発用の項目と定義など
//ObjUserと対応させる
enum EditItemProfile: String, EditItemProtocol {
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
    //Placeholder Text
    var placeholder: String {
        return "[\(self.itemKey) PlaceHolder]"
    }
    var itemKey: String {
        return "Profile_\(self.rawValue)" //ここでUniqになるようにしておく
    }
}

extension ProfileBirthday {
    var dispYmd: String {
        return "\(birthdayYear.zeroUme(4))-\(birthdayMonth.zeroUme(2))-\(birthdayDay.zeroUme(2))"
    }
}
