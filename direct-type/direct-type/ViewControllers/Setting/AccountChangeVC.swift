//
//  AccountChangeVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient
import SVProgressHUD

final class AccountChangeVC: TmpBasicVC {
    @IBOutlet private weak var cautionLabel: UILabel!
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet private weak var nextBtn: UIButton!
    @IBAction private func nextBtnAction() {
        postNewPhoneNumber()
    }

    private var existingPhoneNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func configure(data: [String:Any]) {
        let telNo = data["telNo"] as! String
        existingPhoneNumber = extractNumbers(from: telNo)
    }
}

private extension AccountChangeVC {
    func setup() {
        title = "アカウント変更"
        cautionLabel.attributedText = makeCautionText(text: existingPhoneNumber)
        inputField.font = UIFont(fontType: .font_L)
        inputField.textColor = UIColor(colorType: .color_black)
        inputField.addTarget(self, action: #selector(changeButtonState), for: .editingChanged)
        nextBtn.setTitle(text: "次へ", fontType: .font_M, textColor: UIColor(colorType: .color_white)!, alignment: .center)
        changeButtonState()
    }
    
    var isValidPhoneNumber: Bool {
        guard let inputText = inputField.text, !inputText.isEmpty else { return false }
        return true
    }
    
    func postNewPhoneNumber() {
        // FIXME: プロトタイピング時の動作確認用に強制的に認証画面へ遷移させる
        let vc = getVC(sbName: "SettingVC", vcName: "AccountChangeCompleteVC") as! AccountChangeCompleteVC
        navigationController?.pushViewController(vc, animated: true)

        guard let inputText = inputField.text, inputText != existingPhoneNumber else {
            // 既存の電話番号と同じだった場合はニックネームを保存して設定Topへ
            // TODO: ニックネームの保存処理を追加
            navigationController?.popViewController(animated: true)
            return
        }
        // TODO: サーバー側で電話番号変更API実装後に疎通実装を行う
//        let param = UpdatePhoneNumberRequestDTO(phoneNumber: inputText)
//        SVProgressHUD.show()
//        ApiManager.postPhoneNumber(param)
//        .done { result in
//            let vc = getVC(sbName: "SettingVC", vcName: "AccountChangeCompleteVC") as! AccountChangeCompleteVC
//            vc.telPhone = number
//            navigationController?.pushViewController(vc, animated: true)
//        }
//        .catch { (error) in
//            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
//            print("電話番号登録エラー コード: \(myErr.code)")
//        }
//        .finally {
//            SVProgressHUD.dismiss()
//        }
    }
    
    func extractNumbers(from text: String) -> String {
        let tel = NSMutableString()
        let cutArray = text.components(separatedBy: "-")
        for i in 0..<cutArray.count {
            let item = cutArray[i]
            tel.append(item)
        }
        return tel as String
    }
    
    @objc
    func changeButtonState() {
        nextBtn.isEnabled = isValidPhoneNumber
        nextBtn.backgroundColor = UIColor(colorType: isValidPhoneNumber ? .color_button : .color_line)
    }
    
    func makeCautionText(text: String) -> NSMutableAttributedString {
        let cautionText = NSMutableAttributedString()
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(colorType: .color_black) as Any,
            .font: UIFont(fontType: .font_Sb) as Any
        ]
        let titleText = NSAttributedString(string: "アカウント変更には携帯電話番号の認証が必要です。\n", attributes: titleAttributes)
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(colorType: .color_black) as Any,
            .font: UIFont(fontType: .font_S) as Any
        ]
        let text1 = NSAttributedString(string: "\n現在の認証済み番号 ", attributes: textAttributes)
        let text2 = NSAttributedString(string: " を変更する場合は、新しい電話番号を入力してください。認証コードを送信します。", attributes: textAttributes)
        
        let telAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(colorType: .color_sub) as Any,
            .font: UIFont(fontType: .font_S) as Any
        ]
        let textTelNo = NSAttributedString(string: text, attributes: telAttributes)
        
        cautionText.append(titleText)
        cautionText.append(text1)
        cautionText.append(textTelNo)
        cautionText.append(text2)
        
        return cautionText
    }
}
