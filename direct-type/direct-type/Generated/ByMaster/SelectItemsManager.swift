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
        return
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
        loadMaster(type: .entryPlace)
        loadMaster(type: .schoolType)
        loadMaster(type: .place)
        loadMaster(type: .employment)
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
//        loadMaster(type: .skill)//これあとで
        loadMaster(type: .skillYear)
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
    //===EditableItemKeyから直接TsvMasterに繋げて良い気がする...
    class func getSelectItemsByKey(_ itemKey: EditableItemKey, grpCodeFilter: String?) -> [CodeDisp] {
        switch itemKey {
        case EditItemMdlProfile.gender.itemKey:
            return getSelectItems(type: .gender, nil)
        case EditItemMdlProfile.prefecture.itemKey:
            return getSelectItems(type: .prefecture, nil)

        case EditItemMdlResume.employment.itemKey:
            return getSelectItems(type: .employment, nil)
        case EditItemMdlResume.changeCount.itemKey:
            return getSelectItems(type: .changeCount, nil)
            
        case EditItemMdlResumeLastJobExperiment.jobType.itemKey:

            let buf0 =  SelectItemsManager.getMaster(.jobType).0
            let buf1 =  SelectItemsManager.getMaster(.jobType).1
            print(buf0.count, buf1.count)

            let (g, i) =  SelectItemsManager.getMaster(.jobType)
            print(g.count, i.count)

            return SelectItems_Occupation(grpCodeFilter: nil)

        case EditItemMdlResumeLastJobExperiment.jobExperimentYear.itemKey:
            return SelectItemsManager.getMaster(.jobExperimentYear)
            
        case EditItemMdlResumeJobExperiments.jobType.itemKey:

            let buf0 =  SelectItemsManager.getMaster(.jobType).0
            let buf1 =  SelectItemsManager.getMaster(.jobType).1
            print(buf0.count, buf1.count)

            let (g, i) =  SelectItemsManager.getMaster(.jobType)
            print(g.count, i.count)

            return SelectItems_Occupation(grpCodeFilter: nil)

        case EditItemMdlResumeJobExperiments.jobExperimentYear.itemKey:
            return SelectItemsManager.getMaster(.jobExperimentYear)
            

        default:
            break
        }
        return []
    }
    class func getSelectItems(type: Any, grpCodeFilter: String?) -> [CodeDisp] {
        if let _type = type as? EditItemMdlProfile {
            return getSelectItems(type: _type, grpCodeFilter)
        }
        if let _type = type as? EditItemMdlResume {
            return getSelectItems(type: _type, grpCodeFilter)
        }
        return []
    }
    private class func getSelectItems(type: EditItemMdlProfile, _ grpCodeFilter: String?) -> [CodeDisp] {
        switch type {
        case .familyName:       return []
        case .firstName:        return []
        case .familyNameKana:   return []
        case .firstNameKana:    return []
        case .birthday:         return []
        case .gender:           return SelectItems_Gender
        case .zipCode:          return []
        case .prefecture:       return SelectItems_Prefecture
        case .address1:         return []
        case .address2:         return []
        case .mailAddress:      return []
        case .mobilePhoneNo:    return []
        }
    }
    private class func getSelectItems(type: EditItemMdlResume, _ grpCodeFilter: String?) -> [CodeDisp] {
        switch type {
        case .employment:           return SelectItemsManager.getMaster(.jobType)
        case .changeCount:          return SelectItemsManager.getMaster(.changeCount)
        case .lastJobExperiment:    return []
        case .jobExperiments:       return []
        case .businessTypes:        return []
        case .school:               return []
        case .skillLanguage:        return []
        case .qualifications:       return []
        case .ownPr:                return []
        }
    }
    class func getTsvMasterByKey(_ itemKey: EditableItemKey) -> TsvMaster? {
        switch itemKey {
        case EditItemMdlProfile.gender.itemKey:        return .gender
        case EditItemMdlProfile.prefecture.itemKey:    return .place
        default: return nil
        }
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
        case salary
        case entryPlace
        case schoolType
        case place
        case employment
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
        case skill
        case skillYear
        
        var fName: String {
            switch self {
            case .salary:               return "MstK10_salary"
            case .entryPlace:           return "MstK11_entryPlace"
            case .schoolType:           return "MstK13_schoolType"
            case .place:                return "MstK14_place"
            case .employment:           return "MstK25_employment"
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
            case .skill:                return "MstL_skill"
            case .skillYear:            return "MstL_skillYear"
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
                for (num, line) in lines.enumerated() {
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
//            ////MyLog.Log(.master, title: "[\(type.fName)] \(arrCodeDisp.count)件のマスタを読み込みました")
            //===[ソート後のものを保持しておく]===___
            arrMaster[type] = []
            for (num, item) in arrCodeDisp.sorted(by: { (mae, ato) -> Bool in
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
            for (num, item) in arrCodeDispGrp.sorted(by: { (mae, ato) -> Bool in
                mae.sortNum < ato.sortNum
            }).enumerated() {
                let item: CodeDisp = CodeDisp(item.code, item.disp)
                arrMasterDai[type]?.append(item)
            }
            arrMasterSyou[type] = []
            for (num, item) in arrCodeDisp.sorted(by: { (mae, ato) -> Bool in
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
//            ////MyLog.Log(.master, title: "[\(type.fName)] \(arrCodeDisp.count)件のマスタを読み込みました")
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
