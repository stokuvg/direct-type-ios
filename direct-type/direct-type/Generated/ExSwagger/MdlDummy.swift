
//
//  MdlDummy.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/07/06.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

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
