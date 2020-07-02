//
//  ChemistryStart.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ChemistryStart: UIViewController {
    @IBOutlet private weak var iconCarouselView: IconCarouselView!
    @IBOutlet private weak var hukidashiLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBAction private func startDiagnosisButton(_ sender: UIButton) {
        transitionToChemisrortSelect()
    }
    
    private let carouselIconFrame = CGRect(x: .zero, y: .zero, width: 100, height: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconCarouselView.configure(with: generateCarouselIconView())
        iconCarouselView.startAnimation()
        setFont()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
}

private extension ChemistryStart {
    func setFont() {
        hukidashiLabel.font = UIFont(fontType: .font_SS)
        descriptionLabel.font = UIFont(fontType: .font_S)
    }
    
    func setNavigationBar() {
        navigationItem.title = ""
        
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.init(colorType: .color_sub)!
            navigationController?.navigationBar.standardAppearance.shadowColor = .clear
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColor.init(colorType: .color_sub)
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        }
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
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
