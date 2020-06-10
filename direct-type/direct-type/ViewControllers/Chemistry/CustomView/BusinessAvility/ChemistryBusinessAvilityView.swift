//
//  ChemistryBusinessAvilityView.swift
//  direct-type
//
//  Created by yamataku on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistryBusinessAvilityView: NSObject {
    @IBOutlet weak var proportionBar: ProportionBarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var avilityScoreLabel: UILabel!
    
    static let height: CGFloat = 50
    weak var baseView: UIView!
    
    override init() {
        super.init()
        loadNib()
    }
    
    typealias ScoreSet = (type: BusinessAvilityType, ratio: Double)
    func configure(with scoreSet: ScoreSet) {
        proportionBar.valueRatio = scoreSet.ratio.toPercent
        titleLabel.text = scoreSet.type.nameLineBlakable
        avilityScoreLabel.text = getOptimizedScoreText(from: scoreSet.ratio)
    }
}

private extension ChemistryBusinessAvilityView {
    func loadNib() {
        baseView = UINib(nibName: "ChemistryBusinessAvilityView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func getOptimizedScoreText(from oldValue: Double) -> String {
        let rounded = round(oldValue*10)/10
        return rounded.truncatingRemainder(dividingBy: 1.0) == 0.0 ?
            String(Int(rounded)) : String(rounded)
    }
}

private extension Double {
    var toPercent: Double {
        return self / 10
    }
}
