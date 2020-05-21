//
//  SubSelectBaseVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/21.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit


protocol SubSelectBaseDelegate {
    func actPopupSelect(selectedItemsCode: String)
    func actPopupCancel()
}
class SubSelectBaseVC: BaseVC {
    var editableItem: EditableItemH!
    var arrData: [CodeDisp] = []
    var dicChange: [String: Bool] = [:]  //CodeDisp.code : true
    var mainTsvMaster: SelectItemsManager.TsvMaster = .undefine

    @IBOutlet weak var vwHead: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func actBack(_ sender: UIButton) {
        actPopupCancel()
    }

    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var tableVW: UITableView!
    
    @IBOutlet weak var vwFoot: UIView!
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        //Single
        let selCode: String = dicChange.first?.key ?? ""  //単一選択のため
        actPopupSelect(selectedItemsCode: selCode)
        print(#line, #function, "[selCode: \(selCode)]")

        //Multi
        var bufResult: String = ""
        let arr = dicChange.filter { (cb) -> Bool in
            cb.value
        }
        var arrResult: [String] = []
        for item in arr {
            arrResult.append(item.key)
        }
        bufResult = arrResult.joined(separator: "_")
        print(#line, #function, "[bufResult: \(bufResult)]")
        actPopupSelect(selectedItemsCode: bufResult)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //====デザイン適用
        vwHead.backgroundColor = UIColor.init(colorType: .color_main)!
        vwMain.backgroundColor = UIColor.init(colorType: .color_white)!
        vwFoot.backgroundColor = UIColor.init(colorType: .color_main)!
        btnCommit.setTitle(text: "選択", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
    }
}

//=== 単一選択ポップアップで選択させる場合の処理 ===
extension SubSelectBaseVC: SubSelectBaseDelegate {
    func actPopupSelect(selectedItemsCode: String) {
        print("\t🐼🐼[\(selectedItemsCode)]🐼これが選択されました🐼🐼")//編集中の値の保持（と描画）
        for item in SelectItemsManager.convCodeDisp(mainTsvMaster, selectedItemsCode) {
            print(item.debugDisp)
        }
//        self.dismiss(animated: true) { }
    }
    func actPopupCancel() {
        self.dismiss(animated: true) { }
    }
}

