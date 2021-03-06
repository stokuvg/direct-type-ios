//
//  ApproachSettingVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit
import TudApi
import SVProgressHUD

final class ApproachSettingVC: TmpBasicVC {
    @IBOutlet private weak var scoutTitleLabel: UILabel!
    @IBOutlet private weak var scoutBackgroundView: UIView!
    @IBOutlet private weak var scoutStateLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBAction private func scoutButton(_ sender: UIButton) {
        isScoutEnable = !isScoutEnable
    }
    @IBAction private func saveButton(_ sender: UIButton) {
        saveSetting()
    }
    
    private var isScoutEnable: Bool = false {
        didSet {
            scoutTitleLabel.textColor = UIColor(colorType: isScoutEnable ? .color_white : .color_black)
            scoutBackgroundView.backgroundColor = UIColor(colorType: isScoutEnable ? .color_sub : .color_white)
            scoutStateLabel.text = isScoutEnable ? inuseTitle : unuseTitle
            scoutStateLabel.textColor = UIColor(colorType: isScoutEnable ? .color_white : .color_black)
        }
    }
    
    private let inuseTitle = "利用中"
    private let unuseTitle = "利用停止中"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setAttributedText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchApproachData()
    }
}

private extension ApproachSettingVC {
    func setup() {
        navigationItem.title = "アプローチ設定"
    }
    
    func fetchApproachData() {
        SVProgressHUD.show(withStatus: "設定情報の取得")
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        LogManager.appendApiLog("getApproach", nil, function: #function, line: #line)
        ApiManager.getApproach(())
        .done { result in
            LogManager.appendApiResultLog("getApproach", result, function: #function, line: #line)
            self.isScoutEnable = result.scoutEnable
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("getApproach", error, function: #function, line: #line)
            let myError: MyErrorDisp = AuthManager.convAnyError(error)
            print("アプローチデータ取得エラー！　コード: \(myError.code)")
            self.showError(myError)
        }
        .finally {
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        }
    }
    
    func saveSetting() {
        SVProgressHUD.show()
        LogManager.appendLogProgressIn("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
        let param = UpdateSettingsRequestDTO(scoutEnable: isScoutEnable)
        LogManager.appendApiLog("updateApproach", param, function: #function, line: #line)
        ApiManager.updateApproach(param, isRetry: true)
        .done { result in
            LogManager.appendApiResultLog("updateApproach", result, function: #function, line: #line)
        }
        .catch { (error) in
            LogManager.appendApiErrorLog("updateApproach", error, function: #function, line: #line)
            let myErr: MyErrorDisp = AuthManager.convAnyError(error)
            print(myErr)
        }
        .finally {
            SVProgressHUD.dismiss(); /*Log出力*/LogManager.appendLogProgressOut("[\(NSString(#file).lastPathComponent)] [\(#line): \(#function)]")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    var linkedText: String { "こちら" }
    func setAttributedText() {
        let attributedText = NSMutableAttributedString(string: descriptionTextView.text!)
        let range = NSString(string: descriptionTextView.text!).range(of: linkedText)
        attributedText.addAttribute(.link, value: "", range: range)
        descriptionTextView.attributedText = attributedText
        descriptionTextView.linkTextAttributes = [.foregroundColor: UIColor(colorType: .color_sub)!]
        descriptionTextView.isSelectable = true
        descriptionTextView.isEditable = false
        descriptionTextView.delegate = self
    }
}

extension ApproachSettingVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // Web(アプローチ説明)を表示
        OpenLinkUrlTool.open(type: .AproachAbout, navigationController)
        return false
    }
}

private final class DisableView: UIView {
    private let halfAlphaValue: CGFloat = 0.5
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .lightGray
        alpha = halfAlphaValue
    }
}
