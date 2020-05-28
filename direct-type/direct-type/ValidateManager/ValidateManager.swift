//
//  ValidateManager.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/05/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

final public class ValidateManager {
    public static let shared = ValidateManager()
    private init() {
    }
}


extension ValidateManager {
    class func subValidate(_ itemGrp: MdlItemH, _ item: EditableItemH) -> [EditableItemKey: [String]] {
        var dic: [EditableItemKey: [String]] = [:]
        print("\t✍️[\(itemGrp.debugDisp)]\t[\(item.debugDisp)]")
        for n in 1...3 {
            dic = addDicArrVal(dic: dic, key: item.editableItemKey, val: "\(n)-0つめ")
            dic = addDicArrVal(dic: dic, key: EditItemMdlProfile.familyName.itemKey, val: "\(n)-1つめ")
            dic = addDicArrVal(dic: dic, key: EditItemMdlProfile.familyNameKana.itemKey, val: "\(n)-2つめ")
            dic = addDicArrVal(dic: dic, key: EditItemMdlProfile.familyNameKana.itemKey, val: "\(n)-3つめ")
            dic = addDicArrVal(dic: dic, key: EditItemMdlProfile.firstNameKana.itemKey, val: "\(n)-4つめ")
        }
        
        print(String(repeating: "=", count: 44))
        for (key, val) in dic {
            print(#line, #function, key, val.count, val.description)

        }
        print(String(repeating: "=", count: 44))

        
        
        return dic
    }
    class func addDicArrVal(dic: [EditableItemKey: [String]], key: EditableItemKey, val: String) -> [EditableItemKey: [String]] {
        var new: [EditableItemKey: [String]] = dic
        if var hoge = dic[key] {
            hoge.append(val)
            new[key] = hoge
        } else {
            new[key] = [val]
        }
        return new
    }
}

extension ValidateManager {
    class func dbgDispCurrentItems(editableModel: EditableModel) {
        return//!!!
        //===変更内容の確認
        print(#line, String(repeating: "=", count: 44))
        for (y, items) in editableModel.arrData.enumerated() {
            for (x, _item) in items.enumerated() {
                let (isChange, editTemp) = editableModel.makeTempItem(_item)
                let item: EditableItemH! = isChange ? editTemp : _item
                if isChange {
                    print("\t(\(y)-\(x)) ✍️ [\(item.debugDisp)]")
                } else {
                    print("\t(\(y)-\(x)) 　 [\(item.debugDisp)]")
                }
            }
        }
        print(#line, String(repeating: "=", count: 44))
    }
}
