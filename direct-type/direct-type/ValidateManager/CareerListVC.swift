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
    var isFirstFetch: Bool = true
    //===フェッチ抑止処理
    var lastDispUpdateCareerList: Date = Date(timeIntervalSince1970: 0)
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var tableVW: UITableView!
    @IBOutlet weak var vwFootArea: UIView!

    @IBOutlet weak var btnComplete: UIButton!
    @IBAction func actComplete(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //===職歴書カードを追加する
    @IBOutlet weak var btnAddCard: UIButton!
    @IBAction func actAddCard(_ sender: UIButton) {
        self.arrDisp.append(makeNewCareerCard())
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_CareerPreviewVC") as? CareerPreviewVC{
            nvc.initData(self, self.arrData.count, self.arrDisp, true)
            self.navigationController?.pushViewController(nvc, animated: true)
        }
    }
    private func makeNewCareerCard() -> MdlCareerCard {
        let newCareerCard = MdlCareerCard()
        //=== 職務経歴詳細（サクサクの名残あり）
        newCareerCard.contents = ""
        var dispWorknote: [String] = []
        //業種分類
        //case businessType ???
        //業務内容
        var workInfo: String = ""
        workInfo = [Constants.TypeDummyItem1Strings, Constants.TypeDummyStrings].joined(separator: "\n")
        //マネジメント経験
        //case experienceManagement
        var expManagement: String = ""
        expManagement = [Constants.TypeDummyItem2Strings, Constants.TypeDummyStrings].joined(separator: "\n")
        //PCスキル
        //case skillExcel
        //case skillWord
        //case skillPowerPoint
        var skillPC: String = ""
        skillPC = [Constants.TypeDummyItem3Strings, Constants.TypeDummyStrings].joined(separator: "\n")
        //実績
        var workDetail: String = ""
        workDetail = [Constants.TypeDummyItem4Strings, Constants.TypeDummyStrings].joined(separator: "\n")
        //=くっつける
        if !workInfo.isEmpty { dispWorknote.append(workInfo) }
        if !expManagement.isEmpty { dispWorknote.append(expManagement) }
        if !skillPC.isEmpty { dispWorknote.append(skillPC) }
        if !workDetail.isEmpty { dispWorknote.append(workDetail) }
        if newCareerCard.contents.isEmpty {
            newCareerCard.contents = dispWorknote.joined(separator: "\n\n")
        }
        return newCareerCard
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //===デザイン適用
        self.view.backgroundColor = UIColor(colorType: .color_base)
        self.vwMainArea.backgroundColor = UIColor(colorType: .color_base)
        self.vwFootArea.backgroundColor = UIColor(colorType: .color_base)
        self.tableVW.backgroundColor = UIColor(colorType: .color_base)
        btnAddCard.setTitle(text: "追加する", fontType: .font_M, textColor: UIColor(colorType: .color_white)!, alignment: .center)
        btnAddCard.backgroundColor = UIColor(colorType: .color_button)
        btnComplete.setTitle(text: "完了する", fontType: .font_M, textColor: UIColor(colorType: .color_white)!, alignment: .center)
        btnComplete.backgroundColor = UIColor(colorType: .color_button)
        //=== テーブル初期化
        self.tableVW.estimatedRowHeight = 100
        self.tableVW.rowHeight = UITableView.automaticDimension
        self.tableVW.register(UINib(nibName: "CareerCardTBCell", bundle: nil), forCellReuseIdentifier: "Cell_CareerCardTBCell")
    }
    func transferModel(careerList: MdlCareer) {
        self.arrData.removeAll()
        for career in careerList.businessTypes {
            self.arrData.append(career)
        }
        self.lastDispUpdateCareerList = Date()//設定したデータで表示するので
    }
    func dispData() {
        title = "職務経歴書入力"
        //表示用にソートしておく
        arrDisp.removeAll()
        for item in arrData.sorted(by: { (lv, rv) -> Bool in
            lv.workPeriod.startDate > rv.workPeriod.startDate
        }).sorted(by: { (lv, rv) -> Bool in
            lv.workPeriod.endDate > rv.workPeriod.endDate
        }) {
            arrDisp.append(item)
        }
        self.tableVW.reloadData()
        self.chkButtonEnable()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //フェッチ抑止処理
        if ApiManager.needFetch(.careerList, lastDispUpdateCareerList) {
            fetchGetCareerList()
        } else {
            dispData()//画面引き渡しでモデルを渡しているので
        }
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
        let isEnableDelete = (arrData.count > 1) ? true : false
        cell.initCell(self, pos: indexPath.row, item, isEnableDelete)
        cell.dispCell()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        //let item = arrDisp[indexPath.row]
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_CareerPreviewVC") as? CareerPreviewVC{
            nvc.initData(self, indexPath.row, arrDisp, false)
            self.navigationController?.pushViewController(nvc, animated: true)
        }

    }
}
//=== APIフェッチ
extension CareerListVC {
    private func fetchGetCareerList() {
        SVProgressHUD.show(withStatus: "職務経歴書の取得")
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        LogManager.appendApiLog("getCareer", Void(), function: #function, line: #line)
        ApiManager.getCareer(Void(), isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("getCareer", result, function: #function, line: #line)
            self.arrData.removeAll()
            for (_, item) in result.businessTypes.enumerated() {
                self.arrData.append(item)
            }
            self.lastDispUpdateCareerList = Date()//取得したデータで表示更新するので
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("getCareer", error, function: #function, line: #line)
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
            case 404://見つからない場合、空データを適用して画面を表示
                return //エラー表示させないため
            default:
                break
            }
            self.showError(myErr)
        }
        .finally {
            self.dispData()
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
            //===初回画面遷移時の0件誘導
            if self.isFirstFetch && self.arrData.count == 0 {
                self.actAddCard(self.btnAddCard)
            }
            self.isFirstFetch = false
        }
    }
    private func fetchUpdateCareerList() {
        var tempCards: [CareerHistoryDTO] = []
        for (_, item) in arrDisp.enumerated() {
            tempCards.append(CareerHistoryDTO(item))
        }
        let param = CreateCareerRequestDTO(careerHistory: tempCards)
        SVProgressHUD.show(withStatus: "職務経歴書の削除")
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        LogManager.appendApiLog("createCareer", param, function: #function, line: #line)
        ApiManager.createCareer(param, isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("createCareer", result, function: #function, line: #line)
            self.fetchGetCareerList()
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("createCareer", error, function: #function, line: #line)
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            self.showError(myErr)
        }
        .finally {
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
            self.dispData()
        }
    }
}

extension CareerListVC: CareerCardTBCellDelegate {
    func selectCareerCard(num: Int, card: MdlCareerCard) {
    }
    func deleteCareerCard(num: Int, card: MdlCareerCard) {
        let bufTitle: String = "削除確認"
        let bufMessage: String = "職歴書\(num + 1)社目を削除します。\nよろしいですか？"
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
    }
    func cancelCard(num: Int, item: MdlCareerCard) {
    }
}
