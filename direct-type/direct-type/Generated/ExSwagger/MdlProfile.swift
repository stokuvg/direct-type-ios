//
//  MdlProfile.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

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
     var birthday: ProfileBirthday = ProfileBirthday(birthdayYear: 1986, birthdayMonth: 4, birthdayDay: 1)
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
    
    public init(familyName: String, firstName: String, familyNameKana: String, firstNameKana: String, birthday: ProfileBirthday, gender: Int, zipCode: String, prefecture: Int, address1: String, address2: String, mailAddress: String, mobilePhoneNo: String) {
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
        self.init(familyName: dto.familyName, firstName: dto.firstName, familyNameKana: dto.familyNameKana, firstNameKana: dto.firstNameKana, birthday: dto.birthday, gender: dto.gender, zipCode: dto.zipCode, prefecture: dto.prefecture, address1: dto.address1, address2: dto.address2, mailAddress: dto.mailAddress, mobilePhoneNo: dto.mobilePhoneNo)
    }

    var debugDisp: String {
        return "[\(familyName) \(firstName)（\(familyNameKana) \(firstNameKana)）"
    }
}

extension ProfileBirthday {
    var disp: String {
        return "\(birthdayYear)年\(birthdayMonth)月\(birthdayDay)日"
    }
}
