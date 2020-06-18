//
//  BaseVC+PushViewController.swift
//  direct-type
//
//  Created by ms-mb014 on 2020/06/18.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

enum PushVCType {
    case profilePreviewH2
    case resumePreviewH3
    case careerPreviewC15
    case smoothCareerPreviewF11
    case firstInputPreviewA
    case careerListC
}

extension BaseVC {
    func pushViewController(_ type: PushVCType) {
        switch type {
        case .profilePreviewH2://[H-3] 履歴書確認
            let storyboard = UIStoryboard(name: "Preview", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_ProfilePreviewVC") as? ProfilePreviewVC {
                nvc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に表示にする
                self.navigationController?.pushViewController(nvc, animated: true)
            }
        case .resumePreviewH3://[H-3] 履歴書確認
            let storyboard = UIStoryboard(name: "Preview", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_ResumePreviewVC") as? ResumePreviewVC{
                nvc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に表示にする
                self.navigationController?.pushViewController(nvc, animated: true)
            }
        case .careerPreviewC15://[C-15] 職務経歴書確認
            let storyboard = UIStoryboard(name: "Preview", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_CareerPreviewVC") as? CareerPreviewVC{
                nvc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に表示にする
                self.navigationController?.pushViewController(nvc, animated: true)
            }
        case .smoothCareerPreviewF11://[F-11] サクサク職歴
            let storyboard = UIStoryboard(name: "Preview", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_SmoothCareerPreviewVC") as? SmoothCareerPreviewVC{
                nvc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に表示にする
                self.navigationController?.pushViewController(nvc, animated: true)
            }
        case .firstInputPreviewA://A[系統] 初期入力
            let storyboard = UIStoryboard(name: "Preview", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_FirstInputPreviewVC") as? FirstInputPreviewVC{
                nvc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に表示にする
                self.navigationController?.pushViewController(nvc, animated: true)
            }
        case .careerListC://C[仮] 職歴一覧
            let storyboard2 = UIStoryboard(name: "Career", bundle: nil)
            if let nvc = storyboard2.instantiateViewController(withIdentifier: "Sbid_CareerListVC") as? CareerListVC{
                nvc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に表示にする
                self.navigationController?.pushViewController(nvc, animated: true)
            }

        }
    }
}
