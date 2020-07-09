//
//  InitialInputConfirmVC.swift
//  direct-type
//
//  Created by yamataku on 2020/06/23.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation
import SVProgressHUD
import AWSMobileClient

protocol InitialInputConfirmVCDelegate: class {
    func willBack(with phoneNumber: String)
}

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
    private weak var delegate: InitialInputConfirmVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        changeButtonState()
    }
    
    
    func configure(with loginInfo: LoginInfo, delegate: InitialInputConfirmVCDelegate) {
        self.loginInfo = loginInfo
        self.delegate = delegate
    }
}

private extension InitialInputConfirmVC {
    func setup() {
        title = "認証コード入力"
        authCodeTextField.addTarget(self, action: #selector(changeButtonState), for: .editingChanged)
        navigationController?.delegate = self
    }
    
    func validateAuthCode() {
        guard let inputText = authCodeTextField.text, inputText.isNumeric else {
            showConfirm(title: "フォーマットエラー", message: "数字6桁を入力してください", onlyOK: true)
            return
        }
        tryConfirmAuthCode(with: inputText)
    }
    
    func tryConfirmAuthCode(with code: String) {
        SVProgressHUD.show()
        changeButtonState(shouldForceDisable: true)
        AWSMobileClient.default().confirmSignIn(challengeResponse: code, completionHandler: { (signInResult, error) in
            if let error = error  {
                let buf = AuthManager.convAnyError(error).debugDisp
                DispatchQueue.main.async {
                    print(#line, #function, buf)
                    self.changeButtonState()
                    SVProgressHUD.dismiss()
                }
                return
            }
            
            guard let signInResult = signInResult else { return }
            var buf: String = ""
            switch (signInResult.signInState) {
            case .signedIn:
                buf = "signedIn"
                DispatchQueue.main.async {
                    self.transitionToComplete()
                }
            case .unknown:
                buf = "unknown"
            case .smsMFA:
                buf = "smsMFA"
            case .passwordVerifier:
                buf = "passwordVerifier"
            case .customChallenge:
                buf = "customChallenge"
            case .deviceSRPAuth:
                buf = "deviceSRPAuth"
            case .devicePasswordVerifier:
                buf = "devicePasswordVerifier"
            case .adminNoSRPAuth:
                buf = "adminNoSRPAuth"
            case .newPasswordRequired:
                buf = "newPasswordRequired"
            }
            DispatchQueue.main.async {
                print(#line, #function, buf)
                self.changeButtonState()
                SVProgressHUD.dismiss()
            }
        })
    }
    
    func transitionToComplete() {
        let vc = getVC(sbName: "InitialInputCompleteVC", vcName: "InitialInputCompleteVC") as! InitialInputCompleteVC
        vc.configure(type: .registeredPhoneNumber)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    var isValidInputText: Bool {
        guard let inputText = authCodeTextField.text, authCodeTextField.markedTextRange == nil,
            inputText.count == confirmCodeMaxLength else { return false }
        return true
    }
    
    @objc
    func changeButtonState(shouldForceDisable: Bool = false) {
        guard let inputText = authCodeTextField.text, !shouldForceDisable else {
            nextButton.backgroundColor = UIColor(colorType: .color_line)
            nextButton.isEnabled = false
            return
        }
        authCodeTextField.text = inputText.prefix(confirmCodeMaxLength).description
        nextButton.backgroundColor = UIColor(colorType: isValidInputText ? .color_sub : .color_line)
        nextButton.isEnabled = isValidInputText
    }
    
    func resendAuthCode() {
        SVProgressHUD.show()
        AWSMobileClient.default().signIn(username: loginInfo.phoneNumberText.addCountryCode(type: .japan),
                                         password: loginInfo.password)  { (signInResult, error) in
            if let error = error as? AWSMobileClientError {
                switch error {
                case .invalidParameter:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.resendAuthCode()
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
                    self.showConfirm(title: "認証コードを再送信しました", message: "", onlyOK: true)
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
}

extension InitialInputConfirmVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 電話番号登録画面でAWSMobileClient.signUp()をコールした時点でCognitoにはユーザーが既に作成されてしまっているため、
        // この画面から電話番号登録画面に戻り、再度同じ番号でサインアップしようとした際には、signUp()ではなくsignIn()処理を
        // させる必要がある。遷移画面の前後で依存関係ができてしまうが、ユーザーが何度も同じ電話番号で新規登録を試みるケースを救済するため、
        // ここでは無理やり「入力されている電話番号」を渡すことで分岐処理の切り替え判別に利用している。
        if viewController is InitialInputRegistVC {
            delegate?.willBack(with: loginInfo.phoneNumberText)
        }
    }
}

private extension String {
    var isNumeric: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[0-9]+").evaluate(with: self)
    }
}
