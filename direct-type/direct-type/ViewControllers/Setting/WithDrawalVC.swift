//
//  WithDrawalVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class CheckBoxView: UIView {
    
    @IBOutlet weak var imageView:UIImageView!
    
    var statusFlag:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.init(colorType: .color_black)!.cgColor
    }
    
    func changeImageStatus() {
        statusFlag = !statusFlag
        let offImage = UIImage.init()
        let onImage = UIImage(named: "checkSelectedWhite")
        
        imageView.image = statusFlag ? onImage : offImage
    }
}

class CheckBoxLabelView: UIView {
    
    @IBOutlet weak var checkBoxView:CheckBoxView!
    
    @IBOutlet weak var textLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(text:String) {
        self.textLabel.text(text: text, fontType: .font_Sb, textColor: UIColor.init(colorType: .color_black)!, alignment: .center)
    }
}

class WithDrawalVC: TmpBasicVC {
    
    @IBOutlet weak var textLabel:UILabel!   // 退会確認文言
    
    // チェックボックス
    @IBOutlet weak var checkBoxLabelView:CheckBoxLabelView!
    
    // 退会ボタン
    @IBOutlet weak var drawalBtn:UIButton!
    @IBAction func withdrawalAction() {
        if checkBoxLabelView.checkBoxView.statusFlag == true {
            self.withdrawalConfirmAlert()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "退会手続き"
        
        let text:String = "本サービス（Direct type）からの退会手続きを行います。ご登録いただいた情報や設定は本退会を以てすべて削除され、復活できませんのでご注意ください。\n\nなお、本サービス（Direct type）からの退会手続きを行っても、転職サイトtypeのアカウントは退会（削除）されません。もし転職サイトtypeも退会を希望される方は、大変お手数ではございますが、転職サイトtypeのサイトにアクセスしていただき、サイトの設定ページよりお手続きいただけますと幸いです。"
        textLabel.text(text: text, fontType: .font_S, textColor: UIColor.init(colorType: .color_black)!, alignment: .left)
        
        checkBoxLabelView.setup(text: "上記内容に同意しました。")

        // Do any additional setup after loading the view.
        let viewTouchup = UITapGestureRecognizer.init(target: self, action: #selector(statusChangeAction))
        checkBoxLabelView.addGestureRecognizer(viewTouchup)
        
        self.drawalStatusChange()
    }
    
    @objc func statusChangeAction() {
        checkBoxLabelView.checkBoxView.changeImageStatus()
        
        drawalStatusChange()
    }
    
    private func drawalStatusChange() {
        let btnFlag = checkBoxLabelView.checkBoxView.statusFlag
        
        let onColor = UIColor.init(colorType: .color_alart)!
        let offColor = UIColor.init(colorType: .color_close)
        
        drawalBtn.setTitle(text: "退会する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        drawalBtn.backgroundColor = btnFlag ? onColor : offColor
    }
    
    // 退会確認アラート
    private func withdrawalConfirmAlert() {
        let withdrawalConfirmAlertController = UIAlertController.init(title: "退会確認", message: "本当に退会します。よろしいですか？", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "いいえ", style: .cancel) { (_) in
        }
        let okAction = UIAlertAction.init(title: "はい", style: .default) { (_) in
            // TODO:退会処理
            let vc = self.getVC(sbName: "SettingVC", vcName: "WithDrawalCompleteVC") as! WithDrawalCompleteVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        withdrawalConfirmAlertController.addAction(cancelAction)
        withdrawalConfirmAlertController.addAction(okAction)
        
        self.navigationController?.present(withdrawalConfirmAlertController, animated: true, completion: nil)
    }
    
}
