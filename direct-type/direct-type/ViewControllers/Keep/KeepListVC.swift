//
//  KeepListVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SVProgressHUD
import TudApi

protocol KeepNoViewDelegate: class {
    func btnAction()
}

final class KeepNoView: UIView {
    @IBOutlet private weak var imageView:UIImageView!
    @IBOutlet private weak var textLabel:UILabel!
    @IBOutlet private weak var chemistryLabel:UILabel!
    @IBOutlet private weak var chemistryBtn:UIButton!
    @IBAction private func chemistryBtnAction() {
        delegate?.btnAction()
    }
    
    var delegate: KeepNoViewDelegate?
    var isExistsChemistry = false {
        didSet {
            chemistryLabel.isHidden = isExistsChemistry
            chemistryBtn.isHidden = isExistsChemistry
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel.text(text: "現在キープ中の求人は\nありません。\n本日のおすすめから\nきになる求人を探しましょう", fontType: .font_L, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
        chemistryLabel.text(text: "相性診断を受けると、キープした求人との相性が表示できるようになります。", fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
        chemistryBtn.setTitle(text: "相性診断をやってみる", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }
}

final class KeepListVC: TmpBasicVC {
    @IBOutlet private weak var keepTableView: UITableView!
    @IBOutlet private weak var keepNoView: KeepNoView!
    
    var lists: MdlKeepList!
    var pageNo: Int = 1
    // AppsFlyerのイベントトラッキング用にオンメモリでキープ求人リストを保有するプロパティ
    // キープされた求人をオンメモリ上で保有しておき、この画面が切り替わった際にイベント送信する
    var storedKeepList: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !keepNoView.isExistsChemistry {
            fetchGetChemistryData()
        }
        getKeepList()
        AnalyticsEventManager.track(type: .viewKeepList)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        storedKeepList.forEach({ _ in
            AnalyticsEventManager.track(type: .keep)
        })
        storedKeepList.removeAll()
    }
}

private extension KeepListVC {
    func setup() {
        title = "キープリスト"
        keepTableView.backgroundColor = UIColor.init(colorType: .color_base)
        keepTableView.registerNib(nibName: "KeepCardCell", idName: "KeepCardCell")
    }
    
    func getKeepList() {
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
        }
    }
    
    func dataDisplay() {
        Log.selectLog(logLevel: .debug, "KeepListVC dataDisplay start")
        Log.selectLog(logLevel: .debug, "self.lists.keepJobs.count:\(self.lists.keepJobs.count)")
        
        if self.lists.keepJobs.count > 0 {
            keepNoView.isHidden = true
            keepNoView.delegate = nil
            keepTableView.delegate = self
            keepTableView.dataSource = self
            keepTableView.reloadData()
        } else {
            keepNoView.isHidden = false
            // 0件
            keepNoView.delegate = self
        }
    }
    
    func fetchGetChemistryData() {
        ApiManager.getChemistry(Void(), isRetry: true)
        .done { result -> Void in
            self.keepNoView.isExistsChemistry = true
        }
        .catch { error in }.finally {}
    }
}

extension KeepListVC: KeepNoViewDelegate {
    func btnAction() {
        Log.selectLog(logLevel: .debug, "navigationController:\(String(describing: self.navigationController))")
        
        let vc = getVC(sbName: "ChemistryStart", vcName: "ChemistryStart") as! ChemistryStart
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        hidesBottomBarWhenPushed = false
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
        
        vc.configure(jobId: jobId, isKeep: cardData.keepStatus, transitionSource: .fromKeepList)
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
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
    func skipAction(jobId: String) {}
    
    func keepAction(tag: Int) {
        storedKeepList.insert(tag)
        Log.selectLog(logLevel: .debug, "KeepListVC delegate keepAction tag:\(tag)")
        let jobCard = lists.keepJobs[tag]
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
