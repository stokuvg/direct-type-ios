//
//  LoginConfirmVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SVProgressHUD
import AWSMobileClient

final class LoginConfirmVC: TmpBasicVC {
    
    @IBOutlet private weak var scrollVW: UIScrollView!
    @IBOutlet private weak var authCodeTextField: UITextField!
    @IBOutlet private weak var nextButton: UIButton!
    
    // 再送信
    @IBAction private func resendAuthCodeButton(_ sender: UIButton) {
        resendAuthCode()
    }
    // ヘルプ
    @IBAction private func codeWebHelpButton(_ sender: UIButton) {
        codeWebHelp()
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
    //=== Notification通知の登録 ===
    // 画面遷移時にも取り除かないもの（他の画面で変更があった場合の更新のため）
    override func initNotify() {
    }
    // この画面に遷移したときに登録するもの
    override func addNotify() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    // 他の画面に遷移するときに消して良いもの
    override func removeNotify() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc func keyboardDidShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let rect = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            let safeAreaB = self.view.safeAreaInsets.bottom
            let szKeyBoard = rect.size
            scrollVW.contentInset.bottom = szKeyBoard.height + safeAreaB
        }
    }
    @objc func keyboardDidHide(notification: NSNotification) {
      scrollVW.contentInset.bottom = 0
    }
    //=======================================================================================================

    
    
    func configure(with loginInfo: LoginInfo) {
        self.loginInfo = loginInfo
    }
}

private extension LoginConfirmVC {
    func setup() {
        title = "認証コード入力"
        authCodeTextField.addTarget(self, action: #selector(changeButtonState), for: .editingChanged)
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
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        changeButtonState(shouldForceDisable: true)
        LogManager.appendApiLog("AWSMobileClient", "confirmSignIn", function: #function, line: #line)
        AWSMobileClient.default().confirmSignIn(challengeResponse: code, completionHandler: { (signInResult, error) in
            if let error = error  {
                LogManager.appendApiErrorLog("confirmSignIn", error, function: #function, line: #line)
                let myError = AuthManager.convAnyError(error)
                DispatchQueue.main.async {
                    let errorType = MyErrorDisp.CodeType(rawValue: myError.code)
                    if errorType == .invalidSession || errorType == .afterInvalidSession {
                        self.showConfirm(title: "認証エラー", message: "認証コードを再送信してください。", onlyOK: true)
                    }
                    self.changeButtonState()
                    SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressErr("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
                }
                return
            }
            LogManager.appendApiResultLog("confirmSignIn", signInResult, function: #function, line: #line)
            guard let signInResult = signInResult else { return }
            var buf: String = ""
            switch (signInResult.signInState) {
            case .signedIn:
                buf = "signedIn"
                AuthManager.shared.updateSub()//Sub値の更新をしておく
                DispatchQueue.main.async {
                    ApiManager.createActivity()
                    self.transitionToBaseTab()
                }
            case .unknown:
                buf = "unknown"
            case .smsMFA:
                buf = "smsMFA"
            case .passwordVerifier:
                buf = "passwordVerifier"
            case .customChallenge:
                buf = "customChallenge"
                self.showConfirm(title: "認証コードが一致しません", message: "正しいコードを入力してください。", onlyOK: true)
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
                self.changeButtonState()
                SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
            }
        })
    }
    
    func transitionToBaseTab() {
        let tabSB = UIStoryboard(name: "BaseTabBC", bundle: nil)
        let tabBC = tabSB.instantiateViewController(withIdentifier: "Sbid_BaseTabBC")
        
        if UserDefaultsManager.synchronize() {
            Log.selectLog(logLevel: .debug, "ホーム画面　C1,タブ遷移 フラグの保存成功")
            UIApplication.shared.keyWindow?.rootViewController = tabBC
        }
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
    
    func codeWebHelp() {
        OpenLinkUrlTool.open(type: .Help, navigationController)
    }
    
    func resendAuthCode() {
        SVProgressHUD.show()
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        LogManager.appendApiLog("AWSMobileClient", "signIn", function: #function, line: #line)
        AWSMobileClient.default().signIn(username: loginInfo.phoneNumberText, password: loginInfo.password)  { (signInResult, error) in
            if let error = error as? AWSMobileClientError {
                LogManager.appendApiErrorLog("signIn", error, function: #function, line: #line)
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
                        SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressErr("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
                    }
                }
                return
            }
            LogManager.appendApiResultLog("signIn", signInResult, function: #function, line: #line)
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
                SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
            }
        }
    }
}
