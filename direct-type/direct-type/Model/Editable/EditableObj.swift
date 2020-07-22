//
//  EditableObj.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/03/11.
//  Copyright © 2020 ms-mb014. All rights reserved.
//

import Foundation

typealias EditableItemCurVal = String
typealias EditableItemKey = String //EditItemProtocol.itemKey
typealias ValidationErrMsg = String

class EditItemTool {
    static let SplitMultiCodeSeparator: String.Element = "_"
    static let SplitTypeYearSeparator: String.Element = ":"
    static let JoinMultiCodeSeparator: String = "_"
    static let JoinTypeYearSeparator: String = ":"

    class func convType(type: [Code]) -> String {
        return type.joined(separator: JoinMultiCodeSeparator)
    }
    class func convTypeAndYear(types: [Code], years: [Code]) -> String {
        let min: Int = (types.count < years.count) ? types.count : years.count
        var arrResult: [String] = []
        for (n, type) in types.enumerated() {
            if n < min {
                let year: Code = years[n]
                //片方が不正データなら登録しない
                if !type.isEmpty && !year.isEmpty {
                    arrResult.append([type, year].joined(separator: JoinTypeYearSeparator))
                }
            }
        }
        return arrResult.joined(separator: JoinMultiCodeSeparator)
    }
    class func convTypeAndYear(codes: String) -> ([Code], [Code]) {
        var arrType: [Code] = []
        var arrYear: [Code] = []
        for job in codes.split(separator: SplitMultiCodeSeparator) {
            let buf = String(job).split(separator: SplitTypeYearSeparator)
            guard buf.count == 2 else { continue }
            let tmp0 = String(buf[0])
            let tmp1 = String(buf[1])
            arrType.append(tmp0)
            arrYear.append(tmp1)
        }
        return (arrType, arrYear)
    }
    class func dispTypeAndYear(codes: String, _ tsvMaain: SelectItemsManager.TsvMaster = .jobType, _ tsvSub: SelectItemsManager.TsvMaster = .jobExperimentYear ) -> [String] {
        var disp: [String] = []
        if Constants.DbgDispStatus { disp.append("[\(codes)]") }
        for code in codes.split(separator: "_") {
            let buf = String(code).split(separator: SplitTypeYearSeparator)
            guard buf.count == 2 else { continue }
            let tmp0 = String(buf[0])
            let tmp1 = String(buf[1])
            let buf0: String = SelectItemsManager.getCodeDispSyou(tsvMaain, code: tmp0)?.disp ?? ""
            let buf1: String = SelectItemsManager.getCodeDisp(tsvSub, code: tmp1)?.disp ?? ""
            let grp0: String = SelectItemsManager.getDispDai(tsvMaain, code: tmp0)
            let bufExperiment: String = "\(grp0)/\(buf0)：\(buf1)"
            disp.append(bufExperiment)
        }
        return disp
    }
}

protocol EditItemProtocol {
    var itemKey: String { get }
    var dispName: String { get }
    var placeholder: String { get }
    var tsvMaster: SelectItemsManager.TsvMaster { get }
    var valid: ValidInfo { get }
    var dispUnit: String { get }
}

enum EditType {
    case model              //応募フォームでのモデルひとかたまり
    case readonly           //String
    case inputText          //String(TextField)
    case inputMemo          //String(TextView)
    case inputZipcode       //String - String
    case inputTextSecret    //String
    case selectDrumYMD      //一覧からの選択（Drumで表示）
    case selectDrumYM         //一覧からの選択（Drumで表示）
    case selectSingle       //一覧からの選択（単体選択）
    case selectMulti        //一覧からの選択（複数選択）
    case selectSpecial      //一覧からの選択（大分類→小分類）
    case selectSpecialYear  //一覧からの選択（大分類→小分類→年数）
//    case selectSpecialHide  //一覧からの選択（大分類→小分類→年数）での年数を非表示にするため
}
protocol EditableObj: Codable {
    //JSON変換して保存など
    var jsonObj: [String: Codable] { get }
    var jsonStr: String { get }
    static func fromJsonStr(_ jsonStr: String) -> Self
}
extension EditableObj {
    var jsonStr: String {
        do {
            let model = jsonObj
            let jsonData = try JSONSerialization.data(withJSONObject: model, options: [.prettyPrinted])
            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
            return jsonStr
        } catch let error {
            print(error)
            return ""
        }
    }
    static func fromJsonStr(_ jsonStr: String) -> Self {
        let jsonData = jsonStr.data(using: .utf8)
        let obj = try! JSONDecoder().decode(Self.self, from: jsonData!)
        return obj
    }
}

//=== 選択項目で、内部用Codeとユーザ表示用Dispを扱えるようにするもの（内部用CodeはAPI指定に使うものと同一だと管理が楽）
typealias Code = String
class CodeDisp: Codable {
    var code: Code
    var disp: String
    
    var debugDisp: String {
        return "[\(code)]: [\(disp)]"
    }
    init(_ code: Code = "", _ disp: String) {
        self.code = code
        self.disp = disp
    }
}
//ハッシュ(Set)対応させておく
extension CodeDisp: Hashable {
    public func hash(into hasher: inout Hasher) {
        code.hash(into: &hasher)
        disp.hash(into: &hasher)
    }
    static func == (lhs: CodeDisp, rhs: CodeDisp) -> Bool {
        return lhs.code == rhs.code && lhs.disp == rhs.disp
    }
}

//=== 「大分類」「小分類」なものに対応できるように拡張
//選択項目の管理
class GrpCodeDisp: Codable {
    var grp: String
    var codeDisp: CodeDisp
    
    var debugDisp: String {
        return "<\(grp)> [\(codeDisp.code)]: [\(codeDisp.disp)]"
    }
    init(_ grp: String = "", _ code: Code = "", _ disp: String) {
        self.grp = grp
        self.codeDisp = CodeDisp(code, disp)
    }
}

//======
class SortCodeDisp: Codable {
    var sortNum: Int
    var code: Code
    var disp: String
    
    var debugDisp: String {
        return "[\(sortNum)]\t [\(code)]: [\(disp)]"
    }
    init(_ sortNum: String, _ code: Code = "", _ disp: String) {
        self.sortNum = Int(sortNum) ?? 0
        self.code = code
        self.disp = disp
    }
}
//ハッシュ(Set)対応させておく
extension SortCodeDisp: Hashable {
    public func hash(into hasher: inout Hasher) {
        sortNum.hash(into: &hasher)
        disp.hash(into: &hasher)
        disp.hash(into: &hasher)
    }
    static func == (lhs: SortCodeDisp, rhs: SortCodeDisp) -> Bool {
        return lhs.sortNum == rhs.sortNum && lhs.code == rhs.code && lhs.disp == rhs.disp
    }
}
class SortGrpCodeDisp: Codable {
    var sortNum: Int
    var grp: String
    var codeDisp: CodeDisp
    
    var debugDisp: String {
        return "[\(sortNum)]\t <\(grp)> [\(codeDisp.code)]: [\(codeDisp.disp)]"
    }
    init(_ grp: String = "", _ sortNum: String, _ code: Code = "", _ disp: String) {
        self.grp = grp
        self.sortNum = Int(sortNum) ?? 0
        self.codeDisp = CodeDisp(code, disp)
    }
}

