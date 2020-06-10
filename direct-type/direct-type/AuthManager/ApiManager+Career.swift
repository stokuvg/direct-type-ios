//
//  ApiManager+Career.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/05.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import PromiseKit
import TudApi

//================================================================
//=== Api12_職務経歴書の取得 ===
extension ApiManager {
    class func getCareer(_ param: Void, isRetry: Bool = true) -> Promise<MdlCareer> {
        if isRetry {
            return firstly { () -> Promise<MdlCareer> in
                retry(args: param, task: getCareerFetch) { (error) -> Bool in return true }
            }
        } else {
            return getCareerFetch(param: param)
        }
    }
    private class func getCareerFetch(param: Void) -> Promise<MdlCareer> {
        let (promise, resolver) = Promise<MdlCareer>.pending()
        AuthManager.needAuth(true)
        CareerAPI.careerControllerGet()
        .done { result in
            print(#line, #function, result)
            resolver.fulfill(MdlCareer(dto: result)) //変換しておく
        }
        .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
            resolver.reject(error)
        }
        .finally {
        }
        return promise
    }
}
//================================================================
//=== Api16_職務経歴書の作成・更新 ===
extension CreateCareerRequestDTO {
    init() {
        self.init(careerHistory: [])
    }
}
extension CareerHistoryDTO {
    init() {
        self.init(startWorkPeriod: "", endWorkPeriod: "", companyName: "", employmentId: "", employees: 0, salary: 0, workNote: "")
    }
    init(_ career: MdlCareerCard) {
        self.init()
        self.startWorkPeriod = career.workPeriod.startDate.dispYm()//勤務開始年月（ISO8601[YYYY-MM]）
        self.endWorkPeriod = career.workPeriod.endDate.dispYm()//勤務終了年月（ISO8601[YYYY-MM]）※就業中の場合は9999-12とする
        self.companyName = career.companyName//企業名
        self.employmentId = career.employmentType//雇用形態マスタの値
        self.employees = Int(career.employeesCount) ?? 0 //従業員数 //!!!型が違うのでとりあえず
        self.salary = Int(career.salary) ?? 0 //年収 //!!!型が違うのでとりあえず
        self.workNote = career.contents//職務内容本文
    }
    init(_ career: MdlCareerCard, _ editTempCD: [EditableItemKey: EditableItemCurVal]) {
        self.init(career)
        for (key, val) in editTempCD {
            switch key {
            case EditItemMdlCareerCardWorkPeriod.startDate.itemKey: self.startWorkPeriod = val
            case EditItemMdlCareerCardWorkPeriod.endDate.itemKey: self.endWorkPeriod = val
            case EditItemMdlCareerCard.companyName.itemKey: self.companyName = val
            case EditItemMdlCareerCard.employmentType.itemKey: self.employmentId = val
            case EditItemMdlCareerCard.employeesCount.itemKey: self.employees = Int(val) ?? 0
            case EditItemMdlCareerCard.salary.itemKey: self.salary = Int(val) ?? 0
            case EditItemMdlCareerCard.contents.itemKey: self.workNote = val
            default: break
            }
        }
    }
}
extension ApiManager {
    class func createCareer(_ param: CreateCareerRequestDTO, isRetry: Bool = true) -> Promise<Void> {
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: param, task: createCareerFetch) { (error) -> Bool in return true }
            }
        } else {
            return createCareerFetch(param: param)
        }
    }
    private class func createCareerFetch(param: CreateCareerRequestDTO) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        CareerAPI.careerControllerCreate(body: param)
        .done { result in
            resolver.fulfill(Void())
        }
        .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
            resolver.reject(error)
        }
        .finally {
        }
        return promise
    }
}
//================================================================
//=== Api16_職務経歴書の作成・更新 ===
extension UpdateCareerRequestDTO {
    init() {
        self.init(careerHistory: nil)
    }
}
//extension CareerHistoryDTO これはCreate/Updateで同じ定義だ。。。CareerHistoryDTO単独の更新とかは非対応になってる
extension ApiManager {
    class func updateCareer(_ param: UpdateCareerRequestDTO, isRetry: Bool = true) -> Promise<Void> {
        if isRetry {
            return firstly { () -> Promise<Void> in
                retry(args: param, task: updateCareerFetch) { (error) -> Bool in return true }
            }
        } else {
            return updateCareerFetch(param: param)
        }
    }
    private class func updateCareerFetch(param: UpdateCareerRequestDTO) -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        AuthManager.needAuth(true)
        CareerAPI.careerControllerUpdate(body: param)
        .done { result in
            resolver.fulfill(Void())
        }
        .catch { (error) in  //なんか処理するなら分ける。とりあえず、そのまま横流し
            resolver.reject(error)
        }
        .finally {
        }
        return promise
    }
}
//================================================================
//================================================================
//================================================================
