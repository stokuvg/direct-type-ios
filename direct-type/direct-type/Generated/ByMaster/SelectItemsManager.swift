//
//  SelectItemsManager.swift
//  testFloat
//
//  Created by ms-mb014 on 2020/03/11.
//  Copyright © 2020 ms-mb014. All rights reserved.
//
//選択肢の一覧を管理するもの
//TODO: 依存関係がある選択項目についても、こちらで管理する


import Foundation

struct SelectItemKey {
    static let MstCompanyKey: String = "MstKey_CompanyGrp" //=== 会社
}
    
//マスタはDbg/Userそれぞれのprefectureではなく、prefectureとしてのマスタ定義で良いはず
//ただし、それぞれの選択された値などは、Dbg/Userそれぞれのprefectureになるべきです
//。。。そのため、Masterに関しては、prefectureのものを返してくれるだけで良いかと。
class SelectItemsManager: NSObject {
    //=== 項目ごとの依存関係を設定する
    private var dicParentKey: [EditableItemKey: EditableItemKey] = [:] //依存関係がある場合、その親のキーを設定しておく
    
    //===マスタをメモリに保持させておく
    var arrMaster: [TsvMaster: [CodeDisp]] = [:] //小分類のみのもの
    var arrMasterDai: [TsvMaster: [CodeDisp]] = [:] //大分類-小分類の場合の大分類側のもの
    var arrMasterSyou: [TsvMaster: [GrpCodeDisp]] = [:] //大分類-小分類の場合の小分類側のもの
    //===選択肢依存関係の特例対応...
    var isCachedCompany: Bool = false
    var selectedCompany: String? = nil
    var selectedDebugDisp: String {
        "[Company: \(SelectItemsManager.shared.selectedCompany ?? "")] "
    }
    
    static var shared: SelectItemsManager = {
        return SelectItemsManager()
    }()
    private override init() {
        super.init()
        self.commonInit()
    }
    func commonInit() {
        initDependency()
        //===
        loadMaster(type: .salary)
        loadMaster(type: .salarySelect)
        loadMaster(type: .entryPlace)
        loadMaster(type: .schoolType)
        loadMaster(type: .place)
        loadMaster(type: .employmentStatus)
        loadMaster(type: .gender)
        loadMaster(type: .changeCount)
        loadMasterGrp(type: .jobType)
        loadMaster(type: .jobExperimentYear)
        loadMasterGrp(type: .businessType)
        loadMaster(type: .skillEnglish)
        loadMaster(type: .qualification)
        loadMaster(type: .employmentType)
        loadMaster(type: .prCode)
        loadMaster(type: .overtime)
        loadMaster(type: .management)
        loadMaster(type: .pcSkillWord)
        loadMaster(type: .pcSkillExcel)
        loadMaster(type: .pcSkillPowerPoint)
    }
    //=== 依存関係の解決
    func initDependency() {
        //依存関係の設定
        dicParentKey.removeAll()
//        dicParentKey[EditItemDbg.occupation.itemKey] = EditItemDbg.jobType.itemKey
    }
    //itemKeyを渡すと、親が存在するかチェックし、ある場合にはそのキーと値を返すもの
    func chkParent(_ itemKey: EditableItemKey, editTempCD: [EditableItemKey: EditableItemCurVal]) -> (EditableItemKey?, EditableItemCurVal) {
        if let depKey = dicParentKey[itemKey] {
            let depCurSel = editTempCD[depKey] ?? "" //これだと編集中の値しかもとまらないので、TODO: item, editTempでtukuridaseru
            return (depKey, depCurSel)
        } else {
            return (nil, "")
        }
    }
    //itemKeyを渡すと、子が存在するかチェックし、ある場合にはそのキーと値を返すもの
    func chkChild(_ itemKey: EditableItemKey, editTempCD: [EditableItemKey: EditableItemCurVal]) -> (EditableItemKey?, EditableItemCurVal) {
        for (key, val) in dicParentKey {
            if val == itemKey {
                let depCurSel = editTempCD[key] ?? "" //これだと編集中の値しかもとまらないので、TODO: item, editTempでtukuridaseru
                return (key, depCurSel)
            }
        }
        return (nil, "")
    }

