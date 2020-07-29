//
//  InitialInputRegistVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SVProgressHUD
import AWSMobileClient

final class InitialInputRegistVC: TmpBasicVC {
    @IBOutlet private weak var scrollVW: UIScrollView!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var nextButton: UIButton!
    @IBAction private func privacyPolicyButton(_ sender: UIButton) {
        openWebView(type: .RegistPrivacyPolicy)
    }
    @IBAction func termsOfServiceButton(_ sender: UIButton) {
        openWebView(type: .RegistAgreement)
    }
    @IBAction private func reasonOfConfirmPhoneButton(_ sender: UIButton) {
        openWebView(type: .RegistPhoneReason)
    }
    @IBAction private func nextButton(_ sender: UIButton) {
        AnalyticsEventManager.track(type: .createAuthenticationCode)
        let isDidInputPhoneNumber = didInputPhoneNumbers.first(where: { $0 == phoneNumberTextField.text! })
        isDidInputPhoneNumber == nil ? trySignUp() : trySignIn()
    }
    
    private let phoneNumberMaxLength: Int = 11
    // この画面ではログアウトがされている前提だが、ログイン処理の時前に強制的なログアウトをしたい場合にフラグを立てる。
    private let shouldLogOutIfNeeded = true
    private var didInputPhoneNumbers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        changeButtonState()
        phoneNumberTextField.keyboardType = .numberPad
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
}

private extension InitialInputRegistVC {
    func setup() {
        title = "電話番号入力"
        navigationController?.isNavigationBarHidden = false
        phoneNumberTextField.addTarget(self, action: #selector(changeButtonState), for: .editingChanged)
    }
    
    func trySignUp() {
        if shouldLogOutIfNeeded {
            logOutIfNeeded()
        }
        
        guard let phoneNumberText = phoneNumberTextField.text, phoneNumberText.isValidPhoneNumber else {
            showConfirm(title: "フォーマットエラー", message: "正しい電話番号を入力してください。", onlyOK: true)
            return
        }
        let phoneNumber = phoneNumberText.addCountryCode(type: .japan)
        let phoneNumberAttribute = ["phone_number" : phoneNumber]
        
        SVProgressHUD.show()
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        changeButtonState(shouldForceDisable: true)
        LogManager.appendApiLog("AWSMobileClient", "signUp", function: #function, line: #line)
        AWSMobileClient.default().signUp(username: phoneNumber, password: AppDefine.password, userAttributes: phoneNumberAttribute) { (signUpResult, error) in
            if let error = error {
                LogManager.appendApiErrorLog("signUp", error, function: #function, line: #line)
                let myError = AuthManager.convAnyError(error)
                DispatchQueue.main.async {
                    let errorType = MyErrorDisp.CodeType(rawValue: myError.code)
                    if errorType == .existsUser {
                        self.showConfirm(title: "電話番号登録エラー", message: "別の電話番号で再度お試しください。", onlyOK: true)
                    }
                    self.changeButtonState()
                    SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressErr("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
                }
                return
            }
            LogManager.appendApiResultLog("signUp", signUpResult, function: #function, line: #line)
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
        guard let phoneNumberText = phoneNumberTextField.text, phoneNumberText.isValidPhoneNumber else {
            showConfirm(title: "フォーマットエラー", message: "正しい電話番号を入力してください。", onlyOK: true)
            return
        }
        if !SVProgressHUD.isVisible() {
            SVProgressHUD.show()
            LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        }
        LogManager.appendApiLog("AWSMobileClient", "signIn", function: #function, line: #line)
        AWSMobileClient.default().signIn(username: phoneNumberText.addCountryCode(type: .japan), password: AppDefine.password) { (signInResult, error) in
            if let error = error as? AWSMobileClientError {
                LogManager.appendApiErrorLog("signIn", error, function: #function, line: #line)
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
                        SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressErr("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
                    }
                }
                return
            }
            LogManager.appendApiResultLog("signIn", signInResult, function: #function, line: #line)
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
            DispatchQueue.main.async {
                print(#line, #function, buf)
                self.changeButtonState()
                SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
            }
        }
    }
    
    func transitionToComfirm() {
        guard let phoneNumberText = phoneNumberTextField.text else { return }
        let vc = getVC(sbName: "InitialInputConfirmVC", vcName: "InitialInputConfirmVC") as! InitialInputConfirmVC
        vc.configure(with: InitialInputConfirmVC.LoginInfo(phoneNumberText: phoneNumberText, password: AppDefine.password), delegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openWebView(type: DirectTypeLinkURL) {
        OpenLinkUrlTool.open(type: type, navigationController)
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

extension InitialInputRegistVC: InitialInputConfirmVCDelegate {
    func willBack(with phoneNumber: String) {
        didInputPhoneNumbers.append(phoneNumber)
    }
}
