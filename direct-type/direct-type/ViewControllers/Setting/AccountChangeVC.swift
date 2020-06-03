//
//  AccountChangeVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

enum inputTelphoneErrorType {
    case none
    case empty
    case sameNumber
}

class AccountChangeVC: TmpBasicVC {
    
    @IBOutlet weak var cautionLabel:UILabel!
    
    @IBOutlet weak var inputField:UITextField!
    
    @IBOutlet weak var nextBtn:UIButton!
    @IBAction func nextBtnAction() {
        self.telephoneNumberCheck()
    }

    var telNoString:String = ""
    var displayTelNo:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "アカウント変更"
        
        nextBtn.setTitle(text: "次へ", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        
        let cautionText = self.makeCautionText(text:telNoString)
        
        self.cautionLabel.attributedText = cautionText
        
        inputField.font = UIFont.init(fontType: .font_L)
        inputField.textColor = UIColor.init(colorType: .color_black)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setup(data:[String:Any]) {
        let telNo = data["telNo"] as! String
        
        displayTelNo = telNo
        telNoString = self.changeTelephoneNumber()
    }
    
    private func makeCautionText(text:String) -> NSMutableAttributedString {
        let cautionText = NSMutableAttributedString.init()
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(colorType: .color_black) as Any,
            .font: UIFont.init(fontType: .font_Sb) as Any
        ]
        let titleText = NSAttributedString(string: "アカウント変更には携帯電話番号の認証が必要です。\n", attributes: titleAttributes)
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(colorType: .color_black) as Any,
            .font: UIFont.init(fontType: .font_S) as Any
        ]
        let text1 = NSAttributedString(string: "\n現在の認証済み番号 ", attributes: textAttributes)
        let text2 = NSAttributedString(string: " を変更する場合は、新しい電話番号を入力してください。認証コードを送信します。", attributes: textAttributes)
        
        let telAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(colorType: .color_sub) as Any,
            .font: UIFont.init(fontType: .font_S) as Any
        ]
        let textTelNo = NSAttributedString(string: text, attributes: telAttributes)
        
        cautionText.append(titleText)
        cautionText.append(text1)
        cautionText.append(textTelNo)
        cautionText.append(text2)
        
        return cautionText
    }
    
    private func changeTelephoneNumber() -> String {
        let tel:NSMutableString = NSMutableString.init()
        let cutArray = displayTelNo.components(separatedBy: "-")
        for i in 0..<cutArray.count {
            let item = cutArray[i]
            tel.append(item)
        }
        return tel as String
    }
    
    private func makeErrorMessage(errorType: inputTelphoneErrorType) -> String {
        var errorMessage:String = ""
        
        switch errorType {
            case .none:
                errorMessage = ""
            case .empty:
                errorMessage = "電話番号が入力されていません"
            case .sameNumber:
                errorMessage = "入力された番号が変わっていません"
        }
        
        return errorMessage
    }
    
    private func telephoneNumberCheck() {
        var errorType:inputTelphoneErrorType = .none
        if inputField.text?.count == 0 {
            // 空入力チェック
            errorType = .empty
        } else if inputField.text == telNoString {
            // 電話番号変更チェック
            errorType = .sameNumber
        } else {
            errorType = .none
        }
        
        // エラーがある場合アラートを表示
        if errorType == .empty {
            let errorMessage = self.makeErrorMessage(errorType:errorType)
            let errorAlert = UIAlertController.init(title: "エラー", message: errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default) { (_) in
            }
            errorAlert.addAction(okAction)
            self.navigationController?.present(errorAlert, animated: true, completion: nil)
        } else if errorType == .sameNumber {
            // TODO:ニックネームを保存して設定Topへ
            self.navigationController?.popViewController(animated: true)
        } else if errorType == .none {
            // エラーが無い場合通信処理
            // SMS認証
            let vc = getVC(sbName: "SettingVC", vcName: "AccountChangeCompleteVC") as! AccountChangeCompleteVC
            vc.telPhone = telNoString
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
