//
//  ChemistryScoreCalculation.swift
//  direct-type
//
//  Created by yamataku on 2020/06/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

struct ChemistryScoreCalculation {
    private var questionScores: [ChemistryScore]
    private let acceptedScoreDistance: Int = 3
    
    init(questionScores: [ChemistryScore]) {
        self.questionScores = questionScores
    }
    
    typealias RankDataSet = (rank: Int, score: Int, personalType: ChemistryPersonalityType)
    var ranking: [RankDataSet] {
        var rank = [RankDataSet]()
        
        ChemistryPersonalityType.allCases.forEach({
            guard $0 != .undefine else { return }
            let totalScore = getTotalScore(type: $0)
            let rankSet = RankDataSet(rank: 0, score: totalScore, personalType: $0)
            rank.append(rankSet)
        })
        
        rank.sort(by: {
            // スコアは基本降順にするが、同一順位だった場合には優先度を考慮する
            guard $0.score != $1.score else {
                return $0.personalType.priority < $1.personalType.priority
            }
            return $0.score > $1.score
        })
        
        return rank.enumerated().map({
            RankDataSet(rank: getRank(from: $0), score: $1.score, personalType: $1.personalType)
        })
    }
    
    typealias TopRanker = (first: ChemistryPersonalityType, second: ChemistryPersonalityType?, third: ChemistryPersonalityType?)
    var topThree: TopRanker {
        let firstPlace = ranking[0]
        let secondPlace = ranking[1]
        let thirdPlace = ranking[2]
        
        guard abs(firstPlace.score.distance(to: secondPlace.score)) < acceptedScoreDistance else {
            return TopRanker(first: firstPlace.personalType, second: nil, third: nil)
        }
        guard abs(secondPlace.score.distance(to: thirdPlace.score)) < acceptedScoreDistance else {
            return TopRanker(first: firstPlace.personalType, second: secondPlace.personalType, third: nil)
        }
        return TopRanker(first: firstPlace.personalType, second: secondPlace.personalType, third: thirdPlace.personalType)
    }
}

private extension ChemistryScoreCalculation {
    func getTotalScore(type: ChemistryPersonalityType) -> Int {
        var totalScore = 0
        let targetScores = questionScores.filter({ $0.personalType == type })
        targetScores.forEach({
            totalScore += $0.selectedAnswer.score ?? 0
        })
        return totalScore
    }
    
    func getRank(from index: Int) -> Int {
        return index + 1
    }
}
