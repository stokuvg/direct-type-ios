//
//  ChemistryStart.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistryStart: BaseChemistryVC {
    @IBOutlet private weak var iconCarouselView: IconCarouselView!
    @IBOutlet private weak var hukidashiLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBAction private func startDiagnosisButton(_ sender: UIButton) {
        transitionToChemisrortSelect()
    }
    
    private let carouselIconFrame = CGRect(x: .zero, y: .zero, width: 150, height: 150)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconCarouselView.configure(with: generateCarouselIconView())
        iconCarouselView.startAnimation()
        setFont()
    }
}

private extension ChemistryStart {
    func setFont() {
        hukidashiLabel.font = UIFont(fontType: .font_SS)
        descriptionLabel.font = UIFont(fontType: .font_S)
    }
    
    func generateCarouselIconView() -> [UIImageView]{
        var imageViews = [UIImageView]()
        ChemistryPersonalityType.allCases.forEach({ type in
            guard type != .undefine else { return }
            let image = UIImage(named: type.imageName)
            let imageView = UIImageView(frame: carouselIconFrame)
            imageView.image = image
            imageViews.append(imageView)
        })
        return imageViews
    }
    
    func transitionToChemisrortSelect() {
        let vc = UIStoryboard(name: "ChemistrySelect", bundle: nil)
            .instantiateInitialViewController() as! ChemistrySelect
        hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に非表示にする
        navigationController?.pushViewController(vc, animated: true)
    }
}
