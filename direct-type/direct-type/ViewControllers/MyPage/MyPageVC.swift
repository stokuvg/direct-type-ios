//
//  MyPageVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

//[H-1]
class MyPageVC: TmpNaviTopVC {

    //=== ダミーで定義しています
    //プロフィール
    @IBOutlet weak var btnButton01: UIButton!
    @IBAction func actButton01(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_ProfilePreviewVC") as? ProfilePreviewVC{
            self.navigationController?.pushViewController(nvc, animated: true)
        }
    }
    //履歴書
    @IBOutlet weak var btnButton02: UIButton!
    @IBAction func actButton02(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_ResumePreviewVC") as? ResumePreviewVC{
            self.navigationController?.pushViewController(nvc, animated: true)
        }
    }
    //職務経歴書・スキルシート
    @IBOutlet weak var btnButton03: UIButton!
    @IBAction func actButton03(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_CareerPreviewVC") as? CareerPreviewVC{
            self.navigationController?.pushViewController(nvc, animated: true)
        }
    }
    //さくさく職歴書
    @IBOutlet weak var btnButton04: UIButton!
    @IBAction func actButton04(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Preview", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SmoothCareerPreviewVC") as? SmoothCareerPreviewVC{
            self.navigationController?.pushViewController(nvc, animated: true)
        }
    }
    //認証
    @IBOutlet weak var btnButton05: UIButton!
    @IBAction func actButton05(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_CognitoAuthVC") as? CognitoAuthVC{
            self.navigationController?.pushViewController(nvc, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        btnButton01.setTitle("プロフィール", for: .normal)
        btnButton02.setTitle("履歴書", for: .normal)
        btnButton03.setTitle("職務経歴書・スキルシート", for: .normal)
        btnButton04.setTitle("さくさく職歴書", for: .normal)
        btnButton05.setTitle("認証", for: .normal)
    }
}
