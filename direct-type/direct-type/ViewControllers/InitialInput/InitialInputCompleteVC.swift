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
        switch contextType {
        case .registeredPhoneNumber:
            pushViewController(.firstInputPreviewA)
        case .registeredAll:
            transitionToBaseTab()
        }
    }
    
    enum ContextType {
        case registeredPhoneNumber
        case registeredAll
        
        var description: String {
            switch self {
            case .registeredPhoneNumber:
                return """
                はじめまして。
                ＡＩキャリアアドバイザーのスマ澤と申します。
                あなた専属のアドバイザーとして転職活動をサポートします。
                
                よろしくお願いいたします。
                
                早速ですがあなたのことを教えてください。
                
                これからいくつか質問をさせていただきます。
                だいたい3分程度かかる見込みです。
                
                入力いただいた内容から
                あなたに合った求人を探していきますね。
                """
            case .registeredAll:
                return """
                入力お疲れ様でした！
                さっそくホームを開いて求人を見てみましょう
                """
            }
        }
    }
    
    private let closeMouthImage = UIImage(named: "suma_normal1")!
    private let openMouthImage = UIImage(named: "suma_normal2")!
    private var contextType: ContextType = .registeredPhoneNumber
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startAnimation()
        AnalyticsEventManager.track(type: .confirmAuthCode)
    }
    
    func configure(type: ContextType) {
        contextType = type
    }
}

private extension InitialInputCompleteVC {
    func setup() {
        textView.text = contextType.description
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
