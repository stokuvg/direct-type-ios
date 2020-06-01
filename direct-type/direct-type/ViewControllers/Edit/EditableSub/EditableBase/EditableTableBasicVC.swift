//
//  EditableTableBasicVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/14.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import SwaggerClient

protocol nameEditableTableBasicDelegate {
    func changedSelect(editItem: MdlItemH, editTempCD: [EditableItemKey: EditableItemCurVal])
}

class EditableTableBasicVC: EditableBasicVC {
    var delegate: nameEditableTableBasicDelegate? = nil
    var vwKbTapArea: UIView = UIView(frame: CGRect.zero)
    var itemGrp: MdlItemH!
    
    @IBOutlet weak var vwHead: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func actBack(_ sender: UIButton) {
        self.dismiss(animated: true) {}
    }
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var tableVW: UITableView!
    @IBOutlet weak var vwFoot: UIView!
    @IBOutlet weak var btnCommit: UIButton!
    @IBAction func actCommit(_ sender: UIButton) {
        ValidateManager.dbgDispCurrentItems(editableModel: editableModel) //[Dbg: 状態確認]
        if chkValidateError() {
            tableVW.reloadData()
            return
        }
        //編集画面でのeditTempCDを、そのまま前の画面に渡しても良い気がする
        self.delegate?.changedSelect(editItem: itemGrp, editTempCD: editableModel.editTempCD) //フィードバックしておく
        self.dismiss(animated: true) {}
    }
    
