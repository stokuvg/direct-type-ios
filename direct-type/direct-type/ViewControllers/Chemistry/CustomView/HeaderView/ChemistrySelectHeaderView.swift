//
//  ChemistrySelectHeaderView.swift
//  direct-type
//
//  Created by yamataku on 2020/06/04.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistrySelectHeaderView: UIView {
    @IBOutlet private weak var whiteBackgroundView: UIView!
    @IBOutlet private weak var hukidashiLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    static let height: CGFloat = 200
    private let whiteBackgroundViewCornerRadius: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        setCornerRadius()
        setFont()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
        setCornerRadius()
        setFont()
    }
}

private extension ChemistrySelectHeaderView {
    func loadNib() {
        guard let view = Bundle.main.loadNibNamed("ChemistrySelectHeaderView",
                                                  owner: self, options: nil)?
            .first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func setFont() {
        hukidashiLabel.font = UIFont(fontType: .font_SSS)
        titleLabel.font = UIFont(fontType: .font_L)
    }
    
    func setCornerRadius() {
        whiteBackgroundView.layer.cornerRadius = whiteBackgroundViewCornerRadius
        whiteBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
