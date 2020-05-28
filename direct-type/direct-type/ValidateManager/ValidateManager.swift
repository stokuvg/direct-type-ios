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
    class func subValidate(_ itemGrp: MdlItemH, _ item: EditableItemH) -> [EditableItemKey: String] {
        var dic: [EditableItemKey: String] = [:]
        print("\t✍️[\(itemGrp.debugDisp)]\t[\(item.debugDisp)]")
        dic[item.editableItemKey] = "からはだめよ"
        dic[item.editableItemKey] = "8文字以上ほしいな"
        
        return dic
    }


}
