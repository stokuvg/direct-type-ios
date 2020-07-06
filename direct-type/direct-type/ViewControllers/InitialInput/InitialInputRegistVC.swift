//
//  InitialInputRegistVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AWSMobileClient

final class InitialInputRegistVC: TmpBasicVC {
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var nextButton: UIButton!
    @IBAction private func reasonOfConfirmPhoneButton(_ sender: UIButton) {
        openReasonOfConfirmPhone()
    }
    @IBAction private func nextButton(_ sender: UIButton) {
        AnalyticsEventManager.track(type: .createAuthenticationCode)
        sendLoginAuthCode()
    }
    
    // TODO: パスワードは毎回自動生成する必要があるため、強度の検討が完了した後に自動生成ロジックを実装する
    // 参照: https://type.qiita.com/y_kawamata/items/e251d8904820d5b5ceaf
    private let password = "Abcd123$"
    private let phoneNumberMaxLength: Int = 11
    // この画面ではログアウトがされている前提だが、ログイン処理の時前に強制的なログアウトをしたい場合にフラグを立てる。
    private let shouldLogOutIfNeeded = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        changeButtonState()
    }
}

private extension InitialInputRegistVC {
    func setup() {
        title = "電話番号認証"
        navigationController?.isNavigationBarHidden = false
        phoneNumberTextField.addTarget(self, action: #selector(changeButtonState), for: .editingChanged)
    }
    
    func sendLoginAuthCode() {
        if shouldLogOutIfNeeded {
            logOutIfNeeded()
        }
        
        guard let phoneNumberText = phoneNumberTextField.text else { return }
        let phoneNumber = phoneNumberText.addCountryCode(type: .japan)
        let phoneNumberAttribute = ["phone_number" : phoneNumber]
        
        
//        AWSMobileClient.default().signUp(username: phoneNumberText.addCountryCode(type: .japan), password: password) { (signUpResult, error) in
        AWSMobileClient.default().signUp(username: phoneNumber, password: password, userAttributes: phoneNumberAttribute) { (signUpResult, error) in
            if let error = error {
                let buf = AuthManager.convAnyError(error).debugDisp
                DispatchQueue.main.async {
                    self.showConfirm(title: "Error", message: buf, onlyOK: true)
                        .done { _ in
                            DispatchQueue.main.async { self.transitionToComfirm() }
                    } .catch { (error) in } .finally { } //Warning回避
                }
                return
            }
            guard let signUpResult = signUpResult else { return }
            print(signUpResult.signUpConfirmationState)
            print(signUpResult.codeDeliveryDetails.debugDescription)
            var buf: String = ""
            switch signUpResult.signUpConfirmationState {
            case .confirmed:
                buf = "confirmed"
                DispatchQueue.main.async { self.trySignIn() }
            case .unconfirmed:
                buf = "unconfirmed"
            case .unknown:
                buf = "unknown"
            }
            DispatchQueue.main.async { print(#line, #function, buf) }
        }
    }
    
    func trySignIn() {
        guard let phoneNumberText = phoneNumberTextField.text else { return }
        AWSMobileClient.default().signIn(username: phoneNumberText.addCountryCode(type: .japan), password: password) { (signInResult, error) in
            if let error = error {
                let buf = AuthManager.convAnyError(error).debugDisp
                DispatchQueue.main.async { print(#line, #function, buf) }
                return
            }
            guard let signInResult = signInResult else { return }
            var buf: String = ""
            switch signInResult.signInState {
            case .unknown:
                buf = "unknown"
            case .smsMFA:
                buf = "smsMFA"
            case .passwordVerifier:
                buf = "passwordVerifier"
            case .customChallenge:
                buf = "customChallenge"
                DispatchQueue.main.async { self.transitionToComfirm() }
            case .deviceSRPAuth:
                buf = "deviceSRPAuth"
            case .devicePasswordVerifier:
                buf = "devicePasswordVerifier"
            case .adminNoSRPAuth:
                buf = "adminNoSRPAuth"
            case .newPasswordRequired:
                buf = "newPasswordRequired"
            case .signedIn:
                buf = "signedIn"
            }
            DispatchQueue.main.async { print(#line, #function, buf) }
        }
    }
    
    func transitionToComfirm() {
        guard let phoneNumberText = phoneNumberTextField.text else { return }
        let vc = getVC(sbName: "InitialInputConfirmVC", vcName: "InitialInputConfirmVC") as! InitialInputConfirmVC
        vc.configure(with: InitialInputConfirmVC.LoginInfo(phoneNumberText: phoneNumberText, password: password))
        self.navigationController?.pushViewController(vc, animated: true)
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
    func changeButtonState() {
        guard let inputText = phoneNumberTextField.text else { return }
        phoneNumberTextField.text = inputText.prefix(phoneNumberMaxLength).description
        nextButton.backgroundColor = UIColor(colorType: isValidInputText ? .color_sub : .color_line)
        nextButton.isEnabled = isValidInputText
    }
}

private extension String {
    enum CountryCode {
        case japan
        
        var text: String {
            switch self {
            case .japan:
                return "+81"
            }
        }
    }
    
    var withCountryCode: String {
        return CountryCode.japan.text + dropFirst()
    }
}
