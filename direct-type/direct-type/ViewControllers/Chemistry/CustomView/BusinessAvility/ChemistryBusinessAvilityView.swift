//
//  ChemistryBusinessAvilityView.swift
//  direct-type
//
//  Created by yamataku on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistryBusinessAvilityView: UIView {
    @IBOutlet private weak var proportionBar: ProportionBarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var avilityScoreLabel: UILabel!
    
    static let height: CGFloat = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
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
        guard let view = Bundle.main.loadNibNamed("ChemistryBusinessAvilityView",
                                                  owner: self, options: nil)?
            .first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
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
