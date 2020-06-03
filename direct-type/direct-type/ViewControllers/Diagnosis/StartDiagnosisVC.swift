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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
