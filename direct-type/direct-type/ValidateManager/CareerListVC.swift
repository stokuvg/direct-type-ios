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
        let newCard = MdlCareerCard()
        newCard.companyName = "ダミー企業名"
        newCard.employeesCount = "\(arc4random_uniform(999))"
        newCard.employmentType = "\(arc4random_uniform(6))"
        newCard.salary = "\(arc4random_uniform(6) + 6)"
        newCard.workPeriod = MdlCareerCardWorkPeriod(
            startDate: Constants.SelectItemsUndefineDate,
            endDate: Constants.SelectItemsUndefineDate)
        newCard.contents = String(repeating: "テキスト", count: Int(arc4random_uniform(100)))
        self.arrDisp.append(newCard)
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_CareerPreviewVC") as? CareerPreviewVC{
            nvc.initData(self, self.arrData.count, self.arrDisp)
            self.navigationController?.pushViewController(nvc, animated: true)
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        btnAddCard.setTitle(text: "追加する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnAddCard.backgroundColor = UIColor.init(colorType: .color_button)
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
        arrDisp = arrData
//        for item in arrData.sorted(by: { (lv, rv) -> Bool in
//            lv.workPeriod.startDate > rv.workPeriod.startDate
//        }) {
//            arrDisp.append(item)
//        }
        tableVW.reloadData()
        chkButtonEnable()
        
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
        if arrData.count < Constants.CareerCardMax { //10以下なら追加可能
            btnAddCard.isEnabled = true
        } else {
            btnAddCard.isEnabled = false
            
        }
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
            nvc.initData(self, indexPath.row, arrDisp)
            self.navigationController?.pushViewController(nvc, animated: true)
        }

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
    private func fetchUpdateCareerList() {
        if Constants.DbgOfflineMode { return }//[Dbg: フェッチ割愛]
        var tempCards: [CareerHistoryDTO] = []
        for (num, item) in arrDisp.enumerated() {
            tempCards.append(CareerHistoryDTO(item))
        }
        let param = CreateCareerRequestDTO(careerHistory: tempCards)
        SVProgressHUD.show(withStatus: "職務経歴書情報の削除")
        ApiManager.createCareer(param, isRetry: true)
        .done { result in
            self.fetchGetCareerList()
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

extension CareerListVC: CareerCardTBCellDelegate {
    func selectCareerCard(num: Int, card: MdlCareerCard) {
        print(#line, #function, "#\(num): [\(card.debugDisp)]が選択されました")
    }
    func deleteCareerCard(num: Int, card: MdlCareerCard) {
        print(#line, #function, "#\(num): [\(card.debugDisp)]が削除指定されました")
        let bufTitle: String = "削除確認"
        let bufMessage: String = "履歴書カード #\(num + 1) を削除します。\nよろしいですか？"
        showConfirm(title: bufTitle, message: bufMessage)
        .done { _ in
            self.arrDisp.remove(at: num)
            self.fetchUpdateCareerList()
        }
        .catch { _ in
        }
        .finally {
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
