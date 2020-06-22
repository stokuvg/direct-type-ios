//
//  LoginConfirmVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class LoginConfirmVC: TmpBasicVC {
    @IBOutlet private weak var authCodeTextField: UITextField!
    @IBOutlet private weak var nextButton: UIButton!
    
    @IBAction private func resendAuthCodeButton(_ sender: UIButton) {
        // TODO: 「認証コードを再送信する」ボタンタップ時の実装を追加
    }
    @IBAction private func nextButton(_ sender: UIButton) {
        validateAuthCode()
    }
    
    private let aithCodeMaxLength: Int = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension LoginConfirmVC {
    func setup() {
        title = "認証コード入力"
        authCodeTextField.addTarget(self, action: #selector(changeButtonState), for: .editingChanged)
    }
    
    func validateAuthCode() {
        // TODO: 入力されたSMS認証コードを使ってAWSMobileClient.default().confirmSignIn(challengeResponse: _)にて検証を行う。
        // FIXME: デバッグ時には動作確認のため、そのままベースタブ画面へ遷移させる。
        transitionToBaseTab()
    }
    
    func transitionToBaseTab() {
        let tabSB = UIStoryboard(name: "BaseTabBC", bundle: nil)
        let tabBC = tabSB.instantiateViewController(withIdentifier: "Sbid_BaseTabBC")
        let newNavigationController = UINavigationController(rootViewController: tabBC)
        UIApplication.shared.keyWindow?.rootViewController = newNavigationController
    }
    
    var isValidInputText: Bool {
        guard let inputText = authCodeTextField.text, authCodeTextField.markedTextRange == nil,
            inputText.count == aithCodeMaxLength else { return false }
        return true
    }
    
    @objc
    func changeButtonState() {
        nextButton.backgroundColor = UIColor(colorType: isValidInputText ? .color_sub : .color_line)
        nextButton.isEnabled = isValidInputText
        guard let inputText = authCodeTextField.text, isValidInputText else { return }
        authCodeTextField.text = inputText.prefix(aithCodeMaxLength).description
    }
}
