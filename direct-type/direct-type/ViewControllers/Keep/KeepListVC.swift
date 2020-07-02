//
//  KeepListVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SVProgressHUD
//import SwaggerClient
import TudApi

protocol KeepNoViewDelegate {
    func btnAction()
}

class KeepNoView: UIView {
    
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var textLabel:UILabel!
    @IBOutlet weak var chemistryLabel:UILabel!
    @IBOutlet weak var chemistryBtn:UIButton!
    @IBAction func chemistryBtnAction() {
        self.delegate.btnAction()
    }
    
    var delegate:KeepNoViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel.text(text: "現在キープ中の求人は\nありません。\n本日のおすすめから\nきになる求人を探しましょう", fontType: .font_L, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
        chemistryLabel.text(text: "相性診断を受けると、キープした求人との相性が表示できるようになります。", fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
        
        chemistryBtn.setTitle(text: "相性診断をやってみる", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }
}

class KeepListVC: TmpBasicVC {
    @IBOutlet weak var keepTableView:UITableView!
    
    @IBOutlet weak var keepNoView:KeepNoView!
    
    var lists:MdlKeepList!
    var pageNo:Int = 1
    // AppsFlyerのイベントトラッキング用にオンメモリでキープ求人リストを保有するプロパティ
    // キープされた求人をオンメモリ上で保有しておき、この画面が切り替わった際にイベント送信する
    var storedKeepList: Set<Int> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "キープリスト"
        self.keepTableView.backgroundColor = UIColor.init(colorType: .color_base)
        
        self.keepTableView.registerNib(nibName: "KeepCardCell", idName: "KeepCardCell")
        
        self.makeDummyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getKeepList()
        AnalyticsEventManager.track(type: .viewKeepList)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        storedKeepList.forEach({ _ in
            AnalyticsEventManager.track(type: .keep)
        })
        storedKeepList.removeAll()
    }
    
    private func getKeepList() {
        SVProgressHUD.show()
        lists = MdlKeepList()
        ApiManager.getKeeps(pageNo, isRetry: true)
            .done { result in
                debugLog("ApiManager getKeeps result:\(result.debugDisp)")
                
                self.lists = result
                self.dataDisplay()
        }
        .catch { (error) in
            Log.selectLog(logLevel: .debug, "error:\(error)")
            
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
                case 403:
                    let message:String = "idTokenを取得していません"
                    self.showConfirm(title: "通信失敗", message: message)
                        .done { _ in

                            self.dataDisplay()
                    }.catch { (error) in
                        
                    }.finally {
                }
                default:
                    break
            }
        }
        .finally {
            SVProgressHUD.dismiss()
//            self.dataCheckAction()
        }
    }
    
    private func dataDisplay() {
        Log.selectLog(logLevel: .debug, "KeepListVC dataDisplay start")
        
        Log.selectLog(logLevel: .debug, "self.lists.keepJobs.count:\(self.lists.keepJobs.count)")
        
        if self.lists.keepJobs.count > 0 {
            self.keepNoView.isHidden = true
            self.keepNoView.delegate = nil
            //
            self.keepTableView.delegate = self
            self.keepTableView.dataSource = self
            self.keepTableView.reloadData()
        } else {
            self.keepNoView.isHidden = false
            // 0件
            self.keepNoView.delegate = self
            
//            self.makeDummyData()
        }
    }
    
