//
//  LoginVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class LoginVC: TmpBasicVC {
    
    @IBAction func reasonOfConfirmPhoneButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension LoginVC {
    func setup() {
        title = "初期入力"
        setLeftBarButton()
    }
    
    var leftBatButtonFrame: CGRect {
        return CGRect(x: .zero, y: .zero, width: 30, height: 30)
    }
    func setLeftBarButton() {
        let leftBarButton = UIButton(type: .system)
        leftBarButton.frame = leftBatButtonFrame
        leftBarButton.setTitle(text: "✗", fontType: .font_XL, textColor: .white, alignment: .left)
        leftBarButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        let backButtonItem =  UIBarButtonItem(customView: leftBarButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
}
