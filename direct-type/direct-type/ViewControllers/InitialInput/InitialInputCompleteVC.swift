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
        pushViewController(.firstInputPreviewA)
    }
    
    private let closeMouthImage = UIImage(named: "suma_normal1")!
    private let openMouthImage = UIImage(named: "suma_normal2")!
    
    private var replaceText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startAnimation()
    }
    
    func replaceDescription(by text: String) {
        replaceText = text
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
}
