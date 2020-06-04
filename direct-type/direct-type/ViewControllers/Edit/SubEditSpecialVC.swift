//
//  SubEditSpecialVC.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/03.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class SubEditSpecialVC: EditableTableBasicVC {

}

extension SubEditSpecialVC {
    //=== 通常テーブル
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let items = self.itemGrp?.childItems, items.count > 0 else { return UITableViewCell() }
        print(#line, #function, itemGrp.debugDisp)
        print(#line, #function, itemGrp.childItems.count)
        print(#line, #function, itemGrp.childItems.description)
        let _item = items[indexPath.row]
        
        let (isChange, editTemp) = editableModel.makeTempItem(_item)
        let item: EditableItemH! = isChange ? editTemp : _item
        switch item.editType {
        case .selectSpecial, .selectSpecialYear:
            print("🌷[\(#function)]🌷[\(#line)]🌷sp🌷")
            let returnKeyType: UIReturnKeyType = (item.editableItemKey == editableModel.lastEditableItemKey) ? .done : .next
            let cell: HEditSpecialTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditSpecialTBCell", for: indexPath) as! HEditSpecialTBCell
            let errMsg = dicValidErrMsg[item.editableItemKey]?.joined(separator: "\n") ?? ""
            let num = indexPath.row + 1
            if itemGrp.childItems.count > num {
                let _item2 = itemGrp.childItems[num]
                let (isChange2, editTemp2) = editableModel.makeTempItem(_item2)
                let item2: EditableItemH! = isChange2 ? editTemp2 : _item2
                cell.initCell(self, item, item2, errMsg: errMsg, returnKeyType)
            } else {
                cell.initCell(self, item, nil, errMsg: errMsg, returnKeyType)
            }
            cell.dispCell()
            return cell

        default:
            print("🌷[\(#function)]🌷[\(#line)]🌷")
            let returnKeyType: UIReturnKeyType = (item.editableItemKey == editableModel.lastEditableItemKey) ? .done : .next
            print("[returnKeyType: \(returnKeyType.rawValue)]")
            let cell: HEditTextTBCell = tableView.dequeueReusableCell(withIdentifier: "Cell_HEditTextTBCell", for: indexPath) as! HEditTextTBCell
            let errMsg = dicValidErrMsg[item.editableItemKey]?.joined(separator: "\n") ?? ""
            cell.initCell(self, item, errMsg: errMsg, returnKeyType)
            cell.dispCell()
            return cell
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //ハイライトの解除
        if let cell = tableView.cellForRow(at: indexPath) as? HEditTextTBCell {
            cell.tfValue.becomeFirstResponder()
        }
    }
}
