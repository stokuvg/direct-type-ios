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
    
    @IBOutlet weak var vwMainArea: UIView!
    @IBOutlet weak var tableVW: UITableView!
    @IBOutlet weak var vwFootArea: UIView!
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        print(#line, #function, "＊オーバーライドして使う＊")
    }

    func validateLocalModel() -> Bool {
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
        //===デザイン適用
        self.view.backgroundColor = UIColor(colorType: .color_base)
        self.vwMainArea.backgroundColor = UIColor(colorType: .color_base)
        self.vwFootArea.backgroundColor = UIColor(colorType: .color_base)
        self.tableVW.backgroundColor = UIColor(colorType: .color_base)
        btnCommit.setTitle(text: "完了する", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)

        //=== テーブル初期化
        self.tableVW.estimatedRowHeight = 100
        self.tableVW.rowHeight = UITableView.automaticDimension
        //[C-9系]
        self.tableVW.register(UINib(nibName: "EntryFormInfoTextTBCell", bundle: nil), forCellReuseIdentifier: "Cell_EntryFormInfoTextTBCell")
        self.tableVW.register(UINib(nibName: "EntryFormExQuestionsHeadTBCell", bundle: nil), forCellReuseIdentifier: "Cell_EntryFormExQuestionsHeadTBCell")
        self.tableVW.register(UINib(nibName: "EntryFormExQuestionsItemTBCell", bundle: nil), forCellReuseIdentifier: "Cell_EntryFormExQuestionsItemTBCell")
        self.tableVW.register(UINib(nibName: "EntryFormAnyModelTBCell", bundle: nil), forCellReuseIdentifier: "Cell_EntryFormAnyModelTBCell")
        self.tableVW.register(UINib(nibName: "EntryFormJobCardTBCell", bundle: nil), forCellReuseIdentifier: "Cell_EntryFormJobCardTBCell")
        self.tableVW.register(UINib(nibName: "HPreviewTBCell", bundle: nil), forCellReuseIdentifier: "Cell_HPreviewTBCell")
        //[C-12系]
        self.tableVW.register(UINib(nibName: "EntryConfirmNotifyEntry1TBCell", bundle: nil), forCellReuseIdentifier: "Cell_EntryConfirmNotifyEntry1TBCell")
        self.tableVW.register(UINib(nibName: "EntryConfirmNotifyEntry2TBCell", bundle: nil), forCellReuseIdentifier: "Cell_EntryConfirmNotifyEntry2TBCell")
        self.tableVW.register(UINib(nibName: "EntryConfirmJobCardTBCell", bundle: nil), forCellReuseIdentifier: "Cell_EntryConfirmJobCardTBCell")
        self.tableVW.register(UINib(nibName: "EntryConfirmAnyModelTBCell", bundle: nil), forCellReuseIdentifier: "Cell_EntryConfirmAnyModelTBCell")

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
//        btnCommit.isEnabled = true ; return //!!!
        //=== 変更なければフェッチ不要
        if editableModel.editTempCD.count > 0 {
            btnCommit.isEnabled = true
        } else {
            btnCommit.isEnabled = false
        }
    }
    func fetchCompletePopVC() { //フェッチ完了時に画面を戻す処理
        self.navigationController?.popViewController(animated: true)

//        showConfirm(title: "登録完了", message: "登録が完了しました", onlyOK: true)
//        /* Warning回避 */ .done { _ in
//            self.navigationController?.popViewController(animated: true)
//        } .catch { (error) in } .finally { } //Warning回避
    }
}