    //=== キャッシュ保持のクリア
    class func allClear() {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: SelectItemKey.MstCompanyKey)
        self.shared.isCachedCompany = false
    }
}

extension SelectItemsManager {
    //=== JobTypeを選ぶとOccupationが決まるようなもの
    class func SelectItems_JobType() -> [CodeDisp] {
        return SelectItemsManager.getMaster(.jobType).0
    }
    class func SelectItems_Occupation(grpCodeFilter: String?) -> [CodeDisp] {
        let grp: [GrpCodeDisp] = SelectItemsManager.getMaster(.jobType).1
        //指定されたgrpCodeで絞り込んだ[CodeDisp]配列を返したい
        guard let grpCode = grpCodeFilter else {
            return grp.map { (item) -> CodeDisp in
                return item.codeDisp
            }
        }
        let filter = grp.filter { (grpCodeDisp) -> Bool in
            grpCodeDisp.grp == grpCode
        }.map { (item) -> CodeDisp in
            return item.codeDisp
        }
        return filter
    }
    class func SelectItems_Occupation_Grp() -> [GrpCodeDisp] {
        var arr: [GrpCodeDisp] = []
        for grp in 1...2 {
            for num in 1...(grp) {
                let item: GrpCodeDisp = GrpCodeDisp("\(grp)", "\(grp)_\(num)", "職種 \(grp)_\(num)")
                arr.append(item)
            }
        }
        return arr
    }
}


//======================================================
//=== マスタデータ定義 (とりあえずソース埋め込み)
var SelectItems_Prefecture: [CodeDisp] {
    return SelectItemsManager.getMaster(.place)
}
var SelectItems_Gender: [CodeDisp] {
    return SelectItemsManager.getMaster(.gender)
}
//======================================================
extension SelectItemsManager {
    enum TsvMaster {
        case undefine //コードじゃないでの定義なし

        case salary
        case salarySelect //コードではなく選択させるためのテーブル
        case entryPlace
        case schoolType
        case place
        case employmentStatus
        case gender
        case changeCount
        case jobType
        case jobExperimentYear
        case businessType
        case skillEnglish
        case qualification
        case employmentType
        case prCode
        case overtime
        case management
        case pcSkillExcel
        case pcSkillWord
        case pcSkillPowerPoint
        
