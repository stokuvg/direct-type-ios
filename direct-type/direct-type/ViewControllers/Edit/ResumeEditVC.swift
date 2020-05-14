//
//  ResumeEditVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class ResumeEditVC: EditableTableBasicVC {

    override func initData(_ item: MdlItemH) {
        self.item = item
        //=== 編集アイテムの設定
        guard let _item = self.item else { return }
        for child in _item.childItems {
            arrData.append(child)
        }
        //ダミーデータ投入しておく
        let profile: Profile =
        Profile(familyName: "スマ澤", firstName: "太郎", familyNameKana: "スマザワ", firstNameKana: "タロウ",
                birthday: ProfileBirthday(birthdayYear: 1996, birthdayMonth: 4, birthdayDay: 28),
                gender: 1, zipCode: "1234567", prefecture: 13, address1: "港区赤坂3-21-20", address2: "赤坂ロングロングローングビーチビル2F",
                mailAddress: "hoge@example.co.jp",
                mobilePhoneNo: "09012345678" )
        //=== 項目の設定と表示　＊[H-2]プロフィール画面
        editableModel = EditableModel()
        editableModel?.initItemEditable(.profile, (MdlProfile(dto: profile)))
    }

}
