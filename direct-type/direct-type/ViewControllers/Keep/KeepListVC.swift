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
    var isAddLoad:Bool = true
    
    var tableWidth:CGFloat = 0.0

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
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableWidth = self.view.frame.size.width
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
            keepTableView.delegate = nil
            keepTableView.dataSource = nil
            keepNoView.isHidden = false
        }
    }
}


extension KeepListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        Log.selectLog(logLevel: .debug, "KeepListVC heightForRowAt start")
//        return DeviceHelper.xsMaxCheck() ? 252 : 232
        
        let spaceWidth:CGFloat = 17.0
        let stackSpaceWidth:CGFloat = 20.0
        
        let listTableWidth = self.keepTableView.frame.size.width
        
        let jobWidth = listTableWidth - (spaceWidth * 2) - (stackSpaceWidth * 2)
//        Log.selectLog(logLevel: .debug, "jobWidth:\(jobWidth)")
        
        var cellHeight:CGFloat
        
        let row = indexPath.row
        guard row < self.lists.count else { return 0 } //クラッシュ回避
        let jobData = self.lists[indexPath.row]
        let jobName = jobData.jobName
//        Log.selectLog(logLevel: .debug, "jobName:\(jobName)")
        let textSize = CGFloat(jobName.count) * UIFont.init(fontType: .C_font_M)!.pointSize
//        Log.selectLog(logLevel: .debug, "textSize:\(textSize)")
        
        var checkTextSize:CGFloat = 0.0
        if jobName.isAllHalfWidthCharacter() {
            checkTextSize = textSize / 2
        } else {
            checkTextSize = textSize
        }

        if checkTextSize <= jobWidth {
            cellHeight = 242.0
        } else {
            cellHeight = 262.0
        }
        
        if DeviceHelper.xsMaxCheck() {
            cellHeight += 20.0
        }
        return cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        guard row < self.lists.count else { return } //クラッシュ回避
        let cardData = self.lists[row]
        let jobId = cardData.jobId
        let vc = getVC(sbName: "JobOfferDetailVC", vcName: "JobOfferDetailVC") as! JobOfferDetailVC

        vc.configure(jobId: jobId, routeFrom: .fromKeepList)
        vc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に非表示にする

        navigationController?.pushViewController(vc, animated: true)
    }
}

extension KeepListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard row < self.lists.count else { return UITableViewCell() } //クラッシュ回避
        let _keepData = self.lists[row]
        let cell = tableView.loadCell(cellName: "KeepCardCell", indexPath: indexPath) as! KeepCardCell
        cell.tag = row
        cell.delegate = self
//        Log.selectLog(logLevel: .debug, "tableWidth:\(tableWidth)")
        cell.cellWidth = tableWidth
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
        Log.selectLog(logLevel: .debug, "KeepListVC delegate keepAction tag:\(jobId)")

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
