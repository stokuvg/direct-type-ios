//
//  AuthManager.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/22.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import AWSMobileClient
import TudApi

extension AuthManager {
    internal enum AuthSuccess {
        case signin(SignInResult)
        case signinToken(String)

        case signup(SignUpResult)
        case signupNeedConfirm(SignUpResult)
    }
    internal enum AuthError: Error {
        case signinUserNotConfirmed(String)
        case signinError(Error)

        case signupUserNotConfirmed(String)
        case signupUsernameExists(String)
        case signupError(Error)
    }
}

final public class AuthManager {
    var idToken: String? {
        var token: String? = nil
        AWSCognitoIdentityUserPool.default().currentUser()?.getSession()
        .continueOnSuccessWith(block: { (task) -> Void in
            token = task.result?.idToken?.tokenString
//            Log.selectLog(logLevel: .debug, "token:\(String(describing: token))")
        })
        return token
    }
    var userState: UserState {
        return AWSMobileClient.default().currentUserState
    }
    public static let shared = AuthManager()
    private init() {
        AWSMobileClient.default().initialize() {_,_ in }
    }
    func updateSub() {
        AWSMobileClient.default().getTokens { (tokens, _) in
            if let _claims = tokens?.accessToken?.claims {
                if let sub = _claims["sub"] as? String {
                    self._sub = sub
                }
            } else {
                self._sub = ""
            }
        }
    }
    var isLogin: Bool {
        AWSMobileClient.default().getTokens { (tokens, error) in
            //LogManager.appendLoginCheckLog("isLogin", tokens, error, #function, #line)
            if let _error = error as? NSError{
                Log.selectLog(logLevel: .debug, "_error:\(_error.localizedDescription)")
                Log.selectLog(logLevel: .debug, "userInfo:\(_error.userInfo.description)")
            }
            self.updateSub()//sub値の更新をしておく
        }
        return (userState == .signedIn)
//        return (userState == .signedIn) && !((AuthManager.shared.idToken ?? "").isEmpty)//これだと #143 が発生する（アプリ再起動時に1時間経過でidTokenが期限切でも、そのままエラーリトライでリフレッシュトークンにより再発行されるので、signedIn状態のみチェックでOK）
    }
    private var _sub: String = ""//isLoginタイミングでsubも更新・保持させておく
    var sub: String {
        get { return _sub }
    }
}

extension AuthManager {
    class func needAuth(_ isNeedAuth: Bool) {
        TudApiAPI.basePath = AppDefine.tudApiServer
        //idTokenが必要なのに未取得だったり期限切れだったら取得を促すとかするならば、ここで噛ませれば良い感じで。
        if isNeedAuth { //そもそもトークン必要か？
            if let idToken = AuthManager.shared.idToken {
                TudApiAPI.customHeaders = ["Authorization": "Bearer \(idToken)"]
            } else {
                AWSMobileClient.default().getTokens { (tokens, error) in
                    if let _error = error as? NSError{
                        Log.selectLog(logLevel: .debug, "_error:\(_error.localizedDescription)")
                        Log.selectLog(logLevel: .debug, "userInfo:\(_error.userInfo.description)")
                    }
                }
            }
        } else {
            //print("認証不要なAPIを叩こうとしている") //この場合は idToken を除去っておく方が良いか？
            TudApiAPI.customHeaders.removeValue(forKey: "Authorization")
        }
    }
}