    func chkValidateError() -> Bool {
        if Constants.DbgSkipLocalValidate { return false }//[Dbg: ローカルValidationスキップ]
        ValidateManager.dbgDispCurrentItems(editableModel: editableModel) //[Dbg: 状態確認]
        dicValidErrMsg.removeAll()//チェック前に、既存のエラーを全削除しておく
        let chkErr = ValidateManager.chkValidationErr(editableModel)
        if chkErr.count > 0 {
            var msg: String = ""
            for (key, errs) in chkErr {
                //dicValidErrMsg[key] = err.joined(separator: "\n")
                for err in errs {
                    dicValidErrMsg.addDicArrVal(key: key, val: err)
                }
                let name = editableModel.getItemByKey(key)?.dispName ?? ""
//                msg = "\(msg)\(name): \(errs.joined(separator: "\n"))\n"
                msg = "\(msg)\(errs.joined(separator: "\n"))\n"
            }
            self.showValidationError(title: "Validationエラー (\(chkErr.count)件)", message: msg)
//            /* Warning回避 */ .done { _ in } .catch { (error) in } .finally { } //Warning回避
            return true
        } else {
            return false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //====デザイン適用
        vwHead.backgroundColor = UIColor.init(colorType: .color_main)!
        vwMain.backgroundColor = UIColor.init(colorType: .color_white)!
        vwFoot.backgroundColor = UIColor.init(colorType: .color_main)!
        btnCommit.setTitle(text: "この内容で保存", fontType: .font_M, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
        btnCommit.backgroundColor = UIColor.init(colorType: .color_button)
        //=== テーブル初期化
        self.tableVW.estimatedRowHeight = 100
        self.tableVW.rowHeight = UITableView.automaticDimension
        self.tableVW.register(UINib(nibName: "HEditTextTBCell", bundle: nil), forCellReuseIdentifier: "Cell_HEditTextTBCell")
        self.tableVW.register(UINib(nibName: "HEditDrumTBCell", bundle: nil), forCellReuseIdentifier: "Cell_HEditDrumTBCell")
        self.tableVW.register(UINib(nibName: "HEditZipcodeTBCell", bundle: nil), forCellReuseIdentifier: "Cell_HEditZipcodeTBCell")
        //=== Keyboard制御
        vwKbTapArea.backgroundColor = .black
        vwKbTapArea.alpha = 0.0
        vwKbTapArea.isUserInteractionEnabled = false //Keyboardエリア以外のTapで消すならtrueにする
        self.view.addSubview(vwKbTapArea)
        //ジェスチャーつけとく
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(kbAreaTap(_:)))
        vwKbTapArea.addGestureRecognizer(tapGesture)
    }
    @objc func kbAreaTap(_ sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    override func actTargetInputTextBegin(_ tf: IKTextField, _ item: EditableItemH) {
        showTargetTF(tableVW, tf)//一緒にスクロールするように親を変えるためoverride
    }

    func initData(_ delegate: nameEditableTableBasicDelegate, _ itemGrp: MdlItemH, _ arrErrMsg: [EditableItemKey: [ValidationErrMsg]]) {
        self.delegate = delegate
        self.itemGrp = itemGrp
        self.dicValidErrMsg = arrErrMsg
        //=== IndexPathなどを設定するため
        editableModel.initItemEditable(itemGrp.childItems)
    }
    func dispData() {
        guard let _item = itemGrp else { return }
        lblTitle.text(text: _item.type.dispTitle, fontType: .font_L, textColor: UIColor.init(colorType: .color_white)!, alignment: .center)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        //let szDevice = UIScreen.main.bounds.size
        if let rect = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            let safeAreaT = self.view.safeAreaInsets.top
            let safeAreaB = self.view.safeAreaInsets.bottom
            let szKeyBoard = rect.size
            let szGamen = self.view.frame.size
            let size = CGSize(width: szGamen.width - 4,
                              height: szGamen.height - szKeyBoard.height - 4 - safeAreaT)
            let frame = CGRect(origin: CGPoint(x: 2, y: 2 + safeAreaT), size: size)
            self.vwKbTapArea.frame = frame
            //!!!print(szDevice, szGamen, szKeyBoard, tableVW.contentInset.top, tableVW.contentInset.bottom, safeAreaT, safeAreaB)
            tableVW.contentInset.bottom =  szKeyBoard.height - safeAreaB
        }
    }
    @objc func keyboardDidHide(notification: NSNotification) {
        self.vwKbTapArea.frame = CGRect.zero
        tableVW.contentInset.bottom = 0
    }

    //=======================================================================================================
    //EditableBaseを元に、汎用テーブルIFを利用する場合のBaseクラス
    //=== OVerrideして使う
    //func moveNextCell(_ editableItemKey: String) -> Bool { return true } //次の項目へ移動
    //func dispEditableItemAll() {} //すべての項目を表示する
    //func dispEditableItemByKey(_ itemKey: EditableItemKey) {} //指定した項目を表示する （TODO：複数キーの一括指定に拡張予定）
    override func moveNextCell(_ editableItemKey: String) -> Bool {  //次のセルへ遷移
        for (cnt, item) in editableModel.arrTextFieldNextDoneKey.enumerated() {
            print("\t\(cnt) \(item == editableItemKey ? "💥" : "")\t\(editableItemKey) \(item)")
        }
        let idx = editableModel.arrTextFieldNextDoneKey.firstIndex(where: { (item) -> Bool in
            item == editableItemKey
        }) ?? 0
        let nextIdx = idx + 1
        if editableModel.arrTextFieldNextDoneKey.count > nextIdx {
            let nextKey = editableModel.arrTextFieldNextDoneKey[nextIdx]
            guard let curIdxPath = editableModel.dicTextFieldIndexPath[editableItemKey] else { return true }
            guard let nextIdxPath = editableModel.dicTextFieldIndexPath[nextKey] else { return true }
            print("[\(editableItemKey)]\(curIdxPath.description)セルから、 [\(nextKey)]\(nextIdxPath.description)セルへ移動したい")
            tableVW.scrollToRow(at: nextIdxPath, at: .middle, animated: false)//trueにすると後続処理でcell見つからない可能性あり＊その場合はAnimation完了後に実施すべき
            if let cell = tableVW.cellForRow(at: nextIdxPath) as? HEditTextTBCell {
                if let next = cell.tfValue {
                    next.becomeFirstResponder()
                    return false
                }
            }
        }
        return true //制御できなかったので、とりあえずデフォルト処理を実施
    }
    //func dispEditableItemAll() {} //すべての項目を表示する
    //func dispEditableItemByKey(_ itemKey: EditableItemKey) {} //指定した項目を表示する （TODO：複数キーの一括指定に拡張予定）
    //=== 表示更新
    @objc override func dispEditableItemAll() {
        self.tableVW.reloadData()//項目の再描画
    }
    override func dispEditableItemByKey(_ itemKey: EditableItemKey) {
        guard let curIdxPath = editableModel.dicTextFieldIndexPath[itemKey] else { return }
        tableVW.reloadRows(at: [curIdxPath], with: UITableView.RowAnimation.automatic)
    }
    //=======================================================================================================
}


extension EditableTableBasicVC: UITableViewDataSource, UITableViewDelegate {
    //=== 通常テーブル
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemGrp.childItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _item = itemGrp.childItems[indexPath.row]
        let (isChange, editTemp) = editableModel.makeTempItem(_item)
        let item: EditableItemH! = isChange ? editTemp : _item
        switch item.editType {
        case .inputText:
            let returnKeyType: UIReturnKeyType = (item.editableItemKey == editableModel.lastEditableItemKey) ? .done : .next
            let cell: HEditTextTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditTextTBCell", for: indexPath) as! HEditTextTBCell
            let errMsg = dicValidErrMsg[item.editableItemKey]?.joined(separator: "\n" ) ?? ""
            cell.initCell(self, item, errMsg: errMsg, returnKeyType)
            cell.dispCell()
            return cell
            
        case .inputZipcode:
            let cell: HEditZipcodeTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditZipcodeTBCell", for: indexPath) as! HEditZipcodeTBCell
            cell.initCell(item)
            cell.dispCell()
            return cell

        case .selectDrumYMD:
            let cell: HEditDrumTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditDrumTBCell", for: indexPath) as! HEditDrumTBCell
            cell.initCell(self, item)
            cell.dispCell()
            return cell

        default:
            print("🌸[\(#function)]🌸[\(#line)]🌸🌸")
            let returnKeyType: UIReturnKeyType = (item.editableItemKey == editableModel.lastEditableItemKey) ? .done : .next
            print("[returnKeyType: \(returnKeyType.rawValue)]")
            let cell: HEditTextTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditTextTBCell", for: indexPath) as! HEditTextTBCell
            let errMsg = dicValidErrMsg[item.editableItemKey]?.joined(separator: "\n") ?? ""
            cell.initCell(self, item, errMsg: errMsg, returnKeyType)
            cell.dispCell()
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        if let cell = tableView.cellForRow(at: indexPath) as? HEditTextTBCell {
            cell.tfValue.becomeFirstResponder()
        }
    }
}
