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
    
    private var statusBarStyle: UIStatusBarStyle = .default

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // 画面タップ不可設定
        SVProgressHUD.setDefaultMaskType(.black)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Log.selectLog(logLevel: .debug, "BaseVC viewWillAppear start")
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arDefaultWhite")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arDefaultWhite")
        
        if #available(iOS 13.0, *) {
            self.setStattusBarStyle(style: .darkContent)
        } else {
            self.navigationController?.navigationBar.barStyle = .black
        }
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [
                .font: UIFont(name: "HiraginoSans-W3", size: 24.0) as Any,
                .foregroundColor: UIColor.init(colorType: .color_white) as Any,
            ]
            navBarAppearance.largeTitleTextAttributes = [
                .font: UIFont(name: "HiraginoSans-W3", size: 24.0) as Any,
                .foregroundColor: UIColor.init(colorType: .color_white) as Any,
            ]
            navBarAppearance.backgroundColor = UIColor.init(colorType: .color_black)
            self.navigationController?.navigationBar.tintColor = UIColor.init(colorType: .color_white)
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            
            self.navigationController?.navigationBar.tintColor = UIColor.init(colorType: .color_white)
            self.navigationController?.navigationBar.barTintColor = UIColor.init(colorType: .color_black)
            self.navigationController?.navigationBar.titleTextAttributes = [
                .font: UIFont(name: "HiraginoSans-W3", size: 24.0) as Any,
                .foregroundColor: UIColor.init(colorType: .color_white) as Any,
            ]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        Log.selectLog(logLevel: .debug, "BaseVC viewDidAppear start")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        Log.selectLog(logLevel: .debug, "BaseVC viewWillDisappear start")

        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arDefaultWhite")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arDefaultWhite")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        Log.selectLog(logLevel: .debug, "BaseVC viewDidDisappear start")
    }
    
    func setStattusBarStyle(style: UIStatusBarStyle) {
        statusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    //
    func setRightSearchBtn() {
        let searchImage = UIImage(named: "refineDefaultWhiteBase")
        let searchItemBtn = UIBarButtonItem.init(image: searchImage, style: .done, target: self, action: #selector(searchBtnAction))
        
        self.navigationItem.rightBarButtonItem = searchItemBtn
    }
    
    @objc func searchBtnAction() {
        
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
