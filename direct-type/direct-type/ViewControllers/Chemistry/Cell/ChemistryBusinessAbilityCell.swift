//
//  ChemistryBusinessAbilityCell.swift
//  direct-type
//
//  Created by yamataku on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistryBusinessAbilityCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var avilityStackView: UIStackView!
    private var avilityScore: BusinessAvilityScore?
    
    func configure(with avilityScore: BusinessAvilityScore) {
        self.avilityScore = avilityScore
        setFont()
    }
    
    func setLayout() {
        guard let avilityScore = avilityScore else { return }
        avilityStackView.subviews.forEach({ $0.removeFromSuperview() })
        BusinessAvilityType.allCases.forEach({ type in
            let avilityViewFrame = CGRect(x: .zero, y: .zero, width: frame.width, height: ChemistryBusinessAvilityView.height)
            let avilityView = ChemistryBusinessAvilityView()
            avilityView.baseView.bounds = avilityViewFrame
            switch type {
            case .quickAction:
                let scoreSet = ChemistryBusinessAvilityView.ScoreSet(type: type, ratio: avilityScore.quickAction)
                avilityView.configure(with: scoreSet)
            case .toughness:
                let scoreSet = ChemistryBusinessAvilityView.ScoreSet(type: type, ratio: avilityScore.toughness)
                avilityView.configure(with: scoreSet)
            case .spiritOfChallenge:
                let scoreSet = ChemistryBusinessAvilityView.ScoreSet(type: type, ratio: avilityScore.spiritOfChallenge)
                avilityView.configure(with: scoreSet)
            case .logical:
                let scoreSet = ChemistryBusinessAvilityView.ScoreSet(type: type, ratio: avilityScore.logical)
                avilityView.configure(with: scoreSet)
            case .leadership:
                let scoreSet = ChemistryBusinessAvilityView.ScoreSet(type: type, ratio: avilityScore.leadership)
                avilityView.configure(with: scoreSet)
            case .dedicationAndSupport:
                let scoreSet = ChemistryBusinessAvilityView.ScoreSet(type: type, ratio: avilityScore.dedicationAndSupport)
                avilityView.configure(with: scoreSet)
            case .cooperativeness:
                let scoreSet = ChemistryBusinessAvilityView.ScoreSet(type: type, ratio: avilityScore.cooperativeness)
                avilityView.configure(with: scoreSet)
            case .initiative:
                let scoreSet = ChemistryBusinessAvilityView.ScoreSet(type: type, ratio: avilityScore.initiative)
                avilityView.configure(with: scoreSet)
            case .creativityAndIdea:
                let scoreSet = ChemistryBusinessAvilityView.ScoreSet(type: type, ratio: avilityScore.creativityAndIdea)
                avilityView.configure(with: scoreSet)
            case .responsibilityAndSteadiness:
                let scoreSet = ChemistryBusinessAvilityView.ScoreSet(type: type, ratio: avilityScore.responsibilityAndSteadiness)
                avilityView.configure(with: scoreSet)
            }
            avilityStackView.addArrangedSubview(avilityView.baseView)
        })
    }
}

private extension ChemistryBusinessAbilityCell {
    func setFont() {
        titleLabel.font = UIFont(fontType: .font_L)
    }
}
