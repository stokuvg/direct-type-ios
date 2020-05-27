//
//  ProfilePreviewVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
//import SwaggerClient
import TudApi
import SVProgressHUD

//===[H-2]「個人プロフィール確認」
class ProfilePreviewVC: PreviewBaseVC {
    var detail: MdlProfile? = nil
    
    override func actCommit(_ sender: UIButton) {
        print(#line, #function, "ボタン押下でAPIフェッチ確認")
        tableVW.reloadData()
//        //===変更内容の確認
//        print(#line, String(repeating: "=", count: 44))
//        for (y, items) in editableModel.arrData.enumerated() {
//            for (x, _item) in items.enumerated() {
//                let (isChange, editTemp) = editableModel.makeTempItem(_item)
//                let item: EditableItemH! = isChange ? editTemp : _item
//                if isChange {
//                    print("\t(\(y)-\(x)) ✍️ [\(item.debugDisp)]")
//                } else {
//                    print("\t(\(y)-\(x)) 　 [\(item.debugDisp)]")
//                }
//            }
//        }
//        print(#line, String(repeating: "=", count: 44))
        fetchUpdateProfile()
    }
    override func initData() {
        title = "個人プロフィール"
        
        if Constants.DbgOfflineMode {
            self.detail = MdlProfile(familyName: "familyName", firstName: "firstName", familyNameKana: "familyNameKana", firstNameKana: "firstNameKana", birthday: DateHelper.convStr2Date("1900-01-01"), gender: "gender", zipCode: "zipCode", prefecture: "prefecture", address1: "address1", address2: "address2", mailAddress: "mailAddress", mobilePhoneNo: "mobilePhoneNo")
        }
    }
    
    override func dispData() {
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        guard let _detail = detail else { return }
        self.arrData.removeAll()//いったん全件を削除しておく
        editableModel.arrData.removeAll()//こちらで管理させる？！
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
            EditableItemH(type: .selectSingle, editItem: EditItemMdlProfile.prefecture, val: _detail.prefecture),
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
        //=== editableModelで管理させる
        editableModel.arrData.removeAll()
        for items in arrData { editableModel.arrData.append(items.childItems) }
//        print(#line, String(repeating: "=", count: 44))
//        print(editableModel.arrData.debugDescription)
//        for (y, items) in editableModel.arrData.enumerated() {
//            for (x, item) in items.enumerated() {
//                print("\t(\(y)-\(x)) [\(item.debugDisp)]")
//            }
//        }
//        print(#line, String(repeating: "=", count: 44))
        tableVW.reloadData()//描画しなおし
    }
    
    //========================================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchGetProfile()
    }
}

//=== APIフェッチ
extension ProfilePreviewVC {

    private func fetchGetProfile() {
        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
        SVProgressHUD.show(withStatus: "プロフィール情報の取得")
        AuthManager.needAuth(true)
        ProfileAPI.profileControllerGet()
        .done { resp in
            let model = MdlProfile(dto: resp)
            print(model.debugDisp)
            self.detail = model
        }
        .catch { (error) in
            self.showError(error)
        }
        .finally {
            self.dispData()
            SVProgressHUD.dismiss()
        }
    }
//    private func fetchCreateProfile() {
//        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
//        let param: CreateProfileRequestDTO = CreateProfileRequestDTO(familyName: "試験", firstName: "太郎", familyNameKana: "シケン", firstNameKana: "タロウ", birthday: "1995-11-01", genderId: "2", zipCode: "1234567", prefectureId: "13", city: "有楽町1-1-1", town: "東御苑", email: "test@example.com")
//        AuthManager.needAuth(true)
//        ProfileAPI.profileControllerCreate(body: param)
//        .done { resp in
//            print(resp)
//        }
//        .catch { (error) in
//            print(error.localizedDescription)
//        }
//        .finally {
//            self.fetchGetProfile()
//        }
//    }
    private func fetchUpdateProfile() {
        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
        var param = UpdateProfileRequestDTO(familyName: nil, firstName: nil, familyNameKana: nil, firstNameKana: nil, birthday: nil, genderId: nil, zipCode: nil, prefectureId: nil, city: nil, town: nil, email: nil)
        for (key, val) in editableModel.editTempCD {
            switch key {
            case EditItemMdlProfile.familyName.itemKey: param.familyName = val
            case EditItemMdlProfile.firstName.itemKey: param.firstName = val
            case EditItemMdlProfile.familyNameKana.itemKey: param.familyNameKana = val
            case EditItemMdlProfile.firstNameKana.itemKey: param.firstNameKana = val
            case EditItemMdlProfile.birthday.itemKey: param.birthday = val
            case EditItemMdlProfile.gender.itemKey: param.genderId = val
            case EditItemMdlProfile.zipCode.itemKey: param.zipCode = val
            case EditItemMdlProfile.prefecture.itemKey: param.prefectureId = val
            case EditItemMdlProfile.address1.itemKey: param.city = val
            case EditItemMdlProfile.address2.itemKey: param.town = val
            case EditItemMdlProfile.mailAddress.itemKey: param.email = val
            default: break
            }
        }
        AuthManager.needAuth(true)
        ProfileAPI.profileControllerUpdate(body: param)
        .done { resp in
            print(resp)
        }
        .catch { (error) in
            print(error.localizedDescription)
            if let _error = error as? NSError {
                print(#line, "NSError", _error.localizedDescription)
                print(#line, "[domain: \(_error.domain)]")
                print(#line, "[code: \(_error.code)]")
                print(#line, "[userInfo: \(_error.userInfo)]")
            }
            if let _error = error as? ErrorResponse {
                switch _error {
                case .error(let code, let data, let error):
                    if let _data = data {
                        let jsonStr = String(bytes: _data, encoding: .utf8)!
                        print("JSONに変換して表示: [\(jsonStr)]", error.localizedDescription)
                        self.showConfirm(title: "エラー \(code)", message: jsonStr, onlyOK: true)
                        
                        print("\n\n\(jsonStr)\n\n\n")
                    }
                }
            }
        }
        .finally {
            self.fetchGetProfile()
        }
    }


}
