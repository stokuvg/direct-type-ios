//
//  StartDiagnosisVC.swift
//  direct-type
//
//  Created by yamataku on 2020/06/02.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class StartDiagnosisVC: UIViewController {
    @IBOutlet private weak var iconCarouselView: IconCarouselView!
    @IBAction private func startDiagnosisButton(_ sender: UIButton) {
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

private extension StartDiagnosisVC {
    func setNavigationBar() {
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
        DiagnosisResult.PersonalityType.allCases.forEach({ type in
            let image = UIImage(named: type.imageName)
            let imageView = UIImageView(frame: carouselIconFrame)
            imageView.image = image
            imageViews.append(imageView)
        })
        return imageViews
    }
}
