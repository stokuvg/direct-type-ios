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
        if validateUpdateProfile() {
            tableVW.reloadData()
            return
        }
        fetchUpdateProfile()
    }
    
    func validateUpdateProfile() -> Bool {
        if Constants.DbgSkipLocalValidate { return false }//[Dbg: ローカルValidationスキップ]
        ValidateManager.dbgDispCurrentItems(editableModel: editableModel) //[Dbg: 状態確認]
        let chkErr = chkValidationErr()
        if chkErr.count > 0 {
            print("＊＊＊　Validationエラー発生: \(chkErr.count)件　＊＊＊")
            var msg: String = ""
            for err in chkErr {
                msg = "\(msg)\(err.value)\n"
            }
            self.showConfirm(title: "Validationエラー (\(chkErr.count)件)", message: msg)
            /* Warning回避 */ .done { _ in } .catch { (error) in } .finally { } //Warning回避
            return true
        } else {
            print("＊＊＊　Validationエラーなし　＊＊＊")
            return false
        }
    }
    
    override func initData() {
        title = "個人プロフィール"
        
        if Constants.DbgOfflineMode {
            self.detail = MdlProfile(familyName: "スマ澤", firstName: "花子", familyNameKana: "スマザワ", firstNameKana: "ハナコ", birthday: DateHelper.convStr2Date("1996-04-01"), gender: "2", zipCode: "1234567", prefecture: "22", address1: "千代田区", address2: "有楽町1-2-3　ネオ新橋ビル", mailAddress: "sumahana@example.com", mobilePhoneNo: Constants.Auth_username)
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
        for items in arrData { editableModel.arrData.append(items.childItems) }//editableModelに登録
        editableModel.chkTableCellAll()//これ実施しておくと、getItemByKeyが利用可能になる
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
        ApiManager.getProfile(Void(), isRetry: true)
        .done { result in
            print(result.debugDisp)
            self.detail = result
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
            case 404:
                let message: String = "本来は初回登録でProfileやResumeの一部データが登録され作成されているはず\n\n代わりにダミーの初期投入をしておく"
                self.showConfirm(title: "特殊対応", message: message)
                .done { _ in
                    self.fetchCreateProfile()
                }
                .catch { (error) in
                }
                .finally {
                }
            default: break
            }

            self.showError(error)
        }
        .finally {
            self.dispData()
            SVProgressHUD.dismiss()
        }
    }
    private func fetchUpdateProfile() {
        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
        let param = UpdateProfileRequestDTO(editableModel.editTempCD)
//        let param = UpdateProfileRequestDTO(familyName: "", firstName: "", familyNameKana: "", firstNameKana: "", birthday: "", genderId: "", zipCode: "", prefectureId: "", city: "", town: "", email: "")
        self.dicGrpValidErrMsg.removeAll()//状態をクリアしておく
        self.dicValidErrMsg.removeAll()//状態をクリアしておく
        SVProgressHUD.show(withStatus: "プロフィール情報の更新")
        ApiManager.updateProfile(param, isRetry: true)
        .done { result in
            self.fetchGetProfile()
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
            case 400:
                var dicGrpError: [MdlItemHTypeKey: [String]] = [:]
                var dicError: [MdlItemHTypeKey: [String]] = [:]
                for valid in myErr.arrValidErrMsg {
                    //===グループ側のエラー
                    switch valid.property { //これで対応する項目に結びつける
                    case "familyName", "firstName", "familyNameKana", "firstNameKana":
                        dicGrpError.addDicArrVal(key: HPreviewItemType.fullnameH2.itemKey, val: valid.constraintsVal)
                    case "birthday", "genderId":
                        dicGrpError.addDicArrVal(key: HPreviewItemType.birthGenderH2.itemKey, val: valid.constraintsVal)
                    case "zipCode", "prefectureId", "city", "town":
                        dicGrpError.addDicArrVal(key: HPreviewItemType.adderssH2.itemKey, val: valid.constraintsVal)
                    case "email":
                        dicGrpError.addDicArrVal(key: HPreviewItemType.emailH2.itemKey, val: valid.constraintsVal)
                    default:
                        print("❤️\t[\(valid.property)]\t[\(valid.constraintsKey)] : [\(valid.constraintsVal)]")
                    }
                    //===個別のエラー
                    switch valid.property { //これで対応する項目に結びつける
                    case "familyName":
                        dicError.addDicArrVal(key: EditItemMdlProfile.familyName.itemKey, val: valid.constraintsVal)
                    case "firstName":
                        dicError.addDicArrVal(key: EditItemMdlProfile.firstName.itemKey, val: valid.constraintsVal)
                    case "familyNameKana":
                        dicError.addDicArrVal(key: EditItemMdlProfile.familyNameKana.itemKey, val: valid.constraintsVal)
                    case "firstNameKana":
                        dicError.addDicArrVal(key: EditItemMdlProfile.firstNameKana.itemKey, val: valid.constraintsVal)
                    case "birthday":
                        dicError.addDicArrVal(key: EditItemMdlProfile.birthday.itemKey, val: valid.constraintsVal)
                    case "genderId":
                        dicError.addDicArrVal(key: EditItemMdlProfile.gender.itemKey, val: valid.constraintsVal)
                    case "zipCode":
                        dicError.addDicArrVal(key: EditItemMdlProfile.zipCode.itemKey, val: valid.constraintsVal)
                    case "prefectureId":
                        dicError.addDicArrVal(key: EditItemMdlProfile.prefecture.itemKey, val: valid.constraintsVal)
                    case "city":
                        dicError.addDicArrVal(key: EditItemMdlProfile.address1.itemKey, val: valid.constraintsVal)
                    case "town":
                        dicError.addDicArrVal(key: EditItemMdlProfile.address2.itemKey, val: valid.constraintsVal)
                    case "email":
                        dicError.addDicArrVal(key: EditItemMdlProfile.mailAddress.itemKey, val: valid.constraintsVal)
                    default:
                        print("❤️\t[\(valid.property)]\t[\(valid.constraintsKey)] : [\(valid.constraintsVal)]")
                    }
                }
                self.dicGrpValidErrMsg = dicGrpError
                self.dicValidErrMsg = dicError
            default:
                self.showError(error)
            }
        }
        .finally {
            self.dispData()
            SVProgressHUD.dismiss()
        }
    }
    private func fetchCreateProfile() {
        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
        let profile = MdlProfile(familyName: "スマ澤", firstName: "花子", familyNameKana: "スマザワ", firstNameKana: "ハナコ", birthday: DateHelper.convStr2Date("1996-04-01"), gender: "2", zipCode: "1234567", prefecture: "22", address1: "千代田区", address2: "有楽町1-2-3　ネオ新橋ビル", mailAddress: "sumahana@example.com", mobilePhoneNo: Constants.Auth_username)
        let param = CreateProfileRequestDTO(profile)
        SVProgressHUD.show(withStatus: "プロフィール情報の作成")
        ApiManager.createProfile(param, isRetry: true)
        .done { result in
            self.fetchGetProfile()
        }
        .catch { (error) in
            self.showError(error)
        }
        .finally {
            self.dispData()
            SVProgressHUD.dismiss()
        }
    }
}


//バリデーションチェックしてみて、問題あったらエラ〜メッセージを定義しちゃっとく
//なんかエラーあったらtrue返しとく
extension ProfilePreviewVC {
    func chkValidationErr() -> [EditableItemKey: String] {
        var dicError: [EditableItemKey: String] = [:]
        //必須チェック
        for itemKey in [
            EditItemMdlProfile.familyName.itemKey,
            EditItemMdlProfile.firstName.itemKey,
//            EditItemMdlProfile.familyNameKana.itemKey,
//            EditItemMdlProfile.firstNameKana.itemKey,
            ]
        {
            if let temp = editableModel.editTempCD[itemKey], let item = editableModel.getItemByKey(itemKey) {
                if temp.isEmpty { dicError[itemKey] = "\(item.dispName) は必須項目です" }
                print("\t変更したもののみチェック: [\(item.debugDisp)]\t[\(temp)]")
            }
        }
        print("\t* editTempCD: \(editableModel.editTempCD))")
        print("\t* dicError: \(dicError))")

        return dicError
    }
}

