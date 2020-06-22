//
//  LoginVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class LoginVC: TmpBasicVC {
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBAction private func reasonOfConfirmPhoneButton(_ sender: UIButton) {
    }
    @IBAction private func nextButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension LoginVC {
    func setup() {
        title = "初期入力"
        navigationController?.isNavigationBarHidden = false
    }
}
