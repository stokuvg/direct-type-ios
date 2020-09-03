//
//  ChemistryResultPersonalTypeCell.swift
//  direct-type
//
//  Created by yamataku on 2020/06/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistryResultPersonalTypeCell: UITableViewCell {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var personalTypeLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var personalType: ChemistryPersonalityType?
    
    func configure(with personalType: ChemistryPersonalityType?) {
        self.personalType = personalType
        setup()
    }
}

private extension ChemistryResultPersonalTypeCell {
    
    func setup() {
        guard let personalType = personalType else { return }
        iconImageView.image = UIImage(named: personalType.imageName)
        personalTypeLabel.text(text: personalType.title, fontType: .font_M, textColor: UIColor(colorType: .color_black)!, alignment: .left)
        descriptionLabel.text(text: personalType.description, fontType: .font_S, textColor: UIColor(colorType: .color_black)!, alignment: .left)
    }
}
