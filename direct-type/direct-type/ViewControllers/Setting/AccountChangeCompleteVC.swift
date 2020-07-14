//
//  AccountChangeCompleteVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import TudApi
import AWSMobileClient
import SVProgressHUD

final class AccountChangeCompleteVC: TmpBasicVC {
    @IBOutlet private weak var infomationLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var inputCodeField: UITextField!
    @IBOutlet private weak var sendBtn: UIButton!
    @IBAction private func sendBtnAction() {
        validateAuthCode()
    }
    @IBOutlet private weak var reSendBtn: UIButton!
    @IBAction private func reSendBtnAction() {
        resendAuthCode()
    }
    
    private let codeMaxLength: Int = 6
    private var phoneNumber = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func configure(with phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
}

private extension AccountChangeCompleteVC {
    func setup() {
        title = "認証コード入力"
        
        infomationLabel.text(text: "６桁のコードを入力してください", fontType: .font_M, textColor: UIColor(colorType: .color_black)!, alignment: .center)
        textLabel.text(text: "入力いただいた電話番号に確認コードをお送りいたしました。\n送信された６桁のコードを入力してください。", fontType: .font_S, textColor: UIColor(colorType: .color_black)!, alignment: .center)
        
        inputCodeField.textColor = UIColor(colorType: .color_black)
        inputCodeField.font = UIFont(fontType: .font_M)
        inputCodeField.attributedPlaceholder = NSAttributedString(string: "コードを入力", attributes: [NSAttributedString.Key.foregroundColor : UIColor(colorType: .color_parts_gray)!])
        inputCodeField.addTarget(self, action: #selector(changeButtonState), for: .editingChanged)
        
        sendBtn.setTitle(text: "次へ", fontType: .font_M, textColor: UIColor(colorType: .color_white)!, alignment: .center)
        reSendBtn.setTitle(text: "認証コードを再送する", fontType: .font_SS, textColor: UIColor(colorType: .color_sub)!, alignment: .right)
        inputCodeField.becomeFirstResponder()
        
        changeButtonState()
    }
    
    var isValidInputText: Bool {
        guard let inputText = inputCodeField.text, inputCodeField.markedTextRange == nil, inputText.count == codeMaxLength else { return false }
        return true
    }
    
    @objc
    func changeButtonState(shouldForceDisable: Bool = false) {
        guard let inputText = inputCodeField.text, !shouldForceDisable else {
            sendBtn.backgroundColor = UIColor(colorType: .color_line)
            sendBtn.isEnabled = false
            return
        }
        inputCodeField.text = inputText.prefix(codeMaxLength).description
        sendBtn.backgroundColor = UIColor(colorType: isValidInputText ? .color_sub : .color_line)
        sendBtn.isEnabled = isValidInputText
    }
    
    func validateAuthCode() {
        guard let inputText = inputCodeField.text, inputText.isNumeric else {
            showConfirm(title: "フォーマットエラー", message: "数字6桁を入力してください", onlyOK: true)
            return
        }
        tryConfirmAuthCode(with: inputText)
    }
    
    func tryConfirmAuthCode(with code: String) {
        let param = AccountMigrateAnswerRequest(code: code)
        
        SVProgressHUD.show()
        ApiManager.accountMigrateAnswer(param)
        .done { _ in
            self.tryLogout()
        }
        .catch { (error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                print(#line, #function, error.localizedDescription)
                self.showConfirm(title: "認証エラー", message: "正しいコードを入力ください。", onlyOK: true)
            }
        }
        .finally {
            SVProgressHUD.dismiss()
        }
    }
    
    func tryLogout() {
        AWSMobileClient.default().signOut { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.showError(error)
                }
                return
            }
            DispatchQueue.main.async {
                self.trySignIn()
            }
        }
    }
    
    
    func trySignIn() {
        AWSMobileClient.default().signIn(username: phoneNumber.addCountryCode(type: .japan), password: AppDefine.password)  { (signInResult, error) in
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
                    self.showConfirm(title: "変更が完了しました", message: "", onlyOK: true)
                    .done { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                    } .catch { (error) in } .finally { }
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
    
    func resendAuthCode() {
        let param = AccountMigrateRequest(phoneNumber: phoneNumber.addCountryCode(type: .japan))
        
        SVProgressHUD.show()
        ApiManager.accountMigrate(param)
        .done { result in
            self.showConfirm(title: "認証コードを再送信しました", message: "", onlyOK: true)
        }
        .catch { (error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                print(#line, #function, error.localizedDescription)
                self.showConfirm(title: "電話番号変更エラー", message: "別の電話番号で再度お試しください。", onlyOK: true)
            }
        }
        .finally {
            SVProgressHUD.dismiss()
        }
    }
}
