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
import SwaggerClient

class KeepListVC: TmpBasicVC {
    @IBOutlet weak var keepTableView:UITableView!
    
    var lists:MdlKeepList!
    var pageNo:Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "キープリスト"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getKeepList()
    }
    
    private func getKeepList() {
        SVProgressHUD.show()
        lists = MdlKeepList()
        ApiManager.getKeeps(pageNo, isRetry: true)
            .done { result in
                debugLog("ApiManager getKeeps result:\(result.debugDisp)")
                
                self.lists = result
        }
        .catch { (error) in
            Log.selectLog(logLevel: .debug, "error:\(error)")
            
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            switch myErr.code {
                case 403:
                    let message:String = "idTokenを取得していません"
                    self.showConfirm(title: "通信失敗", message: message)
                        .done { _ in
                            
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
            self.dataDisplay()
        }
    }
    
    private func dataDisplay() {
        if self.lists.keepJobs.count > 0 {
            //
            self.keepTableView.delegate = self
            self.keepTableView.dataSource = self
            self.keepTableView.reloadData()
        } else {
            // 0件
        }
    }

}

extension KeepListVC: UITableViewDelegate {
    
}

extension KeepListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.keepJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let _keepData = self.lists.keepJobs[row]
        Log.selectLog(logLevel: .debug, "_keepData:\(_keepData.jobId)")
        return UITableViewCell()
    }
    
    
}
