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
        openReasonOfConfirmPhone()
    }
    @IBAction private func nextButton(_ sender: UIButton) {
        trySignIn()
    }
    
    private let phoneNumberMaxLength: Int = 11
    // この画面ではログアウトがされている前提だが、ログイン処理の時前に強制的なログアウトをしたい場合にフラグを立てる。
    private let shouldLogOutIfNeeded = true
    
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
    
    func trySignIn() {
        if shouldLogOutIfNeeded {
            logOutIfNeeded()
        }
        
        guard let phoneNumberText = phoneNumberTextField.text, phoneNumberText.isValidPhoneNumber else {
            showConfirm(title: "フォーマットエラー", message: "正しい電話番号を入力してください。", onlyOK: true)
            return
        }
        SVProgressHUD.show()
        changeButtonState(shouldForceDisable: true)
        AWSMobileClient.default().signIn(username: phoneNumberText.addCountryCode(type: .japan), password: AppDefine.password)  { (signInResult, error) in
            if let error = error as? AWSMobileClientError {
                switch error {
                case .invalidParameter:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.trySignIn()
                    }
                default:
                    DispatchQueue.main.async {
                        let buf = AuthManager.convAnyError(error).debugDisp
                        self.showConfirm(title: "Error", message: buf, onlyOK: true)
                        self.changeButtonState()
                        SVProgressHUD.dismiss()
                    }
                }
                return
            }
            
            guard let signInResult = signInResult else {
                print("レスポンスがが正常に受け取れませんでした")
                return
            }
            switch signInResult.signInState {
            case .customChallenge:
                DispatchQueue.main.async {
                    let vc = self.getVC(sbName: "LoginConfirmVC", vcName: "LoginConfirmVC") as! LoginConfirmVC
                    let loginInfo = LoginConfirmVC.LoginInfo(phoneNumberText: phoneNumberText.addCountryCode(type: .japan), password: AppDefine.password)
                    vc.configure(with: loginInfo)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case .unknown, .signedIn, .smsMFA, .passwordVerifier, .deviceSRPAuth,
                 .devicePasswordVerifier, .adminNoSRPAuth, .newPasswordRequired:
                break
            }
            DispatchQueue.main.async {
                self.changeButtonState()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func openReasonOfConfirmPhone() {
        let vc = getVC(sbName: "Web", vcName: "SettingWebVC") as! SettingWebVC
        vc.setup(type: .reasonOfConfirmPhone)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func logOutIfNeeded() {
        if AWSMobileClient.default().currentUserState == .signedIn {
            AWSMobileClient.default().signOut { (error) in
                if let error = error {
                    let buf = AuthManager.convAnyError(error).debugDisp
                    print("ログアウトエラー: \(buf)")
                }
                print("ログアウト完了")
            }
        }
    }
    
    var isValidInputText: Bool {
        guard let inputText = phoneNumberTextField.text, phoneNumberTextField.markedTextRange == nil,
            inputText.count == phoneNumberMaxLength else { return false }
        return true
    }
    
    @objc
    func changeButtonState(shouldForceDisable: Bool = false) {
        guard let inputText = phoneNumberTextField.text, !shouldForceDisable else {
            nextButton.backgroundColor = UIColor(colorType: .color_line)
            nextButton.isEnabled = false
            return
        }
        phoneNumberTextField.text = inputText.prefix(phoneNumberMaxLength).description
        nextButton.backgroundColor = UIColor(colorType: isValidInputText ? .color_sub : .color_line)
        nextButton.isEnabled = isValidInputText
    }
}
