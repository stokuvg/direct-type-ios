//
//  WithDrawalCompleteVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class WithDrawalCompleteVC: TmpBasicVC {
    
    @IBOutlet weak var infomationLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.delegate = self

        // Do any additional setup after loading the view.
        self.title = "退会完了"
        
        self.infomationLabel.text(text: "退会手続きが完了しました。", fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewControllers = self.navigationController?.viewControllers {
            var existSelfInViewControllers = true
            for viewController in viewControllers {
                if viewController == self {
                    existSelfInViewControllers = false
                    break
                }
            }
            
            if existSelfInViewControllers {
                let _appDelegate = UIApplication.shared.delegate as! AppDelegate
                _appDelegate.displayInitialInputVC()
                
            }
        }
        super.viewWillAppear(animated)
    }

}

extension WithDrawalCompleteVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is WithDrawalCompleteVC {
            Log.selectLog(logLevel: .debug, "この画面と一致")
            
            let vc = getVC(sbName: "InitialInput", vcName: "InitialInputListVC") as! InitialInputListVC
            
            let viewControllers = self.navigationController?.viewControllers
            
            var newVCs:[UIViewController] = []
            newVCs.append(vc)
            
            for i in 0..<viewControllers!.count {
                let nowVC = viewControllers![i]
                newVCs.append(nowVC)
            }
            
            self.navigationController?.setViewControllers(newVCs, animated: false)
        } else {
            Log.selectLog(logLevel: .debug, "この画面以外と一致")
        }
    }
}
