//
//  ProfilePreviewVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

//===[H-2]「個人プロフィール確認」
class ProfilePreviewVC: PreviewBaseVC {
    var detail: MdlProfile? = nil
    
    override func initData() {
        //ダミーデータ投入しておく
        let profile: Profile =
        Profile(familyName: "スマ澤", firstName: "太郎", familyNameKana: "スマザワ", firstNameKana: "タロウ",
                birthday: ProfileBirthday(birthdayYear: 1996, birthdayMonth: 4, birthdayDay: 28),
                gender: 1, zipCode: "1234567", prefecture: 13, address1: "港区赤坂3-21-20", address2: "赤坂ロングロングローングビーチビル2F",
                mailAddress: "hoge@example.co.jp",
                mobilePhoneNo: "09012345678" )
        detail = MdlProfile(dto: profile)
        //========
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        guard let _detail = detail else { return }

        //===４．氏名（必須）
        //    ・未記入時は「未入力（必須）」と表示
        //    ・表記形式は「{氏} {名} （{氏(カナ)} {名(カナ)}」
        let bufFullname: String = "\(_detail.familyName) \(_detail.firstName)"
        let bufFullnameKana: String = "\(_detail.familyNameKana) \(_detail.firstNameKana)"
        arrData.append(MdlItemH(.fullnameH2, "\(bufFullname)（\(bufFullnameKana)）", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlProfile.familyName, val: _detail.familyName),
            EditableItemH(type: .inputText, editItem: EditItemMdlProfile.firstName, val: _detail.firstName),
            EditableItemH(type: .inputText, editItem: EditItemMdlProfile.familyNameKana, val: _detail.familyNameKana),
            EditableItemH(type: .inputText, editItem: EditItemMdlProfile.firstNameKana, val: _detail.firstNameKana),
        ]))
        ////===５．生年月日・性別（必須）
        //    ・生年月日は初回入力項目なので未入力は想定しない
        //    ・性別は初回入力時「選択しない」の場合「--」
        //    ・表記形式は「{生年}年{生月}月{生日} ({年齢}歳) / {性別}」
        let tmpBirthday: String = _detail.birthday.dispYmd()
        let date = DateHelper.convStr2Date(tmpBirthday)
        let bufBirthday: String = date.dispYmdJP()
        let bufAge: String = "\(date.age)歳"
        let bufGender: String = SelectItemsManager.getCodeDisp(.gender, code: _detail.gender)?.disp ?? "--"
        arrData.append(MdlItemH(.birthGenderH2, "\(bufBirthday)（\(bufAge)） / \(bufGender)", childItems: [
            EditableItemH(type: .selectDrumYMD, editItem: EditItemMdlProfile.birthday, val: "\(_detail.birthday.dispYmd())"),
            EditableItemH(type: .selectSingle, editItem: EditItemMdlProfile.gender, val: "\(_detail.gender)"),

        EditableItemH(type: .selectDrum, editItem: EditItemMdlProfile.prefecture, val: ""),
        EditableItemH(type: .selectMulti, editItem: EditItemMdlProfile.prefecture, val: ""),
        EditableItemH(type: .selectSingle, editItem: EditItemMdlProfile.prefecture, val: ""),

        EditableItemH(type: .selectSpecisl, editItem: EditItemMdlProfile.prefecture, val: ""),
        ]))

        //===６．住所
        //    ・未記入時は「未入力（必須）」と表示
        //    ・郵便番号の表記形式は「〒{郵便番号上3桁}-{郵便番号下桁}」
        //    ・都道府県以下の表示形式は郵便番号から改行して表示
        //        「{都道府県}{市区町村}{丁目・番地・建物名など}」
        let bufZipCode: String = "\(_detail.zipCode)"
        let bufPrefecture: String = SelectItemsManager.getCodeDisp(.place, code: _detail.prefecture)?.disp ?? ""
        let bufAddress: String = "\(bufPrefecture)\(_detail.address1)\(_detail.address2)"
        arrData.append(MdlItemH(.adderssH2, "〒\(bufZipCode)\n\(bufAddress)", childItems: [
            EditableItemH(type: .inputZipcode, editItem: EditItemMdlProfile.zipCode, val: _detail.zipCode),
            EditableItemH(type: .selectSingle, editItem: EditItemMdlProfile.prefecture, val: bufPrefecture),
            EditableItemH(type: .inputText, editItem: EditItemMdlProfile.address1, val: _detail.address1),
            EditableItemH(type: .inputText, editItem: EditItemMdlProfile.address2, val: _detail.address2),
        ]))

        //===７．メールアドレス
        //    ・未記入時は「未入力（必須）」と表示
        let bufMailAddress: String = _detail.mailAddress
        arrData.append(MdlItemH(.emailH2, "\(bufMailAddress)", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlProfile.mailAddress, val: _detail.mailAddress),
        ]))

        //===８．携帯電話番号
        //    ・認証電話番号を表示
        //    ・未入力は想定しない
        //    ・タップできない
        //    ・注意文「※電話番号の変更は「設定」→「アカウント変更」よりお願いします」を表示
        //    注意文の文字種：font-SS、文字色：color-parts-grau
        let bufMobilePhoneNo: String = _detail.mobilePhoneNo
        let bufMobilePhoneNoNotice: String = "＊電話番号の変更は「設定」→「アカウント変更」よりお願いします"
        arrData.append(MdlItemH(.mobilephoneH2, "\(bufMobilePhoneNo)", "\(bufMobilePhoneNoNotice)", readonly: true, childItems: [
            EditableItemH(type: .inputText, editItem: EditItemMdlProfile.mobilePhoneNo, val: _detail.mobilePhoneNo),
        ]))
    }
    override func dispData() {
        title = "個人プロフィール"
    }
}
