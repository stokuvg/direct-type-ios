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
    @IBAction private func startDiagnosisButton(_ sender: UIButton) {
        transitionToChemisrortSelect()
    }
    
    private let carouselIconFrame = CGRect(x: .zero, y: .zero, width: 100, height: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconCarouselView.configure(with: generateCarouselIconView())
        iconCarouselView.startAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
}

private extension ChemistryStart {
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
        ChemistryEntity.PersonalityType.allCases.forEach({ type in
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
