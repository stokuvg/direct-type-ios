//
//  PreviewBaseVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

//===[H-2]「個人プロフィール確認」
//===[H-3]「履歴書確認」
//===[C-15]「職務経歴書確認」
class PreviewBaseVC: TmpBasicVC {
    var editableModel: EditableModel = EditableModel() //画面編集項目のモデルと管理
    var arrData: [MdlItemH] = []

    @IBOutlet weak var tableVW: UITableView!
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        print(#line, #function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCommit.setTitle(text: "完了する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)

        //=== テーブル初期化
        self.tableVW.estimatedRowHeight = 100
        self.tableVW.rowHeight = UITableView.automaticDimension
        self.tableVW.register(UINib(nibName: "HPreviewTBCell", bundle: nil), forCellReuseIdentifier: "Cell_HPreviewTBCell")
        initData()
    }
    func initData() {
    }
    func dispData() {
        title = "個人プロフィール"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension PreviewBaseVC: UITableViewDataSource, UITableViewDelegate {
    //=== 通常テーブル
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = arrData[indexPath.row]
        let cell: HPreviewTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HPreviewTBCell", for: indexPath) as! HPreviewTBCell
        cell.initCell(item, editTempCD: editableModel.editTempCD)//編集中の値を表示適用させるためeditTempCDを渡す
        cell.dispCell()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        let item = arrData[indexPath.row]

        //プレビューから直接編集へ行ってよし
        if let skipEditMemoItem = item.childItems.first {
            switch skipEditMemoItem.editType {
            case .inputMemo:
                //さらに子ナビさせたいので
                let storyboard = UIStoryboard(name: "Edit", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubInputMemoVC") as? SubInputMemoVC{
                    nvc.initData(editableItem: skipEditMemoItem)
                    //遷移アニメーション関連
                    nvc.modalTransitionStyle = .coverVertical
                    self.present(nvc, animated: true) {}
                }
                return
            default:
                break
            }
        }
        //通常の複数編集画面
        let storyboard = UIStoryboard(name: "Edit", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubEditBaseVC") as? SubEditBaseVC{
            nvc.initData(self, item)
            //遷移アニメーション関連
            nvc.modalTransitionStyle = .coverVertical
            self.present(nvc, animated: true) {
            }
        }
    }
}


extension PreviewBaseVC: nameEditableTableBasicDelegate {
    func changedSelect(editItem: MdlItemH, editTempCD: [EditableItemKey : EditableItemCurVal]) {
        //=== 消し込み対応のため、子項目をなめて変更点を適用する
        if editTempCD.count > 0 {
            for (key, val) in editTempCD {
                if let item = editItem.childItems.filter { (ei) -> Bool in
                    ei.editableItemKey == key
                }.first {
                    editableModel.changeTempItem(item, text: val)
                }
            }
        }
//        //元のchildItemsに適用しないと表示更新されないな...
//        for mdlItem in arrData {
//            for (n, item) in mdlItem.childItems.enumerated() {
//                //変更あるかチェック
//                if let temp = editTempCD[item.editableItemKey] {
//                    print("\t#\(n): \(item.debugDisp)")
//                }
//            }
//        }
        tableVW.reloadData()
    }
}
