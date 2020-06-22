//
//  LoginVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AWSMobileClient
import SVProgressHUD

final class LoginVC: TmpBasicVC {
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var nextButton: UIButton!
    @IBAction private func reasonOfConfirmPhoneButton(_ sender: UIButton) {
        // TODO: 「電話番号の確認が必要な理由」ボタンタップ時の実装を追加
    }
    @IBAction private func nextButton(_ sender: UIButton) {
        sendLoginAuthCode()
    }
    
    // TODO: パスワードは毎回自動生成する必要があるため、強度の検討が完了した後に自動生成ロジックを実装する
    // 参照: https://type.qiita.com/y_kawamata/items/e251d8904820d5b5ceaf
    private let password = "Abcd123$"
    private let phoneNumberMaxLength: Int = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        changeButtonState()
    }
}

private extension LoginVC {
    func setup() {
        title = "初期入力"
        navigationController?.isNavigationBarHidden = false
        phoneNumberTextField.addTarget(self, action: #selector(changeButtonState), for: .editingChanged)
    }
    
    func sendLoginAuthCode() {
        guard let phoneNumberText = phoneNumberTextField.text else { return }
        AWSMobileClient.default().signIn(username: phoneNumberText, password: password)  { (signInResult, error) in
            if let error = error {
                let buf = AuthManager.convAnyError(error).debugDisp
                DispatchQueue.main.async {
                    print(#line, #function, buf)
                    self.showConfirm(title: "Error", message: buf, onlyOK: true)
                }
                return
            }
            
            guard let signInResult = signInResult else {
                self.showConfirm(title: "Error", message: "通信が正常に完了しませんでした", onlyOK: true)
                return
            }
            var buf = ""
            switch (signInResult.signInState) {
            case .signedIn:                 buf = "signedIn"
            DispatchQueue.main.async {
                self.showConfirm(title: "認証手順", message: "ログインしました", onlyOK: true)
                }
            case .unknown:                  buf = "unknown"
            case .smsMFA:                   buf = "smsMFA"
            case .passwordVerifier:         buf = "passwordVerifier"
            case .customChallenge:          buf = "customChallenge"
            case .deviceSRPAuth:            buf = "deviceSRPAuth"
            case .devicePasswordVerifier:   buf = "devicePasswordVerifier"
            case .adminNoSRPAuth:           buf = "adminNoSRPAuth"
            case .newPasswordRequired:      buf = "newPasswordRequired"
            }
            DispatchQueue.main.async { print(#line, #function, buf); SVProgressHUD.show(withStatus: buf) }
            // FIXME: 変数確認後に削除
            print("👀signInState: \(signInResult.signInState.rawValue)")
            print("👀codeDetails: \(signInResult.codeDetails.debugDescription)")
            print("👀parameters: \(signInResult.parameters.description)")
            print("👀signInResult: \(signInResult)")
        }
    }
    
    var isValidInputText: Bool {
        guard let inputText = phoneNumberTextField.text, phoneNumberTextField.markedTextRange == nil,
            inputText.count == phoneNumberMaxLength else { return false }
        return true
    }
    
    @objc
    func changeButtonState() {
        nextButton.backgroundColor = UIColor(colorType: isValidInputText ? .color_sub : .color_line)
        nextButton.isEnabled = isValidInputText
        guard let inputText = phoneNumberTextField.text, isValidInputText else { return }
        phoneNumberTextField.text = inputText.prefix(phoneNumberMaxLength).description
    }
}
