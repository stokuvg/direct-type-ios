//
//  ProfileEditVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

class ProfileEditVC: EditableBasicVC {
    var item: MdlItemH? = nil
    var arrData: [EditableItemH] = [] //???EditableItemにする予定

    //編集中の情報
//    var editableModel: EditableModel? //画面編集項目のモデルと管理
    
    @IBOutlet weak var vwHead: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func actBack(_ sender: UIButton) {
        self.dismiss(animated: true) {}
    }
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var tableVW: UITableView!
    @IBOutlet weak var vwFoot: UIView!
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        self.dismiss(animated: true) {}
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //====デザイン適用
        vwHead.backgroundColor = UIColor.init(colorType: .color_main)!
        vwMain.backgroundColor = UIColor.init(colorType: .color_white)!
        vwFoot.backgroundColor = UIColor.init(colorType: .color_main)!
        btnCommit.setTitle(text: "この内容で保存", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)

        //=== テーブル初期化
        self.tableVW.estimatedRowHeight = 100
        self.tableVW.rowHeight = UITableView.automaticDimension
        self.tableVW.register(UINib(nibName: "HEditTextTBCell", bundle: nil), forCellReuseIdentifier: "Cell_HEditTextTBCell")
        self.tableVW.register(UINib(nibName: "HEditDrumTBCell", bundle: nil), forCellReuseIdentifier: "Cell_HEditDrumTBCell")
        self.tableVW.register(UINib(nibName: "HEditZipcodeTBCell", bundle: nil), forCellReuseIdentifier: "Cell_HEditZipcodeTBCell")
        
    }
    
    func initData(_ item: MdlItemH) {
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
    func dispData() {
        guard let _item = item else { return }
        lblTitle.text(text: _item.type.dispTitle, fontType: .font_L, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}


extension ProfileEditVC: UITableViewDataSource, UITableViewDelegate {
    //=== 通常テーブル
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = arrData[indexPath.row]
        
        switch item.editType {
        case .inputText:
            let cell: HEditTextTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditTextTBCell", for: indexPath) as! HEditTextTBCell
            cell.initCell(self, item)
            cell.dispCell()
            return cell
            
        case .inputZipcode:
            let cell: HEditZipcodeTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditZipcodeTBCell", for: indexPath) as! HEditZipcodeTBCell
            cell.initCell(item)
            cell.dispCell()
            return cell

        case .selectDrumYMD:
            let cell: HEditDrumTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditDrumTBCell", for: indexPath) as! HEditDrumTBCell
            cell.initCell(self, item)
            cell.dispCell()
            return cell

        default:
            let cell: HEditTextTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditTextTBCell", for: indexPath) as! HEditTextTBCell
            cell.initCell(self, item)
            cell.dispCell()
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        let item = arrData[indexPath.row]
        print(item.debugDisp)
        if item.editType == .selectDrumYMD {
            print("年月日指定するドラム")
        }

        if let cell = tableView.cellForRow(at: indexPath) as? HEditTextTBCell {
            cell.tfValue.becomeFirstResponder()
        }
    }
}




