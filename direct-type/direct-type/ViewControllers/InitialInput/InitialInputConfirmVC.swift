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
        // FIXME: デバッグ時には動作確認のため、そのままベースタブ画面へ遷移させる。
        transitionToComplete()
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
        AWSMobileClient.default()
            .signUp(username: loginInfo.phoneNumberText, password: loginInfo.password)  { (signInResult, error) in
            if let error = error {
                let buf = AuthManager.convAnyError(error).debugDisp
                DispatchQueue.main.async {
                    self.showConfirm(title: "Error", message: buf, onlyOK: true)
                }
                return
            }
            
            guard signInResult != nil else {
                print("レスポンスがが正常に受け取れませんでした")
                return
            }
            // TODO: 認証コードを検証するAPIを実行する。
        }
    }
}

private extension String {
    var isNumeric: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[0-9]+").evaluate(with: self)
    }
}
