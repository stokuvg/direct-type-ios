
//
//  MdlDummy.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/07/06.
//  Copyright © 2020 ms-mb015. All rights reserved.
//
import SwaggerClient

extension MdlProfile {
    class func dummyData() -> MdlProfile {
        return MdlProfile(
            nickname: "ニックネーム",
            hopeJobPlaceIds: ["13", "22"],
            familyName: "田中山",
            firstName: "一郎",
            familyNameKana: "タナカヤマ",
            firstNameKana: "イチロウ",
            birthday: DateHelper.convStrYMD2Date("2018-03-07"),
            gender: "1",
            zipCode: "1234567",
            prefecture: "33",
            address1: "保土ヶ谷市",
            address2: "田園はいつ202",
            mailAddress: "hoge@example.co.jp",
            mobilePhoneNo: "09011222233" )
    }
}
extension MdlResume {
    class func dummyData() -> MdlResume {
        return MdlResume(
            employmentStatus: "1",
            changeCount: "3",
            lastJobExperiment: MdlJobExperiment(jobType: "11", jobExperimentYear: "5"),
            jobExperiments: [],
            businessTypes: ["11", "22", "33"],
            educationId: "1",
            school: MdlResumeSchool(schoolName: "本人爺羅大爆", faculty: "経済学部", department: "情報マーケティング科", graduationYear: "2017-03"),
            skillLanguage: MdlResumeSkillLanguage(languageToeicScore: "", languageToeflScore: "456", languageEnglish: "2", languageStudySkill: "フランス語、ドイツ語、エスペラント語"),
            qualifications: ["11", "13", "15"],
            ownPr: "自己PR",
            currentSalary: "1450" )
    }
}
extension MdlCareer {
    class func dummyData() -> MdlCareer {
        return MdlCareer(businessTypes: [])
    }
}
extension MdlCareerCard {
    class func dummyData() -> MdlCareerCard {
        return MdlCareerCard(workPeriod: MdlCareerCardWorkPeriod(startDate: DateHelper.convStrYM2Date("2017-04"), endDate: Constants.DefaultSelectWorkPeriodEndDate),
                             companyName: "ダミーカンパニー",
                             employmentType: "1",
                             employeesCount: "2",
                             salary: "3",
                             contents: "経歴のもろもろ記載しています" )
    }
}
extension MdlEntry {
    class func dummyData() -> MdlEntry {
        return MdlEntry(ownPR: "", hopeArea: [], hopeSalary: "8", exQuestion1: "追加質問の1つめです。これはダミーで尋ねている設問になります", exQuestion2: nil, exQuestion3: nil, exAnswer1: "", exAnswer2: "", exAnswer3: "")
    }
}
extension MdlJobCardDetail {
    class func dummyData() -> MdlJobCardDetail {
        return MdlJobCardDetail(
            jobCardCode: "12345678",
            jobName: "【PL候補・SE】案件数に絶対的な自信あり！◆月給40万円〜■残業平均月12h",
            salaryMinId: 3,
            salaryMaxId: 8,
            isSalaryDisplay: true,
            salaryOffer: "",
            workPlaceCodes: [11, 22, 33],
            companyName: "株式会社プレーンナレッジシステムズ（ヒューマンクリエイショングループ）",
            start_date: "",
            end_date: "",
            mainPicture: "",
            subPictures: [],
            mainTitle: "",
            mainContents: "",
            prCodes: [1,3,5],
            salarySample: "",
            recruitmentReason: "",
            jobDescription: "",
            jobExample: "", product: "", scope: "",
            spotTitle1: "", spotDetail1: "", spotTitle2: "", spotDetail2: "",
            qualification: "", betterSkill: "", applicationExample: "",
            suitableUnsuitable: "", notSuitableUnsuitable: "",
            employmentType: 2, salary: "", bonusAbout: "", jobtime: "",
            overtimeCode: 1, overtimeAbout: "", workPlace: "", transport: "",
            holiday: "", welfare: "", childcare: "", interviewMemo: "",
            selectionProcess: JobCardDetailSelectionProcess(selectionProcess1: "", selectionProcess2: "", selectionProcess3: "", selectionProcess4: "", selectionProcess5: "", selectionProcessDetail: ""),
            contactInfo: JobCardDetailContactInfo(companyUrl: "", contactZipcode: "", contactAddress: "", contactPhone: "", contactPerson: "", contactMail: ""),
            companyDescription: JobCardDetailCompanyDescription(enterpriseContents: "", mainCustomer: "", mediaCoverage: "", established: "", employeesCount: JobCardDetailCompanyDescriptionEmployeesCount(count: nil, averageAge: nil, genderRatio: nil, middleEnter: nil)
                , capital: nil, turnover: nil, presidentData: JobCardDetailCompanyDescriptionPresidentData(presidentName: "", presidentHistory: "")),
            userFilter: UserFilterInfo(tudKeepStatus: false, tudSkipStatus: false))
    }

}


