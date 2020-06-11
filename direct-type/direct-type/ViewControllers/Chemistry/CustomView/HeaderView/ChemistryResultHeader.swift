//
//  ChemistryResultHeader.swift
//  direct-type
//
//  Created by yamataku on 2020/06/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistryResultHeader: UIView {
    @IBOutlet private weak var whiteBackgroundView: UIView!
    @IBOutlet private weak var firstPlaceImageView: UIImageView!
    @IBOutlet private weak var secondPlaceImageView: UIImageView!
    @IBOutlet private weak var thirdPlaceImageView: UIImageView!
    @IBOutlet private weak var secondPlaceView: UIView!
    @IBOutlet private weak var thirdPlaceView: UIView!
    @IBOutlet private weak var firstPlaceLabel: UILabel!
    @IBOutlet private weak var secondPlaceLabel: UILabel!
    @IBOutlet private weak var thirdPlaceLabel: UILabel!
    @IBOutlet private weak var firstAndLabel: UILabel!
    @IBOutlet private weak var secondAndLabel: UILabel!
    @IBOutlet private weak var resultTitleLabel: UILabel!
    
    
    static let height: CGFloat = 230
    private let whiteBackgroundViewCornerRadius: CGFloat = 10
    private var topThree: ChemistryScoreCalculation.TopRanker?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        setFont()
        setCornerRadius()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
        setFont()
        setCornerRadius()
    }
    
    func configure(with topThree: ChemistryScoreCalculation.TopRanker) {
        self.topThree = topThree
        setImageAndLabel()
    }
}

private extension ChemistryResultHeader {
    func loadNib() {
        guard let view = Bundle.main.loadNibNamed("ChemistryResultHeader",
                                                  owner: self, options: nil)?
            .first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func setFont() {
        [firstPlaceLabel, secondPlaceLabel, thirdPlaceLabel].forEach({ label in
            label.font = UIFont(fontType: .font_Sb)
        })
        [firstAndLabel, secondAndLabel].forEach({ label in
            label.font = UIFont(fontType: .font_SSS)
        })
        resultTitleLabel.font = UIFont(fontType: .font_XL)
    }
    
    func setCornerRadius() {
        whiteBackgroundView.layer.cornerRadius = whiteBackgroundViewCornerRadius
        whiteBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setImageAndLabel() {
        guard let topThree = topThree else { return }
        secondPlaceView.isHidden = topThree.second == nil
        firstAndLabel.isHidden = topThree.second == nil
        thirdPlaceView.isHidden = topThree.third == nil
        secondAndLabel.isHidden = topThree.third == nil
        
        firstPlaceImageView.image = UIImage(named: topThree.first.imageName)
        firstPlaceLabel.text = topThree.first.rawValue
        
        if let secondPlace = topThree.second {
            secondPlaceImageView.image = UIImage(named: secondPlace.imageName)
            secondPlaceLabel.text = secondPlace.rawValue
        }
        
        if let thirdPlace = topThree.third {
            thirdPlaceImageView.image = UIImage(named: thirdPlace.imageName)
            thirdPlaceLabel.text = thirdPlace.rawValue
        }
    }
}
