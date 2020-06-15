//
//  CareerListVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import TudApi
import SVProgressHUD

class CareerListVC: TmpBasicVC {
    var arrData: [MdlCareerCard] = []
    var arrDisp: [MdlCareerCard] = []
    
    @IBOutlet weak var tableVW: UITableView!

    //===職歴書カードを追加する
    @IBOutlet weak var btnAddCard: UIButton!
    @IBAction func actAddCard(_ sender: UIButton) {
        print(#line, #function, "新規カードを追加する")
        let newCard = MdlCareerCard()
//        self.arrData.append(newCard)
//        dispData()
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_CareerPreviewVC") as? CareerPreviewVC{
            nvc.initData(self, self.arrData.count, newCard)
            self.navigationController?.pushViewController(nvc, animated: true)
        }

    }
//    //===職歴書カードを削除する（これはカードごとにボタンつける？）
//    @IBOutlet weak var btnDelCard: UIButton!
//    @IBAction func actDelCard(_ sender: UIButton) {
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        btnAddCard.setTitle(text: "追加する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnAddCard.backgroundColor = UIColor.init(colorType: .color_button)
//        btnDelCard.setTitle(text: "削除する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
//        btnDelCard.backgroundColor = UIColor.init(colorType: .color_button)

        self.tableVW.backgroundColor = UIColor.init(colorType: .color_base)

        //=== テーブル初期化
        self.tableVW.estimatedRowHeight = 100
        self.tableVW.rowHeight = UITableView.automaticDimension
        self.tableVW.register(UINib(nibName: "CareerCardTBCell", bundle: nil), forCellReuseIdentifier: "Cell_CareerCardTBCell")
        initData()
        chkButtonEnable()//ボタン死活チェック
    }
    func initData() {
    }
    func dispData() {
        title = "職歴書カード一覧"
        //表示用にソートしておく
        arrDisp.removeAll()
        for item in arrData.sorted(by: { (lv, rv) -> Bool in
            lv.workPeriod.startDate > rv.workPeriod.startDate
        }) {
            arrDisp.append(item)
        }
        tableVW.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispData()
        chkButtonEnable()//ボタン死活チェック
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchGetCareerList()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    func chkButtonEnable() {
        if arrDisp.count <= 5 { //5つ以下なら追加可能
            btnAddCard.isEnabled = true
        } else {
            btnAddCard.isEnabled = false
        }
//        if arrDisp.count >= 2 { //2つ以上なら削除可能
//            btnDelCard.isEnabled = true
//        } else {
//            btnDelCard.isEnabled = false
//        }
    }
}

extension CareerListVC: UITableViewDataSource, UITableViewDelegate {
    //=== 通常テーブル
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDisp.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = arrDisp[indexPath.row]
        let cell: CareerCardTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_CareerCardTBCell", for: indexPath) as! CareerCardTBCell
        cell.initCell(self, pos: indexPath.row, item)
        cell.dispCell()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        let item = arrDisp[indexPath.row]

        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_CareerPreviewVC") as? CareerPreviewVC{
            nvc.initData(self, indexPath.row, item)
            self.navigationController?.pushViewController(nvc, animated: true)
        }

    }
}

extension CareerListVC: CareerCardTBCellDelegate {
    func selectCareerCard(num: Int, card: MdlCareerCard) {
        print(#line, #function, "#\(num): [\(card.debugDisp)]が選択されました")
    }
    func deleteCareerCard(num: Int, card: MdlCareerCard) {
        print(#line, #function, "#\(num): [\(card.debugDisp)]が削除指定されました")
    }

}


//=== APIフェッチ
extension CareerListVC {
    private func fetchGetCareerList() {
        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
        SVProgressHUD.show(withStatus: "職務経歴書情報の取得")
        ApiManager.getCareer(Void(), isRetry: true)
        .done { result in
            self.arrData.removeAll()
            for (num, item) in result.businessTypes.enumerated() {
                self.arrData.append(item)
            }
        }
        .catch { (error) in
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(error)
        }
        .finally {
            self.dispData()
            SVProgressHUD.dismiss()
        }
    }
}



extension CareerListVC: CareerListProtocol {
    func changedCard(num: Int, item: MdlCareerCard) {
        print(#line, #function, "変更あった")
    }
    
    func cancelCard(num: Int, item: MdlCareerCard) {
        print(#line, #function, "変更なし")
    }
    
}
