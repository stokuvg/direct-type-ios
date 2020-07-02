//
//  InitialInputConfirmVC.swift
//  direct-type
//
//  Created by yamataku on 2020/06/23.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation
import AWSMobileClient

final class InitialInputConfirmVC: TmpBasicVC {
    @IBOutlet private weak var authCodeTextField: UITextField!
    @IBOutlet private weak var nextButton: UIButton!
    
    @IBAction private func resendAuthCodeButton(_ sender: UIButton) {
        resendAuthCode()
    }
    @IBAction private func nextButton(_ sender: UIButton) {
        validateAuthCode()
    }
    
    private let confirmCodeMaxLength: Int = 6
    typealias LoginInfo = (phoneNumberText: String, password: String)
    private var loginInfo = LoginInfo(phoneNumberText: "", password: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        changeButtonState()
    }
    
    
    func configure(with loginInfo: LoginInfo) {
        self.loginInfo = loginInfo
    }
}

private extension InitialInputConfirmVC {
    func setup() {
        title = "認証コード入力"
        authCodeTextField.addTarget(self, action: #selector(changeButtonState), for: .editingChanged)
    }
    
    func validateAuthCode() {
        guard let inputText = authCodeTextField.text, inputText.isNumeric else {
            showConfirm(title: "フォーマットエラー", message: "数字6桁を入力してください", onlyOK: true)
            return
        }
        // TODO: 入力されたSMS認証コードを使ってAWSMobileClient.default().confirmSignIn(challengeResponse: _)にて検証を行う。
        // FIXME: デバッグ環境においては、電話番号登録→AWS管理画面上で手動認証→サインインというフローを踏んで
        // 新規登録させる必要があるため、SMS認証コード入力画面で無理やりサインイン処理をしているので、後から削除する
        signIn()
    }
    
    func signIn() {
        AWSMobileClient.default()
            .signIn(username: loginInfo.phoneNumberText.addCountryCode(type: .japan), password: loginInfo.password)  { (signInResult, error) in
                if let error = error {
                    let buf = AuthManager.convAnyError(error).debugDisp
                    DispatchQueue.main.async { self.showConfirm(title: "Error", message: buf, onlyOK: true) }
                    return
                }
                
                guard let signInResult = signInResult else {
                    print("レスポンスがが正常に受け取れませんでした")
                    return
                }
                
                switch signInResult.signInState {
                case .signedIn:
                    // FIXME: サーバー側でSMS認証系の実装が完了した際には「customChallenge」が返ってくるので、そちらに処理を移管し直す。
                    AnalyticsEventManager.setUser(by: AWSMobileClient.default().username)
                    DispatchQueue.main.async {
                        self.transitionToComplete()
                    }
                case .customChallenge:
                    // TODO: 本来は電話番号入力時のサインインAPIでは「customChallenge」が返ってくるが、
                    // 現状は「signedIn」が返ってくる仕様のため、処理をそちらのcaseに移管している。
                    break
                case .unknown, .smsMFA, .passwordVerifier, .deviceSRPAuth,
                     .devicePasswordVerifier, .adminNoSRPAuth, .newPasswordRequired:
                    break
                }
        }
    }
    
    func transitionToComplete() {
        let vc = getVC(sbName: "InitialInputCompleteVC", vcName: "InitialInputCompleteVC") as! InitialInputCompleteVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    var isValidInputText: Bool {
        guard let inputText = authCodeTextField.text, authCodeTextField.markedTextRange == nil,
            inputText.count == confirmCodeMaxLength else { return false }
        return true
    }
    
    @objc
    func changeButtonState() {
        nextButton.backgroundColor = UIColor(colorType: isValidInputText ? .color_sub : .color_line)
        nextButton.isEnabled = isValidInputText
        guard let inputText = authCodeTextField.text, isValidInputText else { return }
        authCodeTextField.text = inputText.prefix(confirmCodeMaxLength).description
    }
    
    func resendAuthCode() {
        AWSMobileClient.default().signUp(username: loginInfo.phoneNumberText, password: loginInfo.password) { (signUpResult, error) in
            if let _error = error {
                let buf = AuthManager.convAnyError(_error).debugDisp
                DispatchQueue.main.async { print(#line, #function, buf) }
                return
            }
            guard let signUpResult = signUpResult else { return }
            print(signUpResult.signUpConfirmationState)
            print(signUpResult.codeDeliveryDetails.debugDescription)
            var buf: String = ""
            switch signUpResult.signUpConfirmationState {
            case .confirmed:    buf = "confirmed"
//[簡易認証Skip]            self.actLogin(sender)//続けてログインも実施してしまう
            case .unconfirmed:  buf = "unconfirmed"
            case .unknown:      buf = "unknown"
            }
            DispatchQueue.main.async { print(#line, #function, buf) }
        }
    }
}

private extension String {
    var isNumeric: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[0-9]+").evaluate(with: self)
    }
}
