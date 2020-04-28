//
//  SplashVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class SplashVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNextViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeStatusBarColor(color:UIColor.systemGray)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    /// 次に表示するVCを設定する
    private func setNextViewController() {
        
//        let loginSB = UIStoryboard(name: "LoginVC", bundle: nil)
//        let loginVC = loginSB.instantiateViewController(withIdentifier: "Sbid_LoginVC") as! LoginVC

        let tabSB = UIStoryboard(name: "BaseTabBC", bundle: nil)
        let tabBC = tabSB.instantiateViewController(withIdentifier: "Sbid_BaseTabBC")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = loginVC
        appDelegate.window?.rootViewController = tabBC
    }
    
    private func changeStatusBarColor(color:UIColor) {
        let statusBarBackground = UIView(frame: CGRect(x: 0, y: 0,
                                                       width: UIApplication.shared.statusBarFrame.size.width,
                                                       height: UIApplication.shared.statusBarFrame.size.height))
        statusBarBackground.backgroundColor = color
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
