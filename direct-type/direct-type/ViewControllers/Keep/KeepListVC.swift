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

final class KeepNoView: UIView {
    @IBOutlet private weak var imageView:UIImageView!
    @IBOutlet private weak var textLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel.text(text: "現在キープ中の求人はありません。\n求人情報からキープしたい\n求人を選んでください", fontType: .font_L, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
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
    var storedKeepList: Set<String> = []
    
    var isAddLoad:Bool = true
    
    var keepChangeCnt:Int = 0
    var jobDetailCheckFlag:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarController?.delegate = self
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getKeepList()
        AnalyticsEventManager.track(type: .viewKeepList)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 丸ポチを消す
        if let tabItems:[UITabBarItem] = self.navigationController?.tabBarController?.tabBar.items {
            let tabItem = tabItems[Constants.TabIndexKeepList]
            tabItem.badgeValue = nil
            if jobDetailCheckFlag == false {
        } else {
                jobDetailCheckFlag = true
            }
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
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        lists = []
        pageNo = 1
        LogManager.appendApiLog("getKeeps", "[pageNo: \(pageNo)]", function: #function, line: #line)
        ApiManager.getKeeps(pageNo, isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("getKeeps", result, function: #function, line: #line)
            debugLog("ApiManager getKeeps result:\(result.debugDisp)")

            self.lists = result.keepJobs
            self.hasNext = result.hasNext
            self.dataDisplay()
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("getKeeps", error, function: #function, line: #line)
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
                    self.showError(myErr)
            }
        }
        .finally {
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        }
    }
    
    func getKeepAddList() {
        SVProgressHUD.show()
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        pageNo += 1
        LogManager.appendApiLog("getKeeps", "[pageNo: \(pageNo)]", function: #function, line: #line)
        ApiManager.getKeeps(pageNo, isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("getKeeps", result, function: #function, line: #line)
            debugLog("ApiManager getKeeps result:\(result.debugDisp)")

            self.lists += result.keepJobs
            self.hasNext = result.hasNext
            self.dataDisplay()
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("getKeeps", error, function: #function, line: #line)
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
                    self.showError(myErr)
            }
        }
        .finally {
            self.isAddLoad = true
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        }
    }

    func dataDisplay() {
        Log.selectLog(logLevel: .debug, "KeepListVC dataDisplay start")
        Log.selectLog(logLevel: .debug, "self.lists.count:\(self.lists.count)")

        if self.lists.count > 0 {
            keepNoView.isHidden = true
            keepTableView.delegate = self
            keepTableView.dataSource = self
            keepTableView.reloadData()
        } else {
            keepNoView.isHidden = false
        }
    }
}


extension KeepListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DeviceHelper.xsMaxCheck() ? 252 : 232
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

    func keepAction(jobId: String, newStatus: Bool) {
        SVProgressHUD.show()
        storedKeepList.insert(jobId)
        Log.selectLog(logLevel: .debug, "KeepListVC delegate keepAction tag:\(jobId)")
        let curKeepStatus = KeepManager.shared.getKeepStatus(jobCardID: jobId)
        
        print(curKeepStatus ? "キープされてる" : "キープされてない")
        print(curKeepStatus ? "キープさせたい" : "キープとりたい")

        if newStatus == true { //キープさせたい
            ApiManager.sendJobKeep(id: jobId)
                .done { result in
                    Log.selectLog(logLevel: .debug, "keep成功")
            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "skip send error:\(error)")
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                self.showError(myErr)
            }.finally {
                Log.selectLog(logLevel: .debug, "keep send finally")
                SVProgressHUD.dismiss()
            }
        } else {
            ApiManager.sendJobDeleteKeep(id: jobId)
                .done { result in
                    Log.selectLog(logLevel: .debug, "delete成功")
            }.catch{ (error) in
                Log.selectLog(logLevel: .debug, "skip send error:\(error)")
                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
                self.showError(myErr)
            }.finally {
                Log.selectLog(logLevel: .debug, "keep send finally")
                SVProgressHUD.dismiss()
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
        }
    }
}
