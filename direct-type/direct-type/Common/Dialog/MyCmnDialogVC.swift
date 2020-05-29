//
//  TestDialogVC.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/03/06.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import UIKit

class MyCmnDialogVC: BaseVC {
    var dlgItem: DlgDetail!

    @IBOutlet weak var stackActionArea: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblMessageDmy: UILabel! //サイズ計算を手軽に実施するためのラベル
    @IBOutlet weak var btnBackground: UIButton!
    @IBAction func actBackground(_ sender: Any) {
        //self.dismiss(animated: true) {}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    //=== 初期処理
    func initData(item: DlgDetail) {
        dlgItem = item
    }
    func dispData() {
        lblTitle.text = dlgItem.title
        lblMessage.text = dlgItem.message
        lblMessageDmy.text = dlgItem.message
        // 既存ボタンを削除してから
        for asv in stackActionArea.arrangedSubviews {
            stackActionArea.removeArrangedSubview(asv)
            asv.removeFromSuperview()
        }
        // スタックの向きを変更（この場合には、reverseして足すのが良いのかも）
        var items = dlgItem.buttons
        var axisType = dlgItem.axisType
        if items.count >= 3 { axisType = .vertical}//ただし3件以上のボタンなら強制的に縦にする
        switch axisType {
        case .horizontal:
            stackActionArea.axis = .horizontal
        case .vertical:
            stackActionArea.axis = .vertical
            items = items.reversed()
        }
          // ボタンを登録していく
        for item in items {
            let btn = DlgStackButton(item, self)
            stackActionArea.addArrangedSubview(btn)
        }
    }
}

extension MyCmnDialogVC: DlgStackButtonProtocol {
    func actDlgButton(_ item: DlgActionItem) {
        if let dlgCompletion = item.completion {
            self.dismiss(animated: true) {//このダイアログを閉じたときに、指定のcompletionを実行する
                dlgCompletion()
            }
        } else {
            self.dismiss(animated: true) {}
        }
    }
}
