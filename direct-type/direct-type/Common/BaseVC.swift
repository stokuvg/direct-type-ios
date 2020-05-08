//
//  BaseVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/27.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

import PromiseKit
import SVProgressHUD

enum NaviType {
    case normal
    case login
    case detail
    case share
}

class BaseVC: UIViewController {
    
    var moreDataCount:Int = 5 // もっと見る 件数

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorType: .color_black)

        // 画面タップ不可設定
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getVC<T: UIViewController>(sbName:String,vcName:String) -> T? {
            
        let sb = UIStoryboard(name: sbName, bundle: nil)
            
        let sbid = "Sbid_" + vcName
            
        let vc = sb.instantiateViewController(withIdentifier: sbid) as! T
        return vc
    }

}

extension BaseVC {
    
}
