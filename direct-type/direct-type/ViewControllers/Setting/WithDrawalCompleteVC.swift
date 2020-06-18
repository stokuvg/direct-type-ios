//
//  WithDrawalCompleteVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class WithDrawalCompleteVC: TmpBasicVC {
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
    }
    
    
    var leftBatButtonFrame: CGRect {
        return CGRect(x: .zero, y: .zero, width: 30, height: 30)
    }
    func setLeftBarButton() {
        let leftBarButton = UIButton(type: .system)
        leftBarButton.frame = leftBatButtonFrame
        // TODO: システムデフォルトの左矢印画像を使用していないため、あとからそれっぽい画像を実装した方がデザイン的には良い
        leftBarButton.setTitle(text: "<", fontType: .font_XL, textColor: .white, alignment: .left)
        leftBarButton.addTarget(self, action: #selector(moveToInitialView), for: .touchUpInside)
        
        let backButtonItem =  UIBarButtonItem(customView: leftBarButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc
    func moveToInitialView() {
        // TODO: どこへ遷移させるべきか確認して画面遷移実装をする
    }
}

extension WithDrawalCompleteVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is WithDrawalCompleteVC {
            Log.selectLog(logLevel: .debug, "この画面と一致")
            let vc = getVC(sbName: "InitialInput", vcName: "InitialInputListVC") as! InitialInputListVC
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
