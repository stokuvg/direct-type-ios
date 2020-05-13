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
class ProfilePreviewVC: TmpBasicVC {
    var detail: MdlProfile? = nil
    var arrData: [MdlItemH] = []

    @IBOutlet weak var tableVW: UITableView!
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        print(#line, #function, detail?.debugDisp)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "個人プロフィール"
        btnCommit.setTitle(text: "完了する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)

        //=== テーブル初期化
        self.tableVW.estimatedRowHeight = 100
        self.tableVW.rowHeight = UITableView.automaticDimension
        self.tableVW.register(UINib(nibName: "HPreviewTBCell", bundle: nil), forCellReuseIdentifier: "Cell_HPreviewTBCell")
        initData()
    }
    func initData() {
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
        arrData.append(MdlItemH(.fullname, "\(bufFullname)（\(bufFullnameKana)）", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemProfile.familyName, val: _detail.familyName),
            EditableItemH(type: .inputText, editItem: EditItemProfile.firstName, val: _detail.firstName),
            EditableItemH(type: .inputText, editItem: EditItemProfile.familyNameKana, val: _detail.familyNameKana),
            EditableItemH(type: .inputText, editItem: EditItemProfile.firstNameKana, val: _detail.firstNameKana),
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
        arrData.append(MdlItemH(.birthGender, "\(bufBirthday)（\(bufAge)） / \(bufGender)", childItems: [
            EditableItemH(type: .selectDrumYMD, editItem: EditItemProfile.birthday, val: "\(_detail.birthday.dispYmd())"),
            EditableItemH(type: .selectSingle, editItem: EditItemProfile.gender, val: "\(_detail.gender)"),
        ]))

        //===６．住所
        //    ・未記入時は「未入力（必須）」と表示
        //    ・郵便番号の表記形式は「〒{郵便番号上3桁}-{郵便番号下桁}」
        //    ・都道府県以下の表示形式は郵便番号から改行して表示
        //        「{都道府県}{市区町村}{丁目・番地・建物名など}」
        let bufZipCode: String = "\(_detail.zipCode)"
        let bufPrefecture: String = SelectItemsManager.getCodeDisp(.place, code: _detail.prefecture)?.disp ?? ""
        let bufAddress: String = "\(bufPrefecture)\(_detail.address1)\(_detail.address2)"
        arrData.append(MdlItemH(.adderss, "〒\(bufZipCode)\n\(bufAddress)", childItems: [
            EditableItemH(type: .inputZipcode, editItem: EditItemProfile.zipCode, val: _detail.zipCode),
            EditableItemH(type: .inputText, editItem: EditItemProfile.prefecture, val: bufPrefecture),
            EditableItemH(type: .inputText, editItem: EditItemProfile.address1, val: _detail.address1),
            EditableItemH(type: .inputText, editItem: EditItemProfile.address2, val: _detail.address2),
        ]))

        //===７．メールアドレス
        //    ・未記入時は「未入力（必須）」と表示
        let bufMailAddress: String = _detail.mailAddress
        arrData.append(MdlItemH(.email, "\(bufMailAddress)", childItems: [
            EditableItemH(type: .inputText, editItem: EditItemProfile.mailAddress, val: _detail.mailAddress),
        ]))

        //===８．携帯電話番号
        //    ・認証電話番号を表示
        //    ・未入力は想定しない
        //    ・タップできない
        //    ・注意文「※電話番号の変更は「設定」→「アカウント変更」よりお願いします」を表示
        //    注意文の文字種：font-SS、文字色：color-parts-grau
        let bufMobilePhoneNo: String = _detail.mobilePhoneNo
        let bufMobilePhoneNoNotice: String = "＊電話番号の変更は「設定」→「アカウント変更」よりお願いします"
        arrData.append(MdlItemH(.mobilephone, "\(bufMobilePhoneNo)", "\(bufMobilePhoneNoNotice)", readonly: true, childItems: [
            EditableItemH(type: .inputText, editItem: EditItemProfile.mobilePhoneNo, val: _detail.mobilePhoneNo),
        ]))
    }
}


extension ProfilePreviewVC: UITableViewDataSource, UITableViewDelegate {
    //=== 通常テーブル
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = arrData[indexPath.row]
        let cell: HPreviewTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HPreviewTBCell", for: indexPath) as! HPreviewTBCell
        cell.initCell(item)
        cell.dispCell()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        let item = arrData[indexPath.row]
        let storyboard = UIStoryboard(name: "Edit", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_ProfileEditVC") as? ProfileEditVC{
            nvc.initData(item)
            //遷移アニメーション関連
            nvc.modalTransitionStyle = .coverVertical
            self.present(nvc, animated: true) {
            }
//            self.navigationController?.pushViewController(nvc, animated: true)

        }
    }
}