        var fName: String {
            switch self {
            case .undefine:             return ""
            case .salary:               return "MstK10_salary"
            case .salarySelect:         return "MstSel_salary"
            case .entryPlace:           return "MstK11_entryPlace"
            case .schoolType:           return "MstK13_schoolType"
            case .place:                return "MstK14_place"
            case .employmentStatus:     return "MstK25_employmentStatus"
            case .gender:               return "MstK25_gender"
            case .changeCount:          return "MstK3_changeCount"
            case .jobType:              return "MstK4_jobType"
            case .jobExperimentYear:    return "MstK5_jobExperimentYear"
            case .businessType:         return "MstK6_businessType"
            case .skillEnglish:         return "MstK7_skillEnglish"
            case .qualification:        return "MstK8_qualification"
            case .employmentType:       return "MstK9_employmentType"
            case .prCode:               return "MstL2_prCode"
            case .overtime:             return "MstL3_overtime"
            case .management:           return "MstF16_management"
            case .pcSkillWord:          return "MstF22_pcSkillWord"
            case .pcSkillExcel:         return "MstF22_pcSkillExcel"
            case .pcSkillPowerPoint:    return "MstF22_pcSkillPowerPoint"
            }
        }
    }
    func loadMaster(type: TsvMaster) {
        var arrCodeDisp: [SortCodeDisp] = []
        arrCodeDisp.removeAll()
        if let filepath = Bundle.main.path(forResource: type.fName, ofType: "tsv") {
            do {
                //手抜きなので一括読みだけど、1行づつじゃないとメモリが...
                let contents = try String(contentsOfFile: filepath)
                let lines = contents.components(separatedBy: "\n")
                //読めたので、ばらして保持させる
                for (num, _line) in lines.enumerated() {
                    let line = _line.trimmingCharacters(in: .whitespacesAndNewlines)
                    if num == 0 { continue } //最初の行はヘッダなので追加しない
                    if num == 1 { continue } //2行めもヘッダなので追加しない
                    let hoge = line.components(separatedBy: "\t")
                    if hoge.count >= 2 {
                        let item: SortCodeDisp = SortCodeDisp(hoge[2], hoge[1], hoge[3])
                        arrCodeDisp.append(item)
//                        if num <= 5 { //[Debug]
//                            print(item.debugDisp)
//                        }
                    }
                }
            } catch {
                // contents could not be loaded
            }
            //print("[\(type.fName)] \(arrCodeDisp.count)件のマスタを読み込みました")
            //===[ソート後のものを保持しておく]===___
            arrMaster[type] = []
            for (_, item) in arrCodeDisp.sorted(by: { (mae, ato) -> Bool in
                mae.sortNum < ato.sortNum
            }).enumerated() {
                let item: CodeDisp = CodeDisp(item.code, item.disp)
                arrMaster[type]?.append(item)
            }
            //===[ソート後のものを保持しておく]===^^^
            ////===[Debug: 内容確認]===___
            //if let arr = arrMaster[type] {
            //    for (num, item) in arr.enumerated() {
            //        print("#\(num)...\(item.debugDisp)")
            //    }
            //}
            ////===[Debug: 内容確認]===^^^
        }
    }
    func loadMasterGrp(type: TsvMaster) {
        var arrCodeDispGrp: Set<SortCodeDisp> = Set()
        var arrCodeDisp: [SortGrpCodeDisp] = []
        if let filepath = Bundle.main.path(forResource: type.fName, ofType: "tsv") {
            do {
                //手抜きなので一括読みだけど、1行づつじゃないとメモリが...
                let contents = try String(contentsOfFile: filepath)
                let lines = contents.components(separatedBy: "\n")
                //読めたので、ばらして保持させる
                for (num, line) in lines.enumerated() {
                    if num == 0 { continue } //最初の行はヘッダなので追加しない
                    if num == 1 { continue } //2行めもヘッダなので追加しない
                    let hoge = line.components(separatedBy: "\t")
                    if hoge.count >= 6 {
                        let itemGrpCode: String = hoge[1]
                        let itemGrp: SortCodeDisp = SortCodeDisp(hoge[2], hoge[1], hoge[3])
                        let item: SortGrpCodeDisp = SortGrpCodeDisp(itemGrpCode, hoge[5], hoge[4], hoge[6])
                        arrCodeDispGrp.insert(itemGrp)
                        arrCodeDisp.append(item)
//                        if num <= 5 { //[Debug]
//                            print(itemGrp.debugDisp, item.debugDisp)
//                        }
                    }
                }
            } catch {
                // contents could not be loaded
            }
            //===[ソート後のものを保持しておく]===___
            arrMasterDai[type] = []
            for (_, item) in arrCodeDispGrp.sorted(by: { (mae, ato) -> Bool in
                mae.sortNum < ato.sortNum
            }).enumerated() {
                let item: CodeDisp = CodeDisp(item.code, item.disp)
                arrMasterDai[type]?.append(item)
            }
            arrMasterSyou[type] = []
            for (_, item) in arrCodeDisp.sorted(by: { (mae, ato) -> Bool in
                mae.sortNum < ato.sortNum
            }).enumerated() {
                let item: GrpCodeDisp = GrpCodeDisp(item.grp, item.codeDisp.code, item.codeDisp.disp)
                arrMasterSyou[type]?.append(item)
            }
            //===[ソート後のものを保持しておく]===^^^
            ////===[Debug: 内容確認]===___
            //if let arr = arrMasterDai[type] {
            //    for (num, item) in arr.enumerated() {
            //        print("#\(num)...\(item.debugDisp)")
            //    }
            //}
            //if let arr = arrMasterSyou[type] {
            //    for (num, item) in arr.enumerated() {
            //        print("#\(num)...\(item.debugDisp)")
            //    }
            //}
            ////===[Debug: 内容確認]===^^^
            //print("[\(type.fName)] \(arrCodeDisp.count)件のマスタを読み込みました")
        }
    }
    //======================================================
    //未選択をどうのタイミングでつけるかなど考慮の余地あり
    class func getMaster(_ type: TsvMaster) -> [CodeDisp] {
        return self.shared.arrMaster[type] ?? []
    }
    class func getMaster(_ type: TsvMaster) -> ([CodeDisp], [GrpCodeDisp]) {
        return (self.shared.arrMasterDai[type] ?? [], self.shared.arrMasterSyou[type] ?? [])
    }
    //======================================================
    //種別とコードを渡すと、対応するCodeDispを返却する
    class func getCodeDisp(_ type: TsvMaster, code: Code) -> CodeDisp? {
        let mst: [CodeDisp] = getMaster(type)
        return mst.filter { (cd) -> Bool in
            cd.code == code
        }.first
    }
    class func getCodeDisp(_ type: TsvMaster, code: Int) -> CodeDisp? {
        let mst: [CodeDisp] = getMaster(type)
        return mst.filter { (cd) -> Bool in
            cd.code == String(code)
        }.first
    }
    class func getCodeDispSyou(_ type: TsvMaster, code: Code) -> CodeDisp? {
        let (_, mst) = getMaster(type)
        return mst.filter { (cd) -> Bool in
            cd.codeDisp.code == code
        }.first?.codeDisp
    }

}

