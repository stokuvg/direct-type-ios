//
//  ApproachSettingVC.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/04/28.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

final class ApproachSettingVC: TmpBasicVC {
    @IBOutlet private weak var scoutTitleLabel: UILabel!
    @IBOutlet private weak var recommendTitleLabel: UILabel!
    @IBOutlet private weak var scoutBackgroundView: UIView!
    @IBOutlet private weak var recommendBackgroundView: UIView!
    @IBOutlet private weak var scoutStateLabel: UILabel!
    @IBOutlet private weak var recommendStateLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBAction private func scoutButton(_ sender: UIButton) {
        isScoutEnable = !isScoutEnable
    }
    @IBAction private func recommendButton(_ sender: UIButton) {
        isRecommendEnable = !isRecommendEnable
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
    private var isRecommendEnable: Bool = false {
        didSet {
            recommendTitleLabel.textColor = UIColor(colorType: isScoutEnable ? .color_white : .color_black)
            recommendBackgroundView.backgroundColor = UIColor(colorType: isScoutEnable ? .color_sub : .color_white)
            recommendStateLabel.text = isScoutEnable ? inuseTitle : unuseTitle
            recommendStateLabel.textColor = UIColor(colorType: isScoutEnable ? .color_white : .color_black)
        }
    }
    
    private var approachSetting: MdlApproach?
    private let inuseTitle = "利用中"
    private let unuseTitle = "利用停止中"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setAttributedText()
    }
    
    override func viewDidLayoutSubviews() {
        setDisableView()
    }
    
    func configure(with approachSetting: MdlApproach) {
        self.approachSetting = approachSetting
    }
}

private extension ApproachSettingVC {
    func setup() {
        guard let approachSetting = approachSetting else { return }
        isScoutEnable = approachSetting.isScoutEnable
        isRecommendEnable = approachSetting.isRecommendationEnable
    }
    
    func saveSetting() {
        
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
    
    func setDisableView() {
        guard view.subviews.first(where: { $0 is DisableView }) == nil else { return }
        let disableView = DisableView(frame: recommendBackgroundView.frame)
        view.addSubview(disableView)
        view.bringSubviewToFront(disableView)
    }
}

extension ApproachSettingVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        // Web(アプローチ説明)を表示
        let vc = getVC(sbName: "Web", vcName: "SettingWebVC") as! SettingWebVC
        vc.setup(type: .approachExplanation)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true, completion: nil)
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
