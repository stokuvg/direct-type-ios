//
//  LoginVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AWSMobileClient
import SVProgressHUD

final class LoginVC: TmpBasicVC {
    @IBOutlet private weak var scrollVW: UIScrollView!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var nextButton: UIButton!
    @IBAction func privacyPolicyButton(_ sender: UIButton) {
        openWebView(type: .LoginPrivacyPolicy)
    }
    @IBAction func termsOfServiceButton(_ sender: UIButton) {
        openWebView(type: .LoginAgreement)
    }
    @IBAction private func reasonOfConfirmPhoneButton(_ sender: UIButton) {
        openWebView(type: .LoginPhoneReason)
    }
    @IBAction private func nextButton(_ sender: UIButton) {
        trySignIn()
    }
    
    private let phoneNumberMaxLength: Int = 11
    // この画面ではログアウトがされている前提だが、ログイン処理の時前に強制的なログアウトをしたい場合にフラグを立てる。
    private let shouldLogOutIfNeeded = true
    
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

private extension LoginVC {
    func setup() {
        title = "電話番号入力"
        navigationController?.isNavigationBarHidden = false
        phoneNumberTextField.addTarget(self, action: #selector(changeButtonState), for: .editingChanged)
    }
    
    func trySignIn() {
        if shouldLogOutIfNeeded {
            logOutIfNeeded()
        }
        
        guard let phoneNumberText = phoneNumberTextField.text, phoneNumberText.isValidPhoneNumber else {
            showConfirm(title: "フォーマットエラー", message: "正しい電話番号を入力してください。", onlyOK: true)
            return
        }
        SVProgressHUD.show()
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        changeButtonState(shouldForceDisable: true)
        LogManager.appendApiLog("AWSMobileClient", "signIn", function: #function, line: #line)
        AWSMobileClient.default().signIn(username: phoneNumberText.addCountryCode(type: .japan), password: Constants.AuthDummyPassword)  { (signInResult, error) in
            if let error = error as? AWSMobileClientError {
                LogManager.appendApiErrorLog("signIn", error, function: #function, line: #line)
                switch error {
                case .invalidParameter:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.trySignIn()
                    }
                default:
                    DispatchQueue.main.async {
                        self.showConfirm(title: "認証エラー", message: "電話番号の確認を行ってください。", onlyOK: true)
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
                    let vc = self.getVC(sbName: "LoginConfirmVC", vcName: "LoginConfirmVC") as! LoginConfirmVC
                    let loginInfo = LoginConfirmVC.LoginInfo(phoneNumberText: phoneNumberText.addCountryCode(type: .japan), password: Constants.AuthDummyPassword)
                    vc.configure(with: loginInfo)
                    self.navigationController?.pushViewController(vc, animated: true)
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
                //AWSCognitoAuth.default().signOutLocallyAndClearLastKnownUser()//サインアウト時の後処理（これ使う場合には、Info.plistにユーザプールID定義する必要あり）
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
