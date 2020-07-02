//
//  MdlProfile.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//
//アプリ用のモデル<MdlHoge>と、入力編集用のモデル<EditItemHoge>

import UIKit
//import SwaggerClient
import TudApi

class MdlProfile: Codable {
    //===プロフィール作成は初期入力でのもののみ...
    var nickname: String = ""
    var hopeJobPlaceIds: [Code] = []
    //===プロフィール更新
    /** 氏 */
     var familyName: String = ""
    /** 名 */
     var firstName: String = ""
    /** 氏（カナ） */
     var familyNameKana: String = ""
    /** 名（カナ） */
     var firstNameKana: String = ""

    var birthday: Date = Constants.SelectItemsUndefineDate
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

    init(nickname: Code, hopeJobPlaceIds: [Code],
         familyName: String, firstName: String, familyNameKana: String, firstNameKana: String, birthday: Date, gender: Code, zipCode: String, prefecture: Code, address1: String, address2: String, mailAddress: String, mobilePhoneNo: String) {
        self.nickname = nickname
        self.hopeJobPlaceIds = hopeJobPlaceIds
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
    convenience init(dto: GetProfileResponseDTO) {
        var _hopeJobPlaceIds: [Code] = []
        if let codes = dto.hopeJobPlaceIds {
            for code in codes {
                _hopeJobPlaceIds.append(String(code))
            }
        }
        var _birthday: Date!
        if let bufDate = dto.birthday {
            let _tmp = DateHelper.convStrYMD2Date(bufDate)
            _birthday = _tmp
        } else {
            _birthday = Constants.SelectItemsUndefineBirthday//未設定時の誕生日初期値
        }
        self.init(
            nickname: dto.nickname ?? "",
            hopeJobPlaceIds: [],
            familyName: dto.familyName ?? "",
            firstName: dto.firstName ?? "",
            familyNameKana: dto.familyNameKana ?? "",
            firstNameKana: dto.firstNameKana ?? "",
            birthday: _birthday,
            gender: dto.genderId ?? "",
            zipCode: dto.zipCode ?? "",
            prefecture: dto.prefectureId ?? "",
            address1: dto.city ?? "",
            address2: dto.town ?? "",
            mailAddress: dto.email ?? "",
            mobilePhoneNo: dto.phoneNumber ?? "")
        }
    //=== 作成・更新のモデルは、アプリ=>APIなので不要だな ===

    var debugDisp: String {
        let _gender = SelectItemsManager.getCodeDisp(.gender, code: gender)?.debugDisp ?? ""
        let _prefecture = SelectItemsManager.getCodeDisp(.place, code: prefecture)?.debugDisp ?? ""
       return "[\(familyName) \(firstName)（\(familyNameKana) \(firstNameKana)）] [\(_gender)] [\(zipCode)] [\(_prefecture)] [\(address1)] [\(address2)] [\(mailAddress)] [\(mobilePhoneNo)]"
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
        switch self {
        case .zipCode:
            return "ハイフンなしで入力してください"
        default:
            return ""//return "[\(self.itemKey) PlaceHolder]"
        }
    }
    var itemKey: String { return "\(String(describing: type(of: self)))_\(self.rawValue)" } //画面内でUniqになるようなキーを定義（配列利用時は除く）
    
}

//extension ProfileBirthday {
//    var dispYmd: String {
//        return "\(birthdayYear.zeroUme(4))-\(birthdayMonth.zeroUme(2))-\(birthdayDay.zeroUme(2))"
//    }
//}
