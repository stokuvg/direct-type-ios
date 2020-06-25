//
//  InitialInputCompleteVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class InitialInputCompleteVC: TmpBasicVC {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    
    @IBAction private func nextButton(_ sender: UIButton) {
        switch transitionDestination {
        case .firstInput:
            pushViewController(.firstInputPreviewA)
        case .homeTab:
            transitionToBaseTab()
        }
    }
    
    enum TransitionDestinationTypr {
        case firstInput
        case homeTab
    }
    
    private let closeMouthImage = UIImage(named: "suma_normal1")!
    private let openMouthImage = UIImage(named: "suma_normal2")!
    
    private var replaceText: String?
    private var transitionDestination = TransitionDestinationTypr.firstInput
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startAnimation()
    }
    
    func replaceDescription(by text: String) {
        replaceText = text
    }
    
    func changeTransitionDestination(type: TransitionDestinationTypr) {
        transitionDestination = type
    }
}

private extension InitialInputCompleteVC {
    func setup() {
        textView.text = replaceText ?? textView.text
        navigationItem.hidesBackButton = true
    }
    
    func startAnimation() {
        imageView.animationImages = [closeMouthImage, openMouthImage]
        imageView.animationDuration = 1
        imageView.startAnimating()
    }
    
    func transitionToBaseTab() {
        let tabSB = UIStoryboard(name: "BaseTabBC", bundle: nil)
        let tabBC = tabSB.instantiateViewController(withIdentifier: "Sbid_BaseTabBC")
        let newNavigationController = UINavigationController(rootViewController: tabBC)
        UIApplication.shared.keyWindow?.rootViewController = newNavigationController
    }
}
