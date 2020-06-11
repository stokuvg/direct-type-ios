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
        Log.selectLog(logLevel: .debug, "KeepListVC dataDisplay start")
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
        }
    }

}
extension KeepListVC: KeepNoViewDelegate {
    func btnAction() {
//        self.tabBarController?.selectedIndex = 3
        
        Log.selectLog(logLevel: .debug, "navigationController:\(String(describing: self.navigationController))")
        
        let vc = getVC(sbName: "ChemistryStart", vcName: "ChemistryStart") as! ChemistryStart
        self.navigationController?.pushViewController(vc, animated: true)
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
