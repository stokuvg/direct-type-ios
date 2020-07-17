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
    case resumePreviewH3(_ entryMode: Bool)
    case careerPreviewC15
    case smoothCareerPreviewF11
    case firstInputPreviewA
    case careerListC
    case entryForm(_ routeFrom: AnalyticsEventType.RouteFromType)
    case entryConfirm
    case entryComplete
}

extension BaseVC {
    func pushViewController(_ type: PushVCType, model: Any? = nil) {
        switch type {
        case .profilePreviewH2://[H-2] プロフィール
            let storyboard = UIStoryboard(name: "Preview", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_ProfilePreviewVC") as? ProfilePreviewVC {
                nvc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に表示にする
                if let model = model as? MdlProfile { nvc.transferModel(profile: model) }//モデルがあれば横流す
                self.navigationController?.pushViewController(nvc, animated: true)
            }
        case .resumePreviewH3(let entryMode)://[H-3] 履歴書確認
            let storyboard = UIStoryboard(name: "Preview", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_ResumePreviewVC") as? ResumePreviewVC{
                nvc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に表示にする
                nvc.transferModel(anyModel: model, isEntryMode: entryMode) //モデルがあれば横流す
                self.navigationController?.pushViewController(nvc, animated: true)
            }
        case .careerPreviewC15://[C-15] 職務経歴書確認
            let storyboard = UIStoryboard(name: "Preview", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_CareerPreviewVC") as? CareerPreviewVC{
                nvc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に表示にする
                if let model = model as? MdlCareerCard{
                    print("TODO: モデルを引き渡す [\(model.debugDisp)]")
                }
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
                if let model = model as? MdlCareer{
                    print("TODO: モデルを引き渡す [\(model.debugDisp)]")
                }
                self.navigationController?.pushViewController(nvc, animated: true)
            }
        case .entryForm(let routeFrom)://[C-9] 応募フォーム
            let storyboard = UIStoryboard(name: "Preview", bundle: nil)
            if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_EntryFormVC") as? EntryFormVC{
                nvc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に表示にする
                nvc.routeFrom = routeFrom
                if let model = model as? MdlJobCardDetail {
                    nvc.initData(model) //求人カード詳細のデータを横流す
                }
                self.navigationController?.pushViewController(nvc, animated: true)
            }
            case .entryConfirm://[C-12] 応募確認
                let storyboard = UIStoryboard(name: "Preview", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_EntryConfirmVC") as? EntryConfirmVC{
                    nvc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に表示にする
                    if let (jobCard, profile, resume, career, entry) = model as? (MdlJobCardDetail, MdlProfile, MdlResume, MdlCareer, MdlEntry) {
                        nvc.initData(jobCard, profile, resume, career, entry) //求人カード詳細のデータを横流す
                    }
                    self.navigationController?.pushViewController(nvc, animated: true)
                }
            case .entryComplete://[C-14] 応募完了
                let storyboard = UIStoryboard(name: "Entry", bundle: nil)
                if let nvc = storyboard.instantiateViewController(withIdentifier: "Sbid_EntryCompleteVC") as? EntryCompleteVC{
                    nvc.hidesBottomBarWhenPushed = true//下部のTabBarを遷移時に表示にする
                    self.navigationController?.pushViewController(nvc, animated: true)
                }

        }
    }
}
