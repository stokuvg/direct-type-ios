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

        //=== テーブル初期化
        self.tableVW.estimatedRowHeight = 100
        self.tableVW.rowHeight = UITableView.automaticDimension
        self.tableVW.register(UINib(nibName: "HPreviewTBCell", bundle: nil), forCellReuseIdentifier: "Cell_HPreviewTBCell")

        initData()
    }
    func initData() {
        
        let profile: Profile =
        Profile(familyName: "スマ澤", firstName: "太郎", familyNameKana: "スマザワ", firstNameKana: "タロウ", birthday: ProfileBirthday(birthdayYear: 1996, birthdayMonth: 5, birthdayDay: 8), gender: 1, zipCode: "123-4567", prefecture: 13, address1: "港区赤坂3-21-20", address2: "赤坂ロングロングローングビーチビル2F", mailAddress: "hoge@example.co.jp", mobilePhoneNo: "09012345678")
        detail = MdlProfile(dto: profile)
        title = "個人プロフィール"
        btnCommit.setTitle(text: "完了する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
        
        //項目を設定する（複数項目を繋いで表示するやつをどう扱おうか。編集と切り分けて、個別設定で妥協する？！）
        guard let _detail = detail else { return }
        arrData.append(MdlItemH("氏名", "\(_detail.familyName) \(_detail.firstName)（\(_detail.familyNameKana) \(_detail.firstNameKana)）"))
        arrData.append(MdlItemH("生年月日・性別", "\(_detail.birthday.disp)（23歳） / \(_detail.gender)"))
        arrData.append(MdlItemH("住所", "〒\(_detail.zipCode)\n\(_detail.prefecture)都道府県\(_detail.address1)\(_detail.address2)"))
        arrData.append(MdlItemH("メールアドレス", "\(_detail.mailAddress)"))
        arrData.append(MdlItemH("アカウント（認証済み電話番号）", "\(_detail.mobilePhoneNo)", notice: "＊電話番号の変更は「設定」→「アカウント変更」よりお願いします"))
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
        print(item.debugDisp)
    }
}

