//
//  ChemistryResultFooterView.swift
//  direct-type
//
//  Created by yamataku on 2020/06/09.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

protocol ChemistryResultFooterViewDelegate: class {
    func didTapCompleteButton()
}

final class ChemistryResultFooterView: UIView {
    @IBOutlet private weak var whiteBackgroundView: UIView!
    @IBOutlet private weak var completeButton: UIButton!
    @IBAction private func completeButton(_ sender: UIButton) {
        delegate?.didTapCompleteButton()
    }
    
    private let whiteBackgroundViewCornerRadius: CGFloat = 10
    
    static let height: CGFloat = 120
    private var isExistsDat = false
    private weak var delegate: ChemistryResultFooterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        setCornerRadius()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
        setCornerRadius()
    }
    
    func configure(isExistsDat: Bool, delegate: ChemistryResultFooterViewDelegate) {
        self.isExistsDat = isExistsDat
        self.delegate = delegate
        setButtonText()
    }
}

private extension ChemistryResultFooterView {
    func loadNib() {
        guard let view = Bundle.main.loadNibNamed("ChemistryResultFooterView",
                                                  owner: self, options: nil)?
            .first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func setButtonText() {
        let buttonTitle = isExistsDat ? "もう一度診断する" : "マイページに戻る"
        completeButton.setTitle(buttonTitle, for: .normal)
    }
    
    func setCornerRadius() {
        whiteBackgroundView.layer.cornerRadius = whiteBackgroundViewCornerRadius
        whiteBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
}
