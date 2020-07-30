//
//  EntryCompleteVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class EntryCompleteVC: TmpBasicVC {

    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var vwFootArea: UIView!
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "応募完了"
        navigationItem.hidesBackButton = true//〔戻る〕ボタン非表示にする
        //===デザイン適用
        self.view.backgroundColor = UIColor(colorType: .color_base)
        self.vwMainArea.backgroundColor = UIColor(colorType: .color_base)
        self.vwFootArea.backgroundColor = UIColor(colorType: .color_base)

        btnCommit.setTitle(text: "求人情報へ", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
        
        let bufMessage = [
            "応募が完了しました。",
            "企業から連絡がありましたら、応募時のメールアドレスへ転職サイトtypeよりお知らせが届きます。",
            "しばらくお待ちください。",
        ].joined(separator: "\n")
        lblMessage.text(text: bufMessage, fontType: .font_M, textColor: UIColor(colorType: .color_black)!, alignment: .center)
    }
    


}
