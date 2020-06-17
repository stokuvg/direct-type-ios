//
//  AccountChangeCompleteVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

enum inputCodeErrorType {
    case none
    case empty
    case few
}

class AccountChangeCompleteVC: TmpBasicVC {
    @IBOutlet private weak var infomationLabel:UILabel! // 見出し
    @IBOutlet private weak var textLabel:UILabel!       // 注釈
    @IBOutlet private weak var inputCodeField:UITextField!
    @IBOutlet private weak var sendBtn:UIButton!
    @IBAction private func sendBtnAction() {
        sendCodeAction()
    }
    @IBOutlet private weak var reSendBtn:UIButton!
    @IBAction private func reSendBtnAction() {
        if sendErrorFlag {
            reSendTelPhoneNumber()
        }
    }
    
    private let maxLength: Int = 6
    private var authCode: Int?
    private var sendErrorFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configure(with code: Int) {
        authCode = code
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
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChangeSelection(notification:)), name: UITextField.textDidChangeNotification, object: inputCodeField)
        
        sendBtn.setTitle(text: "次へ", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        reSendBtn.setTitle(text: "電話番号の再送信", fontType: .font_SS, textColor: UIColor.init(colorType: .color_sub)!, alignment: .right)
        inputCodeField.becomeFirstResponder()
    }
    
    @objc
    func textFieldDidChangeSelection(notification: NSNotification) {
        let textField = notification.object as! UITextField
        if let text = textField.text {
            if textField.markedTextRange == nil && text.count > maxLength {
                textField.text = text.prefix(maxLength).description
            }
        }
    }
    
    // 送信処理
    func sendCodeAction() {
            
            var errorType:inputCodeErrorType = .none
            // コード番号 チェック
            if inputCodeField.text?.count != maxLength {
                // アラート
                errorType = .few
            } else if inputCodeField.text?.count == 0 {
                errorType = .empty
            }
            
            if errorType != .none {
                var errorString = ""
                switch errorType {
                    case .none:
                        errorString = ""
                    case .empty:
                        errorString = "コード番号が入力されていません。"
                    case .few:
                        errorString = "コード番号の桁が違います。"
                }
                let sendCodeError = UIAlertController.init(title: "コードエラー", message: errorString, preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "OK", style: .default) { (_) in
                }
                sendCodeError.addAction(okAction)
                
                self.navigationController?.present(sendCodeError, animated: true, completion: nil)
            } else {
                // TODO:変更認証送信
                
                // 設定TOPに戻る
    //            Log.selectLog(logLevel: .debug, "viewControllers:\(String(describing: self.navigationController?.viewControllers))")
                self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
            }
        }
    
    // 再送信処理
    func reSendTelPhoneNumber() {
        // TODO:再送信処理を実行
        // 成功後、アラートを出す。
        let sendSuccessAlert = UIAlertController.init(title: "認証コード再送信", message: "再送しました。", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (_) in
        }
        sendSuccessAlert.addAction(okAction)
        
        navigationController?.present(sendSuccessAlert, animated: true, completion: nil)
    }
}
