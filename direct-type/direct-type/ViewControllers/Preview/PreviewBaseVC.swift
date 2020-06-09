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
    
    //ValidationError管理
    var dicGrpValidErrMsg: [MdlItemHTypeKey: [ValidationErrMsg]] = [:]//MdlItemH.type
    var dicValidErrMsg: [EditableItemKey: [ValidationErrMsg]] = [:] //[ItemEditable.item: ErrMsg]　（TODO：これもEditableBaseで管理にするか））
    
    @IBOutlet weak var tableVW: UITableView!
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        print(#line, #function, "＊オーバーライドして使う＊")
    }

    func validateLocalModel() -> Bool {
        if Constants.DbgSkipLocalValidate { return false }//[Dbg: ローカルValidationスキップ]
        ValidateManager.dbgDispCurrentItems(editableModel: editableModel) //[Dbg: 状態確認]
        let chkErr = ValidateManager.chkValidationErr(editableModel)
        self.dicValidErrMsg = chkErr
        self.dicGrpValidErrMsg = ValidateManager.makeGrpErrByItemErr(chkErr)
        if chkErr.count > 0 {
            print("＊＊＊　Validationエラー発生: \(chkErr.count)件　＊＊＊")
            var msg: String = ""
            for err in chkErr {
                msg = "\(msg)\(err.value)\n"
            }
//            self.showValidationError(title: "Validationエラー (\(chkErr.count)件)", message: msg)
//            /* Warning回避 */ .done { _ in } .catch { (error) in } .finally { } //Warning回避
            return true
        } else {
            print("＊＊＊　Validationエラーなし　＊＊＊")
            return false
        }
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
        chkButtonEnable()//ボタン死活チェック
    }
    func initData() {
    }
    func dispData() {
        title = "＊プレビュー＊"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispData()
        chkButtonEnable()//ボタン死活チェック
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func chkButtonEnable() {
        btnCommit.isEnabled = true ; return //!!!
        //=== 変更なければフェッチ不要
        if editableModel.editTempCD.count > 0 {
            btnCommit.isEnabled = true
        } else {
            btnCommit.isEnabled = false
        }
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
        let errMsg = dicGrpValidErrMsg[item.type.itemKey]?.joined(separator: "\n") ?? ""
        cell.initCell(item, editTempCD: editableModel.editTempCD, errMsg: errMsg)//編集中の値を表示適用させるためeditTempCDを渡す
        cell.dispCell()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        let item = arrData[indexPath.row]

        //プレビューから直接編集へ行ってよし
        if let skipEditMemoItem = item.childItems.first {
            let (isChange, editTemp) = editableModel.makeTempItem(skipEditMemoItem)
            let item: EditableItemH! = isChange ? editTemp : skipEditMemoItem
            switch skipEditMemoItem.editType {
            case .inputMemo:
                //さらに子ナビさせたいので
                let storyboard = UIStoryboard(name: "Edit", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubInputMemoVC") as? SubInputMemoVC{
                    nvc.initData(self, editableItem: item)
                    //遷移アニメーション関連
                    nvc.modalTransitionStyle = .coverVertical
                    self.present(nvc, animated: true) {}
                }
                return
            default:
                break
            }
        }
        switch item.type {
        case .lastJobExperimentH3, .jobExperimentsH3, .businessTypesH3:
            let storyboard = UIStoryboard(name: "Edit", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubEditSpecialVC") as? SubEditSpecialVC{
                var arrErrMsg: [EditableItemKey: [ValidationErrMsg]] = [:] //子画面に引き渡すエラー
                arrErrMsg = dicValidErrMsg //抜粋せずに、まるっと渡しておく
                nvc.initData(self, item, arrErrMsg)
                //遷移アニメーション関連
                nvc.modalTransitionStyle = .coverVertical
                self.present(nvc, animated: true) {
                }
            }
        default:
            let storyboard = UIStoryboard(name: "Edit", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubEditBaseVC") as? SubEditBaseVC{
                var arrErrMsg: [EditableItemKey: [ValidationErrMsg]] = [:] //子画面に引き渡すエラー
                arrErrMsg = dicValidErrMsg //抜粋せずに、まるっと渡しておく
                nvc.initData(self, item, arrErrMsg)
                //遷移アニメーション関連
                nvc.modalTransitionStyle = .coverVertical
                self.present(nvc, animated: true) {
                }
            }
        }
        //通常の複数編集画面
        let storyboard = UIStoryboard(name: "Edit", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubEditBaseVC") as? SubEditBaseVC{
            var arrErrMsg: [EditableItemKey: [ValidationErrMsg]] = [:] //子画面に引き渡すエラー
            arrErrMsg = dicValidErrMsg //抜粋せずに、まるっと渡しておく
            nvc.initData(self, item, arrErrMsg)
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
                if let item = editItem.childItems.filter({ (ei) -> Bool in
                    ei.editableItemKey == key
                }).first {
                    editableModel.changeTempItem(item, text: val)
                }
            }
        }
        chkButtonEnable()//ボタン死活チェック
        tableVW.reloadData()
    }
}

extension PreviewBaseVC: SubSelectFeedbackDelegate {
    func changedSelect(editItem: EditableItemH, codes: String) {
        editableModel.changeTempItem(editItem, text: codes)
        chkButtonEnable()//ボタン死活チェック
        tableVW.reloadData()
    }
    
    
}
