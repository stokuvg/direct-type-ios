//
//  WithDrawalVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import TudApi
import SVProgressHUD
import AWSMobileClient

final class CheckBoxView: UIView {
    @IBOutlet private weak var imageView: UIImageView!
    
    var statusFlag = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1.5
        layer.borderColor = UIColor(colorType: .color_black)!.cgColor
    }
    
    func changeImageStatus() {
        statusFlag = !statusFlag
        let offImage = UIImage.init()
        let onImage = UIImage(named: "checkSelectedWhite")
        
        imageView.image = statusFlag ? onImage : offImage
    }
}

final class CheckBoxLabelView: UIView {
    @IBOutlet weak var checkBoxView: CheckBoxView!
    @IBOutlet private weak var textLabel: UILabel!
    
    func setup(text:String) {
        textLabel.text(text: text, fontType: .font_Sb, textColor: UIColor(colorType: .color_black)!, alignment: .center)
    }
}

final class WithDrawalVC: TmpBasicVC {
    @IBOutlet private weak var textLabel: UILabel!   // 退会確認文言
    // チェックボックス
    @IBOutlet private weak var checkBoxLabelView: CheckBoxLabelView!
    // 退会ボタン
    @IBOutlet private weak var drawalBtn: UIButton!
    @IBAction private func withdrawalAction() {
        if checkBoxLabelView.checkBoxView.statusFlag == true {
            withdrawalConfirmAlert()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension WithDrawalVC {
    func setup() {
        title = "退会手続き"
        
        let text = "本サービス（Direct type）からの退会手続きを行います。ご登録いただいた情報や設定は本退会を以てすべて削除され、復活できませんのでご注意ください。\n\nなお、本サービス（Direct type）からの退会手続きを行っても、転職サイトtypeのアカウントは退会（削除）されません。もし転職サイトtypeも退会を希望される方は、大変お手数ではございますが、転職サイトtypeのサイトにアクセスしていただき、サイトの設定ページよりお手続きいただけますと幸いです。"
        textLabel.text(text: text, fontType: .font_S, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        
        checkBoxLabelView.setup(text: "上記内容に同意しました。")
        let viewTouchup = UITapGestureRecognizer(target: self, action: #selector(statusChangeAction))
        checkBoxLabelView.addGestureRecognizer(viewTouchup)
        
        drawalStatusChange()
    }
    
    @objc
    func statusChangeAction() {
        checkBoxLabelView.checkBoxView.changeImageStatus()
        drawalStatusChange()
    }
    
    func drawalStatusChange() {
        let btnFlag = checkBoxLabelView.checkBoxView.statusFlag
        let onColor = UIColor(colorType: .color_alart)!
        let offColor = UIColor(colorType: .color_close)
        
        drawalBtn.setTitle(text: "退会する", fontType: .font_M, textColor: UIColor(colorType: .color_white)!, alignment: .center)
        drawalBtn.backgroundColor = btnFlag ? onColor : offColor
    }
    
    func tryWithdrawal() {
        SVProgressHUD.show()
        ApiManager.sendDeleteAccount()
        .done { _ in
            AnalyticsEventManager.track(type: .withdrawal)
            self.transitionToWithdrawalComplete()
            AWSMobileClient.default().signOut { (error) in
                if let error = error {
                    DispatchQueue.main.async {
                        self.showError(error)
                    }
                    return
                }
            }
        }
        .catch{ (error) in
            let myErr = AuthManager.convAnyError(error)
            self.showError(myErr)
        }
        .finally {
            SVProgressHUD.dismiss()
        }
    }
    
    func transitionToWithdrawalComplete() {
        let vc = self.getVC(sbName: "SettingVC", vcName: "WithDrawalCompleteVC") as! WithDrawalCompleteVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 退会確認アラート
    func withdrawalConfirmAlert() {
        let withdrawalConfirmAlertController = UIAlertController(title: "退会確認", message: "本当に退会します。よろしいですか？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "いいえ", style: .cancel)
        let okAction = UIAlertAction.init(title: "はい", style: .default) { (_) in
            self.tryWithdrawal()
        }
        withdrawalConfirmAlertController.addAction(cancelAction)
        withdrawalConfirmAlertController.addAction(okAction)
        
        navigationController?.present(withdrawalConfirmAlertController, animated: true, completion: nil)
    }
}
