//
//  AbilityCalculation.swift
//  direct-type
//
//  Created by yamataku on 2020/06/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import Foundation

struct AbilityCalculation {
    private var questionScores: [ChemistryScore]
    
    init(questionScores: [ChemistryScore]) {
        self.questionScores = questionScores
    }
    
    typealias RankDataSet = (rank: Int, score: Int, personalType: ChemistryPersonalityType)
    var abilityRanking: [RankDataSet] {
        var rank = [RankDataSet]()
        
        ChemistryPersonalityType.allCases.forEach({
            let totalScore = getTotalScore(type: $0)
            let rankSet = RankDataSet(rank: 0, score: totalScore, personalType: $0)
            rank.append(rankSet)
        })
        
        rank.sort(by: {
            guard $0.score != $1.score else {
                return $0.personalType.priority < $1.personalType.priority
            }
            return $0.score > $1.score
        })
        
        return rank.enumerated().map({
            RankDataSet(rank: getRank(from: $0), score: $1.score, personalType: $1.personalType)
        })
    }
}

private extension AbilityCalculation {
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
