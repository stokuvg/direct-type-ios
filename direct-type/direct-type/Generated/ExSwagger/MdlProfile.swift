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
    /** すべての必須項目が設定されているか確認する*/
    var requiredComplete: Bool {
        if familyName.isEmpty { return false }
        if firstName.isEmpty { return false }
        if familyNameKana.isEmpty { return false }
        if firstNameKana.isEmpty { return false }
        if birthday == Constants.SelectItemsUndefineDate { return false }
        if zipCode.isEmpty { return false }
        if prefecture.isEmpty { return false }
        if address1.isEmpty { return false }
        if mailAddress.isEmpty { return false }
        if hopeJobPlaceIds.count == 0 { return false }
        if mobilePhoneNo.isEmpty { return false }
        return true //最後までたどり着ければ、必須項目は定義されているとみなせる
    }
    /** プロフィール完成度(100=100%) */
    var completeness: Int {
        var result = 40 // MdlProfileが存在している時点で40%としている
        
        let existsNameValue = 20
        let existsAddress = 20
        let existsMail = 20
        
        // 名字 + 名前 + 名字カナ + 名前カナ
        if !familyName.isEmpty && !firstName.isEmpty && !familyNameKana.isEmpty && !firstNameKana.isEmpty {
            result += existsNameValue
        }
        
        // 郵便番号 + 都道府県 + 市区町村 + 丁目・番地・建物名など
        // TODO:完成度修正
//        if !zipCode.isEmpty && !prefecture.isEmpty && !address1.isEmpty && !address2.isEmpty {
        if !zipCode.isEmpty && !prefecture.isEmpty && !address1.isEmpty {
            result += existsAddress
        }
        
        if !mailAddress.isEmpty {
            result += existsMail
        }
        
        return result
    }
    
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
        for code in dto.hopeJobPlaceIds {
            _hopeJobPlaceIds.append(String(code))
        }
        var _birthday: Date!
        let _tmp = DateHelper.convStrYMD2Date(dto.birthday)
        _birthday = _tmp
        self.init(
            nickname: dto.nickname,
            hopeJobPlaceIds:_hopeJobPlaceIds,
            familyName: dto.familyName ?? "",
            firstName: dto.firstName ?? "",
            familyNameKana: dto.familyNameKana ?? "",
            firstNameKana: dto.firstNameKana ?? "",
            birthday: _birthday,
            gender: dto.genderId,
            zipCode: dto.zipCode ?? "",
            prefecture: dto.prefectureId ?? "",
            address1: dto.city ?? "",
            address2: dto.town ?? "",
            mailAddress: dto.email ?? "",
            mobilePhoneNo: dto.phoneNumber)
    }
    //=== 作成・更新のモデルは、アプリ=>APIなので不要だな ===
    
    var debugDisp: String {
        let _gender = SelectItemsManager.getCodeDisp(.gender, code: gender)?.debugDisp ?? ""
        let _prefecture = SelectItemsManager.getCodeDisp(.place, code: prefecture)?.debugDisp ?? ""
        return "[\(familyName) \(firstName)（\(familyNameKana) \(firstNameKana)）] [\(_gender)] [\(zipCode)] [\(_prefecture)] [\(address1)] [\(address2)] [\(mailAddress)] [\(hopeJobPlaceIds)] [\(mobilePhoneNo)]"
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
    case hopeJobArea
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
        case .hopeJobArea:      return "希望勤務地"
        case .mobilePhoneNo:    return "帯電話番号（変更不可：認証アカウントと同一）"
        }
    }
    var tsvMaster: SelectItemsManager.TsvMaster {
        switch self {
        case .gender: return .gender
        case .prefecture: return .place
        case .hopeJobArea: return .entryPlace
        default: return .undefine
        }
    }
    var dispUnit: String { //入力項目の単位表示
        switch self {
        default: return ""
        }
    }
    //Placeholder Text
    var placeholder: String {
        switch self {
        case .zipCode:
            return "ハイフンなしで入力してください"
        case .hopeJobArea:
            return "複数選択可"

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
