//
//  WithDrawalCompleteVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class WithDrawalCompleteVC: TmpBasicVC {
    @IBOutlet private weak var infomationLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension WithDrawalCompleteVC {
    func setup() {
        title = "退会完了"
        infomationLabel.text(text: "退会手続きが完了しました。", fontType: .font_S, textColor: UIColor(colorType: .color_black)!, alignment: .center)
        setLeftBarButton()

        let ud = UserDefaults.standard
        ud.set(false, forKey: "home")
        ud.set(true, forKey: "pushTab")
        if ud.synchronize() {
            Log.selectLog(logLevel: .debug, "ホーム画面　C1,タブ遷移 フラグの保存成功")
        }
        
    }
    
    var leftBatButtonFrame: CGRect {
        return CGRect(x: .zero, y: .zero, width: 30, height: 30)
    }
    func setLeftBarButton() {
        let leftBarButton = UIButton(type: .system)
        leftBarButton.frame = leftBatButtonFrame
        leftBarButton.setTitle(text: "×", fontType: .font_XL, textColor: .white, alignment: .left)
        leftBarButton.addTarget(self, action: #selector(transitionToInitialView), for: .touchUpInside)
        
        let backButtonItem =  UIBarButtonItem(customView: leftBarButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc
    func transitionToInitialView() {
        pushViewController(.initialInputStart)
    }
}

extension WithDrawalCompleteVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is WithDrawalCompleteVC {
            Log.selectLog(logLevel: .debug, "この画面と一致")
            let vc = getVC(sbName: "InitialInputStartVC", vcName: "InitialInputStartVC") as! InitialInputStartVC
            let viewControllers = self.navigationController?.viewControllers
            var newVCs = [UIViewController]()
            newVCs.append(vc)
            for i in 0..<viewControllers!.count {
                let nowVC = viewControllers![i]
                newVCs.append(nowVC)
            }
            navigationController.setViewControllers(newVCs, animated: false)
        } else {
            Log.selectLog(logLevel: .debug, "この画面以外と一致")
        }
    }
}
