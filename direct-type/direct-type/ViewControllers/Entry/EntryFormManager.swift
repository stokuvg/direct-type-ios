//
//  EntryFormManager.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/07/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

class EntryFormManager {
    var dicEntryFormCache: [String: MdlEntry] = [:]  //JobCardCodeごとに入力値を保持させる
    
    public static let shared = EntryFormManager()
    private init() {
    }

    class func cachedEntry(jobCardCode: String) -> MdlEntry {
        if let entry = shared.dicEntryFormCache[jobCardCode] {
            return entry
        } else {
            return MdlEntry()
        }
    }
    class func saveCache(jobCardCode: String, entry: MdlEntry) {
        shared.dicEntryFormCache.removeAll() //複数社の応募情報は管理しなくて良いので、全削除してから登録しておく
        EntryFormManager.shared.dicEntryFormCache[jobCardCode] = entry
    }
    class func convEditTemp2Model(entry: MdlEntry, editTempCD: [EditableItemKey: EditableItemCurVal]) -> MdlEntry {
        let _entry: MdlEntry = entry
        if let tmp = editTempCD[EditItemMdlEntry.exQuestionAnswer1.itemKey] { _entry.exAnswer1 = tmp }
        if let tmp = editTempCD[EditItemMdlEntry.exQuestionAnswer2.itemKey] { _entry.exAnswer2 = tmp }
        if let tmp = editTempCD[EditItemMdlEntry.exQuestionAnswer3.itemKey] { _entry.exAnswer3 = tmp }
        if let tmp = editTempCD[EditItemMdlEntry.ownPR.itemKey] { _entry.ownPR = tmp }
        if let tmp = editTempCD[EditItemMdlEntry.hopeSalary.itemKey] { _entry.hopeSalary = tmp }
        var _hopeArea: [Code] = []
        if let tmp = editTempCD[EditItemMdlEntry.hopeArea.itemKey] {
            for code in tmp.split(separator: EditItemTool.SplitMultiCodeSeparator) {
                _hopeArea.append(String(code))
            }
        }
        _entry.hopeArea = _hopeArea
//        //===独自質問はjobCardDetailに含まれているので、MdlEntryにも持たせておく
//        if let tmp = jobCard?.entryQuestion1 { _entry?.exQuestion1 = tmp }
//        if let tmp = jobCard?.entryQuestion2 { _entry?.exQuestion2 = tmp }
//        if let tmp = jobCard?.entryQuestion3 { _entry?.exQuestion3 = tmp }

        return _entry
    }
    
    
    
    

    
    
}
