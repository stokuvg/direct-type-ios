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

    var lists: [MdlKeepJob] = []
    var pageNo: Int = 1
    var hasNext:Bool = false
    // AppsFlyerのイベントトラッキング用にオンメモリでキープ求人リストを保有するプロパティ
    // キープされた求人をオンメモリ上で保有しておき、この画面が切り替わった際にイベント送信する
    var storedKeepList: Set<Int> = []
    
    var isAddLoad:Bool = true
    
    var keepDatas:[[String:Any]] = []
    var keepChangeCnt:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarController?.delegate = self
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 丸ポチを消す
        if let tabItems:[UITabBarItem] = self.navigationController?.tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            tabItem.badgeValue = nil
        }
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
        lists = []
        pageNo = 1
        ApiManager.getKeeps(pageNo, isRetry: true)
            .done { result in
                debugLog("ApiManager getKeeps result:\(result.debugDisp)")

                self.lists = result.keepJobs
                self.hasNext = result.hasNext
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
    
    func getKeepAddList() {
        SVProgressHUD.show()
        pageNo += 1
        ApiManager.getKeeps(pageNo, isRetry: true)
            .done { result in
                debugLog("ApiManager getKeeps result:\(result.debugDisp)")

                self.lists += result.keepJobs
                self.hasNext = result.hasNext
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
            self.isAddLoad = true
            SVProgressHUD.dismiss()
        }
    }

    func dataDisplay() {
        Log.selectLog(logLevel: .debug, "KeepListVC dataDisplay start")
        Log.selectLog(logLevel: .debug, "self.lists.count:\(self.lists.count)")

        if self.lists.count > 0 {
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
    
    func keepDataAddRemoveCheck(checkData:[String:Any]) {
        
        if keepDatas.count > 0 {
            
            for i in 0..<keepDatas.count {
                var _data = keepDatas[i]
                
                let checkId = checkData["jobId"] as! String
                let checkStatus = checkData["keepStatus"] as! Bool
                
                let _dataId = _data["jobId"] as! String
                if checkId == _dataId {
                    _data["keepStatus"] = checkStatus
                    keepDatas[i] = _data
                } else {
                    keepDatas.append(checkData)
                }
            }
        } else {
            keepDatas.append(checkData)
        }
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
        
        if DeviceHelper.xsMaxCheck() {
            return 252.0
//            return UITableView.automaticDimension
        } else {
            return 232.0
//            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let cardData = self.lists[row]
        let jobId = cardData.jobId
        let vc = getVC(sbName: "JobOfferDetailVC", vcName: "JobOfferDetailVC") as! JobOfferDetailVC

        vc.configure(jobId: jobId, isKeep: cardData.keepStatus, routeFrom: .fromKeepList)
        vc.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(vc, animated: true)
    }
}

extension KeepListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let _keepData = self.lists[row]
        let cell = tableView.loadCell(cellName: "KeepCardCell", indexPath: indexPath) as! KeepCardCell
        cell.tag = row
        cell.delegate = self
        cell.setup(data: _keepData)
        return cell
    }
}

extension KeepListVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.keepTableView.contentOffset.y + self.keepTableView.frame.size.height > self.keepTableView.contentSize.height && self.keepTableView.isDragging && isAddLoad == true && self.hasNext {
            self.isAddLoad = false
            self.getKeepAddList()
        }
    }
}

extension KeepListVC: BaseJobCardCellDelegate {
    func skipAction(jobId: String) {}

    func keepAction(tag: Int) {
        storedKeepList.insert(tag)
        Log.selectLog(logLevel: .debug, "KeepListVC delegate keepAction tag:\(tag)")
        let jobCard = lists[tag]
        let jobId = jobCard.jobId
        let keepStatus = !jobCard.keepStatus
        Log.selectLog(logLevel: .debug, "jobId:\(jobId)")
        Log.selectLog(logLevel: .debug, "keepStatus:\(keepStatus)")
        let keepData:[String:Any] = ["jobId":jobId,"keepStatus":keepStatus]

        if keepStatus == true {
            ApiManager.sendJobKeep(id: jobId)
                .done { result in
                    Log.selectLog(logLevel: .debug, "keep send success")
                    Log.selectLog(logLevel: .debug, "keep成功")

            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "skip send error:\(error)")

                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                self.showError(myErr)
            }.finally {
                Log.selectLog(logLevel: .debug, "keep send finally")
                jobCard.keepStatus = keepStatus
                self.lists[tag] = jobCard
                self.keepDataAddRemoveCheck(checkData:keepData)
            }
        } else {
            ApiManager.sendJobDeleteKeep(id: jobId)
                .done { result in
                    Log.selectLog(logLevel: .debug, "keep delete success")
                    Log.selectLog(logLevel: .debug, "delete成功")

            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "skip send error:\(error)")

                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                self.showError(myErr)
            }.finally {
                Log.selectLog(logLevel: .debug, "keep send finally")
                jobCard.keepStatus = keepStatus
                self.lists[tag] = jobCard
                self.keepDataAddRemoveCheck(checkData:keepData)
            }
        }
    }
}

extension KeepListVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        Log.selectLog(logLevel: .debug, "KeepListVC didSelect start")

        if let vcs = tabBarController.viewControllers {
            Log.selectLog(logLevel: .debug, "vcs:\(vcs)")
            
            let firstNavi = vcs.first as! BaseNaviController
            let firstVC = firstNavi.visibleViewController as! HomeVC
            
            Log.selectLog(logLevel: .debug, "firstVC:\(String(describing: firstVC))")
            
//            let homeVC = vcs[0] as! HomeVC
//            Log.selectLog(logLevel: .debug, "viewController:\(viewController)")
            if tabBarController.selectedIndex == 0 {
                Log.selectLog(logLevel: .debug, "切り替えた画面がHomeVC")
                Log.selectLog(logLevel: .debug, "keepDatas:\(keepDatas)")
                firstVC.changeKeepDatas = keepDatas
            } else {
                firstVC.changeKeepDatas = []
            }
        }
    }
}
