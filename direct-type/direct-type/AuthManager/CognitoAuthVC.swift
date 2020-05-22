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
//    var username: String = "+819001234567" //安全なダミー番号: https://stabucky.com/wp/archives/6180
    var username: String = "+819046010406" //安全なダミー番号: https://stabucky.com/wp/archives/6180
    let password: String = "Abcd123$"

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
            self.lblStatus.text = "\(Date())\n\(buf)"
        }
    }

    @IBOutlet weak var btnSignup: UIButton!
    @IBAction func actSignup(_ sender: Any) {
        let password: String = tfPassword.text ?? ""
        AWSMobileClient.default().signUp(username: username, password: password) { (signUpResult, error) in
            if let _error = error {
                let buf = CognitoAuthVC.convAnyError(_error).debugDisp
                DispatchQueue.main.async { print(#line, #function, buf); self.lblStatus.text = "\(Date())\n\(buf)" }
                return
            }
            guard let signUpResult = signUpResult else { return }
            print(signUpResult.signUpConfirmationState)
            print(signUpResult.codeDeliveryDetails.debugDescription)
            var buf: String = ""
            switch signUpResult.signUpConfirmationState {
            case .confirmed:    buf = "confirmed"
            self.actLogin(sender)//続けてログインも実施してしまう
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
                let buf = CognitoAuthVC.convAnyError(_error).debugDisp
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
                }
                
            case .deviceSRPAuth:            buf = "deviceSRPAuth"
            case .devicePasswordVerifier:   buf = "devicePasswordVerifier"
            case .adminNoSRPAuth:           buf = "adminNoSRPAuth"
            case .newPasswordRequired:      buf = "newPasswordRequired"
            case .signedIn:                 buf = "signedIn"
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
                let buf = CognitoAuthVC.convAnyError(_error).debugDisp
                DispatchQueue.main.async { print(#line, #function, buf); self.lblStatus.text = "\(Date())\n\(buf)" }
                print("＊＊＊認証コードチェックでのエラー＊＊＊")
                return
            } else if let signInResult = signInResult {
                var buf: String = ""
                switch (signInResult.signInState) {
                case .signedIn:                 buf = "signedIn"
                    DispatchQueue.main.async {
                        self.showConfirm(title: "認証手順", message: "ログインしました", onlyOK: true)
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
                let buf = CognitoAuthVC.convAnyError(_error).debugDisp
                DispatchQueue.main.async { print(#line, #function, buf); self.lblStatus.text = "\(Date())\n\(buf)" }
                return
            }
            let buf = "User is signed Out."
            DispatchQueue.main.async {
                self.showConfirm(title: "認証手順", message: "ログアウトしました", onlyOK: true)
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

}


struct MyErrorDisp {
    var code: Int = 0
    var title: String = "エラー"
    var message: String = "エラーが発生しました"
    let orgErr: Error!
    var arrValidErrMsg: [String] = [] // 複合種キーになりかねないから、とりあえず抜粋モデルにしておく
    
    var debugDisp: String {
        var buf: String = ""
//        buf += "▽\(orgErr.localizedDescription) -> \n"
        buf += "\t[\(code): \(title)] ... [\(message)]\n"
        for valid in arrValidErrMsg {
            buf += "✨[\(valid)]"
        }
        return buf
    }
}


extension CognitoAuthVC {
    class func convAnyError(_ error: Error) -> MyErrorDisp {
        //====== 初期準備 ======
        var myErrorDisp: MyErrorDisp = MyErrorDisp(orgErr: error)
        guard let _error = error as? NSError  else {
            print("=== 準備失敗 ===\n", myErrorDisp.debugDisp, "\n==================")
            return myErrorDisp
        }
        //=== UserDefine Error は、そのまま表示させておわる
        myErrorDisp.code = _error.code
        myErrorDisp.title = "❤️" + _error.domain
        myErrorDisp.message = _error.userInfo.description
        
        //=== AWS Mobile Client:
        if let orgErr = error as? AWSMobileClientError {
            myErrorDisp.title = "AWSMobileClient"
            myErrorDisp.message = orgErr.dispError
            return myErrorDisp
        }
        switch _error.domain {
            //=== NSURLErrorDomain（ネットワーク接続がないときにやってくる： Auth系など、-1009 で返ってくる場合）
            case  "NSURLErrorDomain":
                myErrorDisp.title = "NSURLErrorDomain"
                if let msg = _error.userInfo["NSLocalizedDescription"] as? String {
                    myErrorDisp.message = msg
                }
                return myErrorDisp
        default:
            myErrorDisp.message = "[\(_error.code)] \(_error.domain)"
        }
        return myErrorDisp
    }
}


public extension AWSMobileClientError {
    var dispError: String {
        switch self {
        case .aliasExists(let message):
            return "aliasExists: [\(message)]"
        case .codeDeliveryFailure(let message):
            return "codeDeliveryFailure: [\(message)]"
        case .codeMismatch(let message):
            return "codeMismatch: [\(message)]"
        case .expiredCode(let message):
            return "expiredCode: [\(message)]"
        case .groupExists(let message):
            return "groupExists: [\(message)]"
        case .internalError(let message):
            return "internalError: [\(message)]"
        case .invalidLambdaResponse(let message):
            return "invalidLambdaResponse: [\(message)]"
        case .invalidOAuthFlow(let message):
            return "invalidOAuthFlow: [\(message)]"
        case .invalidParameter(let message):
            return "invalidParameter: [\(message)]"
        case .invalidPassword(let message):
            return "invalidPassword: [\(message)]"
        case .invalidUserPoolConfiguration(let message):
            return "invalidUserPoolConfiguration: [\(message)]"
        case .limitExceeded(let message):
            return "limitExceeded: [\(message)]"
        case .mfaMethodNotFound(let message):
            return "mfaMethodNotFound: [\(message)]"
        case .notAuthorized(let message):
            return "notAuthorized: [\(message)]"
        case .passwordResetRequired(let message):
            return "passwordResetRequired: [\(message)]"
        case .resourceNotFound(let message):
            return "resourceNotFound: [\(message)]"
        case .scopeDoesNotExist(let message):
            return "scopeDoesNotExist: [\(message)]"
        case .softwareTokenMFANotFound(let message):
            return "softwareTokenMFANotFound: [\(message)]"
        case .tooManyFailedAttempts(let message):
            return "tooManyFailedAttempts: [\(message)]"
        case .tooManyRequests(let message):
            return "tooManyRequests: [\(message)]"
        case .unexpectedLambda(let message):
            return "unexpectedLambda: [\(message)]"
        case .userLambdaValidation(let message):
            return "userLambdaValidation: [\(message)]"
        case .userNotConfirmed(let message):
            return "userNotConfirmed: [\(message)]"
        case .userNotFound(let message):
            return "userNotFound: [\(message)]"
        case .usernameExists(let message):
            return "usernameExists: [\(message)]"
        case .unknown(let message):
            return "unknown: [\(message)]"
        case .notSignedIn(let message):
            return "notSignedIn: [\(message)]"
        case .identityIdUnavailable(let message):
            return "identityIdUnavailable: [\(message)]"
        case .guestAccessNotAllowed(let message):
            return "guestAccessNotAllowed: [\(message)]"
        case .federationProviderExists(let message):
            return "federationProviderExists: [\(message)]"
        case .cognitoIdentityPoolNotConfigured(let message):
            return "cognitoIdentityPoolNotConfigured: [\(message)]"
        case .unableToSignIn(let message):
            return "unableToSignIn: [\(message)]"
        case .invalidState(let message):
            return "invalidState: [\(message)]"
        case .userPoolNotConfigured(let message):
            return "userPoolNotConfigured: [\(message)]"
        case .userCancelledSignIn(let message):
            return "userCancelledSignIn: [\(message)]"
        case .badRequest(let message):
            return "badRequest: [\(message)]"
        case .expiredRefreshToken(let message):
            return "expiredRefreshToken: [\(message)]"
        case .errorLoadingPage(let message):
            return "errorLoadingPage: [\(message)]"
        case .securityFailed(let message):
            return "securityFailed: [\(message)]"
        case .idTokenNotIssued(let message):
            return "idTokenNotIssued: [\(message)]"
        case .idTokenAndAcceessTokenNotIssued(let message):
            return "idTokenAndAcceessTokenNotIssued: [\(message)]"
        case .invalidConfiguration(let message):
            return "invalidConfiguration: [\(message)]"
        case .deviceNotRemembered(let message):
            return "deviceNotRemembered: [\(message)]"
        }
    }
}

