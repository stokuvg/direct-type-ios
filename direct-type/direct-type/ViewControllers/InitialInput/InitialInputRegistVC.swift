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
        AWSMobileClient.default().signUp(username: phoneNumberText.withCountryCode, password: password)  { (signInResult, error) in
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
            DispatchQueue.main.async {
                let vc = self.getVC(sbName: "InitialInputConfirmVC", vcName: "InitialInputConfirmVC") as! InitialInputConfirmVC
                let loginInfo = LoginConfirmVC.LoginInfo(phoneNumberText: phoneNumberText.withCountryCode, password: self.password)
                vc.configure(with: loginInfo)
                self.navigationController?.pushViewController(vc, animated: true)
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
    func changeButtonState() {
        nextButton.backgroundColor = UIColor(colorType: isValidInputText ? .color_sub : .color_line)
        nextButton.isEnabled = isValidInputText
        guard let inputText = phoneNumberTextField.text, isValidInputText else { return }
        phoneNumberTextField.text = inputText.prefix(phoneNumberMaxLength).description
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