extension PreviewBaseVC: UITableViewDataSource, UITableViewDelegate {
    //=== 通常テーブル
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = arrData[indexPath.row]
        switch item.type {
//        case .jobCardC9:
        case .profileC9: fallthrough
        case .resumeC9: fallthrough
        case .careerC9:
            let cell: EntryFormAnyModelTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_EntryFormAnyModelTBCell", for: indexPath) as! EntryFormAnyModelTBCell
//            cell.initCell()
//            cell.dispCell()
            return cell

//        case .exQuestionC9:
        default:
            let cell: HPreviewTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HPreviewTBCell", for: indexPath) as! HPreviewTBCell
            let errMsg = dicGrpValidErrMsg[item.type.itemKey]?.joined(separator: "\n") ?? ""
            cell.initCell(item, editTempCD: editableModel.editTempCD, errMsg: errMsg)//編集中の値を表示適用させるためeditTempCDを渡す
            cell.dispCell()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        let item = arrData[indexPath.row]

        //================================================
        //モデル引き渡しによる画面遷移の得例対応
        switch item.type {
        case .jobCardC9:
            return //遷移なし。以後の処理はパス
        case .profileC9:
            pushViewController(.profilePreviewH2)
            return //遷移させたので以後の処理はパス
        case .resumeC9:
            pushViewController(.resumePreviewH3)
            return //遷移させたので以後の処理はパス
        case .careerC9:
            pushViewController(.careerListC)
            return //遷移させたので以後の処理はパス
        default:
            break
        }
        //================================================
        //子項目が1つの場合には、直接編集へ移動させる場合：
        let items = item.childItems
        switch items.count {
        case 0:
            break
        case 1: //プレビューから直接編集へ行ってよし
            let _item = items.first!
            let (_, editTemp) = editableModel.makeTempItem(_item)
            switch editTemp.editType {
            case .model:
                break
            case .readonly:
                break
            case .inputText:
                break
            case .inputMemo:
                let storyboard = UIStoryboard(name: "Edit", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubInputMemoVC") as? SubInputMemoVC{
                    nvc.initData(self, editableItem: editTemp)
                    //遷移アニメーション関連
                    nvc.modalTransitionStyle = .coverVertical
                    self.present(nvc, animated: true) {}
                }
            case .inputZipcode:
                break
            case .inputTextSecret:
                break
            case .selectDrumYMD:
                break
            case .selectDrumYM:
                break
            case .selectSingle:
                let storyboard = UIStoryboard(name: "EditablePopup", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubSelectSingleVC") as? SubSelectSingleVC{
                    nvc.initData(self, editableItem: editTemp, selectingCodes: editTemp.curVal)
                    //遷移アニメーション関連
                    nvc.modalTransitionStyle = .coverVertical//.crossDissolve
                    self.present(nvc, animated: true) {}
                }
            case .selectMulti:
                let storyboard = UIStoryboard(name: "EditablePopup", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubSelectMultiVC") as? SubSelectMultiVC{
                    nvc.initData(self, editableItem: editTemp, selectingCodes: editTemp.curVal)
                    //遷移アニメーション関連
                    nvc.modalTransitionStyle = .coverVertical//.crossDissolve
                    self.present(nvc, animated: true) {}
                }
            case .selectSpecial: fallthrough
            case .selectSpecialYear:
                let storyboard = UIStoryboard(name: "EditablePopup", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubSelectSpecialVC") as? SubSelectSpecialVC{
                    nvc.initData(self, editableItem: editTemp, selectingCodes: editTemp.curVal)
                    //遷移アニメーション関連
                    nvc.modalTransitionStyle = .coverVertical//.crossDissolve
                    self.present(nvc, animated: true) {}
                }
            }
        default:
            break
        }
        //================================================
        switch item.type {
        case .notifyEntry1C12, .notifyEntry2C12, .passwordC12: //それぞれで実施するので遷移はなし
            return

        case .lastJobExperimentH3, .jobExperimentsH3, .businessTypesH3, .lastJobExperimentA11, .jobExperimentsA14:
            let storyboard = UIStoryboard(name: "EditablePopup", bundle: nil)
            if let _item = item.childItems.first {
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SubSelectSpecialVC") as? SubSelectSpecialVC{
                    nvc.initData(self, editableItem: _item, selectingCodes: _item.curVal)
                    //遷移アニメーション関連
                    nvc.modalTransitionStyle = .coverVertical//.crossDissolve
                    self.present(nvc, animated: true) {}
                }
            }
            //直接、特殊選択画面へ遷移させる
            return

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
