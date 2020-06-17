//
//  AccountChangeCompleteVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class AccountChangeCompleteVC: TmpBasicVC {
    @IBOutlet private weak var infomationLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var inputCodeField: UITextField!
    @IBOutlet private weak var sendBtn: UIButton!
    @IBAction private func sendBtnAction() {
        validateCode()
    }
    @IBOutlet private weak var reSendBtn: UIButton!
    @IBAction private func reSendBtnAction() {
        if sendErrorFlag {
            reSendTelPhoneNumber()
        }
    }
    
    private let codeMaxLength: Int = 6
    private var authCode: String?
    private var sendErrorFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configure(with code: String) {
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
        inputCodeField.addTarget(self, action: #selector(changeButtonState), for: .editingChanged)
        
        sendBtn.setTitle(text: "次へ", fontType: .font_M, textColor: UIColor(colorType: .color_white)!, alignment: .center)
        reSendBtn.setTitle(text: "電話番号の再送信", fontType: .font_SS, textColor: UIColor(colorType: .color_sub)!, alignment: .right)
        inputCodeField.becomeFirstResponder()
        
        changeButtonState()
    }
    
    var isValidInputText: Bool {
        guard let inputText = inputCodeField.text, inputCodeField.markedTextRange == nil, inputText.count == codeMaxLength else { return false }
        return true
    }
    
    @objc
    func changeButtonState() {
        sendBtn.backgroundColor = UIColor(colorType: isValidInputText ? .color_sub : .color_line)
        sendBtn.isEnabled = isValidInputText
        guard let inputText = inputCodeField.text, isValidInputText else { return }
        inputCodeField.text = inputText.prefix(codeMaxLength).description
    }
    
    func validateCode() {
        guard let inputText = inputCodeField.text, let authCode = authCode, inputText == authCode else {
            let invalidCodeAlert = UIAlertController(title: "コードエラー", message: "コードが一致しませんでした", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            invalidCodeAlert.addAction(okAction)
            navigationController?.present(invalidCodeAlert, animated: true, completion: nil)
            return
        }
        guard let settingTop = navigationController?.viewControllers.first(where: { $0 is SettingVC }) as? SettingVC else { return }
        navigationController?.popToViewController(settingTop, animated: true)
    }
    
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