//サブ選択の戻り値をCodeDispに展開するもの
//複数の場合は[_]でつなぐ。2段階指定のものはさらに[:]でつなぐ...[1_2_3] or [1:1_2:2_3:3]など
extension SelectItemsManager {
    class func convCodeDisp(_ tsv1: TsvMaster, _ tsv2: TsvMaster, _ codes: String) -> [(CodeDisp, CodeDisp)] {
        return codes.split(separator: EditItemTool.SplitMultiCodeSeparator).map { (obj) -> (CodeDisp, CodeDisp) in
            let cd = String(obj).split(separator: EditItemTool.SplitTypeYearSeparator)
            if cd.count == 2 {
                let cd1: CodeDisp = SelectItemsManager.getCodeDispSyou(tsv1, code: String(cd[0])) ?? Constants.SelectItemsUndefine
                let cd2: CodeDisp = SelectItemsManager.getCodeDisp(tsv2, code: String(cd[1])) ?? Constants.SelectItemsUndefine
                return (cd1, cd2)
            } else {
                return (Constants.SelectItemsUndefine, Constants.SelectItemsUndefine)
            }
        }
    }
    class func convCodeDisp(_ tsv1: TsvMaster, _ codes: String) -> [CodeDisp] {
        return codes.split(separator: EditItemTool.SplitMultiCodeSeparator).map { (obj) -> (CodeDisp) in
            switch tsv1 {
            case .jobType, .businessType:
                return SelectItemsManager.getCodeDispSyou(tsv1, code: String(obj)) ?? Constants.SelectItemsUndefine
            default:
                return SelectItemsManager.getCodeDisp(tsv1, code: String(obj)) ?? Constants.SelectItemsUndefine
            }
        }
    }
}

