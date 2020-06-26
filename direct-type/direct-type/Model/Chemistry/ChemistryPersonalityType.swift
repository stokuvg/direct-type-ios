//
//  ChemistryPersonalityType.swift
//  direct-type
//
//  Created by yamataku on 2020/06/05.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

enum ChemistryPersonalityType: Int, CaseIterable {
    case reformer
    case helper
    case toAchieve
    case unique
    case toExamine
    case faithful
    case enthusiastic
    case challenger
    case peaceful
    
    var title: String {
        switch self {
        case .reformer:
            return "改革する人"
        case .helper:
            return "人を助ける人"
        case .toAchieve:
            return "達成する人"
        case .unique:
            return "個性的な人"
        case .toExamine:
            return "調べる人"
        case .faithful:
            return "忠実な人"
        case .enthusiastic:
            return "熱中する人"
        case .challenger:
            return "挑戦する人"
        case .peaceful:
            return "平和をもたらす人"
        }
    }
    
    var imageName: String {
        switch self {
        case .reformer:
            return "suma_kaikaku"
        case .helper:
            return "suma_tasukeru"
        case .toAchieve:
            return "suma_tassei"
        case .unique:
            return "suma_kosei"
        case .toExamine:
            return "suma_shiraberu"
        case .faithful:
            return "suma_chuujitu"
        case .enthusiastic:
            return "suma_necchu"
        case .challenger:
            return "suma_chousen"
        case .peaceful:
            return "suma_heiwa"
        }
    }
    
    var priority: Int {
        switch self {
        case .reformer:
            return 1
        case .toAchieve:
            return 2
        case .challenger:
            return 3
        case .enthusiastic:
            return 4
        case .faithful:
            return 5
        case .toExamine:
            return 6
        case .peaceful:
            return 7
        case .helper:
            return 8
        case .unique:
            return 9
        }
    }
    
    var description: String {
        switch self {
        case .reformer:
            return "このタイプの人は、自分に厳しく、いつも理想に向かって努力します。社会派で倫理的・現実的な考えのもと、周りを良くしていこう、自分を向上させようと努力を惜しみません。褒められると反論しますが、ホントは褒められるの大好きです。"
        case .helper:
            return "このタイプの人は、察しがよくて温かく、人の役にたつこと、支えることに人一倍長けています。いつも明るく、チームの雰囲気を良くします。また、人の良い部分を引き出すのが得意です。 お腹が空くと機嫌が悪くなります。"
        case .toAchieve:
            return "このタイプの人は、何時もはっきりした目的、目標をもっていて、その達成のためにはどうしたらよいかを考えています。途中経過は気にせず、ゴール目指して一直線に進むことができます。じつは、人からどう見られるかがとても気になっています。"
        case .unique:
            return "このタイプの人は、独創的で洞察力に優れ、熱心かつセンスが良いため、人や世間を魅了するものを生み出す力があります。 表面的な人付き合いを好まず、悩みを抱えた人には真剣に手を差し伸べます。 弱ると殻に閉じこもります。 "
        case .toExamine:
            return "このタイプの人は、物事をじっくりと考え、感情に流されずに冷静で的確な判断ができる人です。関心のあることに没頭し、極めていく能力に長けています。リアクションは基本的に薄いですが、じつは誰より楽しんでいたりします。"
        case .faithful:
            return "このタイプの人は、仲間思いでとても誠実です。責任のために身を粉にしてまで努力し、やり抜く力があります。人と協力しながら働くのが得意です。用心深く、ルールをきっちり守ります。他人の嘘を見破るセンサーを持っています。"
        case .enthusiastic:
            return "このタイプの人は、楽観的で明るく、エネルギッシュです。好奇心旺盛で器用、かつ、みんなでワイワイすることが大好きなので、人脈を広げることに長けています。人と人をつなげる役割を果たすこともできます。計画の細かい詰めは甘いです。"
        case .challenger:
            return "このタイプの人は、闘志に溢れた人です。強い実行力で、大きな目標に向かって果敢に挑むことができます。弱い立場の人を体を張って守り、頼りにされます。声が大きく、「圧がすごい」と言われがちです。"
        case .peaceful:
            return "このタイプの人は、寛大で偏見がなく聞き上手です。受容力に富んでおり、物事を深く受け入れることができます。そのため、長く安定して力を発揮します。争い事を好まないマイペースな人です。地味に頑張っていて、うまくいかない時はふて寝します。"
        }
    }
    
    var avilityScore: BusinessAvilityScore {
        switch self {
        case .reformer:
            return BusinessAvilityScore(quickAction: 6, toughness: 8, spiritOfChallenge: 8, logical: 7, leadership: 7, dedicationAndSupport: 6, cooperativeness: 6, initiative: 6, creativityAndIdea: 5, responsibilityAndSteadiness: 9)
        case .helper:
            return BusinessAvilityScore(quickAction: 6, toughness: 7, spiritOfChallenge: 7, logical: 6, leadership: 6, dedicationAndSupport: 9, cooperativeness: 9, initiative: 6, creativityAndIdea: 5, responsibilityAndSteadiness: 7)
        case .toAchieve:
            return BusinessAvilityScore(quickAction: 9, toughness: 6, spiritOfChallenge: 7, logical: 8, leadership: 9, dedicationAndSupport: 5, cooperativeness: 5, initiative: 7, creativityAndIdea: 7, responsibilityAndSteadiness: 5)
        case .unique:
            return BusinessAvilityScore(quickAction: 8, toughness: 6, spiritOfChallenge: 9, logical: 6, leadership: 6, dedicationAndSupport: 5, cooperativeness: 5, initiative: 9, creativityAndIdea: 9, responsibilityAndSteadiness: 5)
        case .toExamine:
            return BusinessAvilityScore(quickAction: 5, toughness: 9, spiritOfChallenge: 6, logical: 9, leadership: 6, dedicationAndSupport: 5, cooperativeness: 6, initiative: 5, creativityAndIdea: 9, responsibilityAndSteadiness: 8)
        case .faithful:
            return BusinessAvilityScore(quickAction: 6, toughness: 9, spiritOfChallenge: 5, logical: 6, leadership: 5, dedicationAndSupport: 8, cooperativeness: 8, initiative: 6, creativityAndIdea: 6, responsibilityAndSteadiness: 9)
        case .enthusiastic:
            return BusinessAvilityScore(quickAction: 9, toughness: 5, spiritOfChallenge: 9, logical: 5, leadership: 8, dedicationAndSupport: 5, cooperativeness: 6, initiative: 8, creativityAndIdea: 8, responsibilityAndSteadiness: 5)
        case .challenger:
            return BusinessAvilityScore(quickAction: 7, toughness: 7, spiritOfChallenge: 9, logical: 8, leadership: 8, dedicationAndSupport: 5, cooperativeness: 5, initiative: 8, creativityAndIdea: 5, responsibilityAndSteadiness: 6)
        case .peaceful:
            return BusinessAvilityScore(quickAction: 5, toughness: 7, spiritOfChallenge: 5, logical: 7, leadership: 6, dedicationAndSupport: 9, cooperativeness: 9, initiative: 7, creativityAndIdea: 5, responsibilityAndSteadiness: 8)
        }
    }
}
