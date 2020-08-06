//
//  CognitoAuthVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/22.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import AWSMobileClient

//▼初回ユーザ登録時：
//1) usernameとして、ユーザに携帯電話番号を入力させる
//2) passwordが必要なため、アプリが自動生成する
//3) AWSMobileClient.default().signUpでユーザが作成される。成功するとCONFIRMEDになる
//4) AWSMobileClient.default().signInを続けて叩き、カスタム認証の開始をする
//5) SMSで認証コードが送られてくるため、ユーザに認証コードを入力させる
//6) AWSMobileClient.default().confirmSignInの「challengeResponse」に認証コードを指定して叩く
//　⇒成功するとSignInとなり、あとはAWSMobileClientがリフレッシュトークンなどもよしなにの流れ
//
//▽username重複時：
//・上記手順(3)で「[usernameExists: [An account with the given phone_number already exists.]]」となる
//
//▼ログアウト処理：
//・AWSMobileClient.default().signOutを叩き、SignOut状態となる
//
//▼ログイン処理：
//・「初回ユーザ登録時」の手順(3)をスキップした流れで良い
//*パスワード項目は必須だが、何を入れていても問題ない状態？！
//　⇒ユーザ作成時と異なる値を指定しても処理は問題なく行われる
//　⇒passwordを""にしても、パスワードポリシーのエラーとか戻ってこない？？
//
//

class CognitoAuthVC: BaseVC {
    var username: String = "" //安全なダミー番号: https://stabucky.com/wp/archives/6180
    let password: String = ""

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirm: UITextField!

    @IBOutlet weak var btnStatus: UIButton!
    @IBAction func actStatus(_ sender: Any) {
        var buf: String = ""
        switch( AWSMobileClient.default().currentUserState) {
        case .signedIn:                         buf = "signedIn"
        case .signedOut:                        buf = "signedOut"
        case .signedOutFederatedTokensInvalid:  buf = "signedOutFederatedTokensInvalid"
        case .signedOutUserPoolsTokenInvalid:   buf = "signedOutUserPoolsTokenInvalid"
        case .guest:                            buf = "guest"
        case .unknown:                          buf = "unknown"
        }
        DispatchQueue.main.async {
            self.showConfirm(title: "認証チェック", message: buf, onlyOK: true)
            /* Warning回避 */ .done { _ in } .catch { (error) in } .finally { } //Warning回避
            self.lblStatus.text = "\(Date())\n\(buf)"
        }
    }