    private func makeDummyData() {
        
        let _dummy1 = MdlKeepJob.init(jobId: "1234567", jobName: "キープリスト一覧職業名１キープリスト一覧職業名１", pressStartDate: "2020/06/12", pressEndDate: "2020/06/30", mainTitle: "", mainPhotoURL: "https://type.jp/s/img_banner/top_pc_side_number1.jpg", salaryMinCode: 7, salaryMaxCode: 11, isSalaryDisplay: true, companyName: "会社名１")
        let _dummy2 = MdlKeepJob.init(jobId: "234567", jobName: "キープリスト一覧職業名２キープリスト一覧職業名２", pressStartDate: "2020/06/05", pressEndDate: "2020/06/19", mainTitle: "", mainPhotoURL: "https://type.jp/s/img_banner/top_pc_side_number1.jpg", salaryMinCode: 8, salaryMaxCode: 12, isSalaryDisplay: false, companyName: "会社名２")
        let _dummy3 = MdlKeepJob.init(jobId: "34567", jobName: "キープリスト一覧職業名３キープリスト一覧職業名３", pressStartDate: "2020/06/01", pressEndDate: "2020/06/12", mainTitle: "", mainPhotoURL: "", salaryMinCode: 9, salaryMaxCode: 13, isSalaryDisplay: true, companyName: "会社名３")
        
        let _dummyData:[MdlKeepJob] = [
            _dummy1,
            _dummy2,
            _dummy3,
            _dummy1,
            _dummy2,
            _dummy3,
            _dummy1,
            _dummy2,
            _dummy3,
            _dummy1,
            _dummy2,
            _dummy3,
        ]
        self.lists = MdlKeepList.init(hasNext: true, keepJobs: _dummyData)

        self.keepNoView.isHidden = true
        self.keepNoView.delegate = nil
        //
        self.keepTableView.delegate = self
        self.keepTableView.dataSource = self
        self.keepTableView.reloadData()
    }

}
extension KeepListVC: KeepNoViewDelegate {
    func btnAction() {
        Log.selectLog(logLevel: .debug, "navigationController:\(String(describing: self.navigationController))")
        
        let vc = getVC(sbName: "ChemistryStart", vcName: "ChemistryStart") as! ChemistryStart
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension KeepListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let cardData = self.lists.keepJobs[row]
        let jobId = cardData.jobId
        
        let vc = getVC(sbName: "JobOfferDetailVC", vcName: "JobOfferDetailVC") as! JobOfferDetailVC
        vc.jobId = jobId
        vc.transitionSource = .fromKeepList
        
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension KeepListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.keepJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let _keepData = self.lists.keepJobs[row]
        let cell = tableView.loadCell(cellName: "KeepCardCell", indexPath: indexPath) as! KeepCardCell
        cell.tag = row
        cell.delegate = self
        cell.setup(data: _keepData)
        return cell
    }
}

extension KeepListVC: BaseJobCardCellDelegate {
    
    func skipAction(jobId: String) {
    }
    
    func keepAction(tag: Int) {
        storedKeepList.insert(tag)
        Log.selectLog(logLevel: .debug, "KeepListVC delegate keepAction tag:\(tag)")
        let jobCard = self.lists.keepJobs[tag]
        let jobId = jobCard.jobId
        let keepStatus = jobCard.keepStatus
        
        if keepStatus == true {
            ApiManager.sendJobKeep(id: jobId)
                .done { result in
                Log.selectLog(logLevel: .debug, "keep send success")
                    Log.selectLog(logLevel: .debug, "keep成功")
                    
            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "skip send error:\(error)")
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                switch myErr.code {
                case 404:
                    let message: String = ""
                    self.showConfirm(title: "", message: message)
                    .done { _ in
                        Log.selectLog(logLevel: .debug, "対応方法の確認")
                    }
                    .catch { (error) in
                    }
                    .finally {
                    }
                default: break
                }
                self.showError(error)
            }.finally {
                Log.selectLog(logLevel: .debug, "keep send finally")
            }
        } else {
            ApiManager.sendJobDeleteKeep(id: jobId)
                .done { result in
                Log.selectLog(logLevel: .debug, "keep delete success")
                    Log.selectLog(logLevel: .debug, "delete成功")
                    
            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "skip send error:\(error)")
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                switch myErr.code {
                case 404:
                    let message: String = ""
                    self.showConfirm(title: "", message: message)
                    .done { _ in
                        Log.selectLog(logLevel: .debug, "対応方法の確認")
                    }
                    .catch { (error) in
                    }
                    .finally {
                    }
                default: break
                }
                self.showError(error)
            }.finally {
                Log.selectLog(logLevel: .debug, "keep send finally")
            }
        }
    }
    
    
}
