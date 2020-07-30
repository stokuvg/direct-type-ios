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
                は、はじめまして。あなた専属のAIアドバイザー「みつけ タイ子」です。（大変、緊張しております）

                あなたに代わり、わたしが転職先の候補をみつけます！！！

                まずは、1分ほどお時間いただき、いくつか質問をさせてください。
                """
            case .registeredAll:
                return """
                ありがとうございます！すぐに求人を探してきます！！

                はじめは、学習不足でご希望に合わないかもしれません。

                でも、あなたに合う求人を見つけたいので、
                ご希望に近いものは「キープ」をタップして、あなたの好みを教えてください。
                """
            }
        }
        
        
        var title: String {
            switch self {
            case .registeredPhoneNumber:
                return "プロフィール入力"
            case .registeredAll:
                return "プロフィール入力完了"
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
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        textView.setContentOffset(.zero, animated: false)
    }
    
    func configure(type: ContextType) {
        contextType = type
    }
}

private extension InitialInputCompleteVC {
    func setup() {
        textView.text = contextType.description
        navigationItem.hidesBackButton = true
        navigationItem.title = contextType.title
        
        let ud = UserDefaults.standard
        ud.set(false, forKey: "home")
        ud.set(true, forKey: "pushTab")
        if ud.synchronize() {
            Log.selectLog(logLevel: .debug, "ホーム画面　C1,タブ遷移 フラグの保存成功")
        }
    }
    
    func startAnimation() {
        imageView.animationImages = [closeMouthImage, openMouthImage]
        imageView.animationDuration = 1
        imageView.startAnimating()
    }
    
    func transitionToBaseTab() {
        let tabSB = UIStoryboard(name: "BaseTabBC", bundle: nil)
        let tabBC = tabSB.instantiateViewController(withIdentifier: "Sbid_BaseTabBC")
        UIApplication.shared.keyWindow?.rootViewController = tabBC
    }
}
