//
//  SubInputMemoVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/15.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class SubInputMemoVC: BaseVC {
    var editableItem: EditableItemH!
    var delegate: SubSelectFeedbackDelegate? = nil

    @IBOutlet weak var vwHead: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func actBack(_ sender: UIButton) {
        actPopupCancel()
    }
    @IBOutlet weak var vwInfoArea: UIView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var vwInfoCountArea: UIView!
    @IBOutlet weak var lblInfoText: UILabel!
    @IBOutlet weak var vwInfoTextArea: UIView!

    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var textVW: UITextView!
    
    @IBOutlet weak var vwFoot: UIView!
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        let bufText: String = textVW.text ?? ""
        //文字数制限がある場合、オーバーしてたら却下する
        let maxCount = editableItem.editItem.valid.max ?? 0
        if maxCount > 0 {
            if bufText.count > maxCount {
                return
            }
        }
        actPopupSelect(text: bufText)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //====デザイン適用
        view.backgroundColor = UIColor(colorType: .color_base)!
        let colHead = UIColor.black //UIColor(colorType: .color_main)!
        vwHead.backgroundColor = colHead
        vwInfoArea.backgroundColor = colHead
        vwInfoTextArea.backgroundColor = colHead
        vwInfoCountArea.backgroundColor = colHead
        
        vwMain.backgroundColor = UIColor(colorType: .color_base)!
        vwFoot.backgroundColor = UIColor(colorType: .color_base)!
        textVW.textColor = UIColor(colorType: .color_black)
        textVW.font = UIFont.systemFont(ofSize: 18)
        textVW.backgroundColor = UIColor(colorType: .color_white)
        btnCommit.setTitle(text: "この内容で保存", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor(colorType: .color_button)
        //===ソフトウェアキーボードに〔閉じる〕ボタン付与
        let rect = CGRect(origin: CGPoint.zero, size: CGSize.init(width: 60, height: 45))
        let toolbar = UIToolbar(frame: rect)//Autolayout補正かかるけど、そこそこの横幅指定が必要
        let separator1 = IKBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnClose = IKBarButtonItem.init(title: "閉じる", style: .done, target: self, action: #selector(actInputCancelButton))
        //let btnSelect = IKBarButtonItem.init(title: "この内容で保存", style: .done, target: self, action: #selector(actInputSelectButton))
        //toolbar.setItems([btnClose, separator1, btnSelect], animated: true)
        toolbar.setItems([btnClose, separator1], animated: true)
        textVW.inputAccessoryView = toolbar
    }
    @objc func actInputCancelButton(_ sender: IKBarButtonItem) {
        self.view.endEditing(true)
    }
    @objc func actInputSelectButton(_ sender: IKBarButtonItem) {
        self.view.endEditing(true)
        self.actCommit(btnCommit)
    }

    func initData(_ delegate: SubSelectFeedbackDelegate, editableItem: EditableItemH) {
        self.delegate = delegate
        self.editableItem = editableItem
    }
    func dispData() {
        let bufTitle: String = "\(editableItem.dispName)"
        lblTitle.text(text: bufTitle, fontType: .font_L, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        textVW.text = editableItem.curVal
        var bufInfoText: String = ""
        switch editableItem.editableItemKey {
        case EditItemMdlEntry.exQuestionAnswer1.itemKey: fallthrough
        case EditItemMdlEntry.exQuestionAnswer2.itemKey: fallthrough
        case EditItemMdlEntry.exQuestionAnswer3.itemKey:
            bufInfoText = editableItem.exQuestion
        default:
            bufInfoText = editableItem.editItem.placeholder
        }
        lblInfoText.text(text: bufInfoText, fontType: .font_S, textColor: UIColor.init(colorType: .color_white)!, alignment: .left)
        dispCount()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textVW.becomeFirstResponder()
    }
    //=== Notification通知の登録 ===
    // 画面遷移時にも取り除かないもの（他の画面で変更があった場合の更新のため）
    override func initNotify() {
    }
    // この画面に遷移したときに登録するもの
    override func addNotify() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    // 他の画面に遷移するときに消して良いもの
    override func removeNotify() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc func keyboardDidShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let rect = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            let safeAreaB = self.view.safeAreaInsets.bottom
            let szKeyBoard = rect.size
            let szFoot = vwFoot.frame.size
            textVW.contentInset.bottom = szKeyBoard.height - szFoot.height + safeAreaB
        }
    }
    @objc func keyboardDidHide(notification: NSNotification) {
      textVW.contentInset.bottom = 0
    }
    //=======================================================================================================

    private func dispCount() {
        btnCommit.isEnabled = true
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
        let maxCount = editableItem.editItem.valid.max ?? 0
        if maxCount > 0 {
            let curCount = textVW.text.count
            let bufCount = "\(curCount)/\(maxCount)文字"
            //文字数超過時のリアルタイム表示フィードバック
            if curCount > maxCount {
                lblCount.text(text: bufCount, fontType: .font_SSS, textColor: UIColor.init(colorType: .color_sub)!, alignment: .right)
                textVW.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
                btnCommit.isEnabled = false //ボタン押下も禁止しておく
                btnCommit.backgroundColor = UIColor(colorType: .color_close)
            } else {
                lblCount.text(text: bufCount, fontType: .font_SSS, textColor: UIColor.init(colorType: .color_white)!, alignment: .right)
                textVW.backgroundColor = UIColor(colorType: .color_white)
            }
        } else {
            lblCount.text = nil
        }
    }
}

//=== テキスト入力したものの確定処理 ===
extension SubInputMemoVC {
    func actPopupSelect(text: String) {
        self.delegate?.changedSelect(editItem: self.editableItem, codes: text)
        self.dismiss(animated: true) { }
    }
    func actPopupCancel() {
        self.dismiss(animated: true) { }
    }
}

//===テキストのリアルタイム文字カウントに対応させる
extension SubInputMemoVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        dispCount()
    }
    //func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //    //入力適用前の文字列に、入力予定の範囲と文字列を事前適用してみる。（false返せば入力却下が可能）
    //    if let curBuf = textView.text, let _range = Range(range, in: curBuf) {
    //        let newBuf = curBuf.replacingCharacters(in: _range, with: text)
    //        let maxCount = editableItem.editItem.valid.max ?? 0
    //        if maxCount > 0 {
    //            //リアルタイムに入力を抑止する場合
    //            if newBuf.count > maxCount { //NOTE: フリック入力なら問題なし。ローマ字入力の場合など未確定段階で制限かかる
    //                return false
    //            }
    //        }
    //    }
    //    return true
    //}
}

