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
            print(token, task.result?.expirationTime) //Debug:
        })
        return token
    }
    var userState: UserState {
        return AWSMobileClient.default().currentUserState
    }
    public static let shared = AuthManager()
    private init() {
        AWSMobileClient.default().initialize() {_,_ in }
//        //=== idTokenをKeyChainStoreから読み取ってみる
//        if let val = MyKeychain.idToken.value() {
//            idToken = val
//        }
//        print(#line, #file, #function, idToken)
    }
}

extension AuthManager {
    class func needAuth(_ isNeedAuth: Bool) {
        //idTokenが必要なのに未取得だったり期限切れだったら取得を促すとかするならば、ここで噛ませれば良い感じで。
        if isNeedAuth { //そもそもトークン必要か？
            if let idToken = AuthManager.shared.idToken {
                TudApiAPI.customHeaders = ["Authorization": "Bearer \(idToken)"]
                } else {
                print("まだidToken取得していない")
            }
        } else {
            //print("認証不要なAPIを叩こうとしている") //この場合は idToken を除去っておく方が良いか？
            TudApiAPI.customHeaders.removeValue(forKey: "Authorization")
        }
    }
}