    @IBOutlet weak var btnSignup: UIButton!
    @IBAction func actSignup(_ sender: Any) {
        let password: String = tfPassword.text ?? ""
        AWSMobileClient.default().signUp(username: username, password: password) { (signUpResult, error) in
            if let _error = error {
                let buf = AuthManager.convAnyError(_error).debugDisp
                DispatchQueue.main.async { print(#line, #function, buf); self.lblStatus.text = "\(Date())\n\(buf)" }
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
            DispatchQueue.main.async { print(#line, #function, buf); self.lblStatus.text = "\(Date())\n\(buf)" }
        }

    }
    @IBOutlet weak var btnLogin: UIButton!
    @IBAction func actLogin(_ sender: Any) {
        let password: String = tfPassword.text ?? ""
        AWSMobileClient.default().signIn(username: username, password: password) { (signInResult, error) in
            if let _error = error {
                let buf = AuthManager.convAnyError(_error).debugDisp
                DispatchQueue.main.async { print(#line, #function, buf); self.lblStatus.text = "\(Date())\n\(buf)" }
                return
            }
            guard let signInResult = signInResult else { return }
            print(#line, #function, signInResult.signInState.rawValue)
            var buf: String = ""
            switch signInResult.signInState {
            case .unknown:                  buf = "unknown"
            case .smsMFA:                   buf = "smsMFA"
            case .passwordVerifier:         buf = "passwordVerifier"
            case .customChallenge:          buf = "customChallenge"
                buf += "\nカスタム認証の流れにのったよ"
            let msg = "CloudWatchのロググループ\n「/aws/lambda/create-auth-challenge」\n\n「INFO RETURNED」の「passCode」を確認して入力します"
                DispatchQueue.main.async {
                    self.showConfirm(title: "認証手順", message: "続けて認証コードを入力して、\n〔Confirm〕ボタンを押してください\n\n\(msg)", onlyOK: true)
                    /* Warning回避 */ .done { _ in } .catch { (error) in } .finally { } //Warning回避
                }
                
            case .deviceSRPAuth:            buf = "deviceSRPAuth"
            case .devicePasswordVerifier:   buf = "devicePasswordVerifier"
            case .adminNoSRPAuth:           buf = "adminNoSRPAuth"
            case .newPasswordRequired:      buf = "newPasswordRequired"
            case .signedIn:                 buf = "signedIn"
                DispatchQueue.main.async {
                    self.showConfirm(title: "認証手順", message: "ログインしました", onlyOK: true)
                    /* Warning回避 */ .done { _ in } .catch { (error) in } .finally { } //Warning回避
                    self.checkAuthStatus()
                }
                DispatchQueue.main.async { print(#line, #function, buf); self.lblStatus.text = "\(Date())\n\(buf)" }

            }
            DispatchQueue.main.async { print(#line, #function, buf); self.lblStatus.text = "\(Date())\n\(buf)" }
        }
    }

    @IBOutlet weak var btnConfirm: UIButton!
    @IBAction func actConfirm(_ sender: Any) {
        let passcode: String = tfConfirm.text ?? ""
        let bufChallenge: String = "\(passcode)"
        print("[bufChallenge: \(bufChallenge)]")
        AWSMobileClient.default().confirmSignIn(challengeResponse: bufChallenge, completionHandler: { (signInResult, error) in
            if let _error = error  {
                let buf = AuthManager.convAnyError(_error).debugDisp
                DispatchQueue.main.async { print(#line, #function, buf); self.lblStatus.text = "\(Date())\n\(buf)" }
                print("＊＊＊認証コードチェックでのエラー＊＊＊")
                return
            } else if let signInResult = signInResult {
                var buf: String = ""
                switch (signInResult.signInState) {
                case .signedIn:                 buf = "signedIn"
                    DispatchQueue.main.async {
                        self.showConfirm(title: "認証手順", message: "ログインしました", onlyOK: true)
                        /* Warning回避 */ .done { _ in } .catch { (error) in } .finally { } //Warning回避
                        self.checkAuthStatus()
                    }

                case .unknown:                  buf = "unknown"
                case .smsMFA:                   buf = "smsMFA"
                case .passwordVerifier:         buf = "passwordVerifier"
                case .customChallenge:          buf = "customChallenge"
                case .deviceSRPAuth:            buf = "deviceSRPAuth"
                case .devicePasswordVerifier:   buf = "devicePasswordVerifier"
                case .adminNoSRPAuth:           buf = "adminNoSRPAuth"
                case .newPasswordRequired:      buf = "newPasswordRequired"
                }
                DispatchQueue.main.async { print(#line, #function, buf); self.lblStatus.text = "\(Date())\n\(buf)" }
                //=== その他詳細情報 ===
                print(signInResult.signInState.rawValue)
                print(signInResult.codeDetails.debugDescription)
                print(signInResult.parameters.description)
                print(signInResult)
            }
        })
    }

    @IBOutlet weak var btnLogout: UIButton!
    @IBAction func actLogout(_ sender: Any) {
        AWSMobileClient.default().signOut { (error) in
            if let _error = error {
                let buf = AuthManager.convAnyError(_error).debugDisp
                DispatchQueue.main.async { print(#line, #function, buf); self.lblStatus.text = "\(Date())\n\(buf)" }
                return
            }
            let buf = "User is signed Out."
            DispatchQueue.main.async {
                self.showConfirm(title: "認証手順", message: "ログアウトしました")
                .done { _ in
                    self.transitionToInitial()
                }
                .catch { _ in
                }
                .finally {
                }
                self.checkAuthStatus()
            }
            DispatchQueue.main.async { print(#line, #function, buf); self.lblStatus.text = "\(Date())\n\(buf)" }
        }
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tfPhone.placeholder = "+819001234567"
        tfPhone.text = self.username
        tfPassword.placeholder = "大文字小文字記号数値まじり6桁以上"
        tfPassword.text = self.password
        tfConfirm.placeholder = "6桁認証コード"
        btnStatus.setTitle("Status", for: .normal)
        btnSignup.setTitle("Signup", for: .normal)
        btnLogin.setTitle("Login", for: .normal)
        btnConfirm.setTitle("Confirm", for: .normal)
        btnLogout.setTitle("Logout", for: .normal)
        
        tfPassword.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAuthStatus()
    }
}

private extension CognitoAuthVC {
    func checkAuthStatus() {
        var isLogin: Bool = false
        switch( AWSMobileClient.default().currentUserState) {
        case .signedIn: isLogin = true
        default: isLogin = false
        }
        if isLogin {
            tfPhone.isHidden = true
            btnSignup.isHidden = true
            btnLogin.isHidden = true
            tfConfirm.isHidden = true
            btnConfirm.isHidden = true
            btnLogout.isHidden = false
        } else {
            tfPhone.isHidden = false
            btnSignup.isHidden = false
            btnLogin.isHidden = false
            tfConfirm.isHidden = false
            btnConfirm.isHidden = false
            btnLogout.isHidden = true
        }
    }
    
    func transitionToInitial() {
        let vc = getVC(sbName: "InitialInputStartVC", vcName: "InitialInputStartVC") as! InitialInputStartVC
        let newNavigationController = UINavigationController(rootViewController: vc)
        UIApplication.shared.keyWindow?.rootViewController = newNavigationController
    }
}
