//
//  AccountChangeCompleteVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
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
        reSendAuthCode()
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
        AWSMobileClient.default().confirmSignIn(challengeResponse: code, completionHandler: { (signInResult, error) in
            if let error = error  {
                let buf = AuthManager.convAnyError(error).debugDisp
                DispatchQueue.main.async { print(#line, #function, buf) }
                return
            }
            
            guard let signInResult = signInResult else { return }
            var buf: String = ""
            switch (signInResult.signInState) {
            case .signedIn:
                buf = "signedIn"
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.showConfirm(title: "変更が完了しました", message: "", onlyOK: true)
                    .done { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                    } .catch { (error) in } .finally { }
                }
            case .unknown:
                buf = "unknown"
            case .smsMFA:
                buf = "smsMFA"
            case .passwordVerifier:
                buf = "passwordVerifier"
            case .customChallenge:
                buf = "customChallenge"
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.showConfirm(title: "コードが誤っています", message: "正しいコードを入力してください。", onlyOK: true)
                }
            case .deviceSRPAuth:
                buf = "deviceSRPAuth"
            case .devicePasswordVerifier:
                buf = "devicePasswordVerifier"
            case .adminNoSRPAuth:
                buf = "adminNoSRPAuth"
            case .newPasswordRequired:
                buf = "newPasswordRequired"
            }
            DispatchQueue.main.async { print(#line, #function, buf) }
        })
    }
    
    func reSendAuthCode() {
        // TODO: サーバー側のAPI実装完了後に疎通実装をする
//        let param = GetAuthCodeRequestDTO(phoneNumber: phoneNumber)
//        SVProgressHUD.show()
//        ApiManager.getAuthCode(param)
//            .done { result in
//                authCode = result.confirmCode
//                let sendSuccessAlert = UIAlertController.init(title: "認証コード再送信", message: "再送しました。", preferredStyle: .alert)
//                let okAction = UIAlertAction.init(title: "OK", style: .default)
//                sendSuccessAlert.addAction(okAction)
//                navigationController?.present(sendSuccessAlert, animated: true, completion: nil)
//        }
//            .catch { (error) in
//                let myErr: MyErrorDisp = AuthManager.convAnyError(error)
//                print("電話番号登録エラー コード: \(myErr.code)")
//        }
//            .finally {
//                SVProgressHUD.dismiss()
//        }
    }
}

private extension String {
    var isNumeric: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[0-9]+").evaluate(with: self)
    }
}
