//
//  MemberReportCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class MemberReportCell: MalaBaseMemberCardCell {
    
    // MARK: - Property
    /// 总练习数
    var totalNum: CGFloat = 1 {
        didSet {
            answerNumberLabel.text = String(format: "%d", Int(totalNum))
        }
    }
    /// 练习正确数
    var rightNum: CGFloat = 0 {
        didSet {
            // 若总练习数为零
            correctRateLabel.text = (totalNum == 0 ? "0%" : String(format: "%.2f%%", CGFloat(rightNum/totalNum)))
        }
    }

    
    // MARK: - Components
    /// 按钮
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("查看我的学习报告", for: .normal)
        button.titleLabel?.font = FontFamily.PingFangSC.Regular.font(18)
        button.setBackgroundImage(UIImage(asset: .noteButtonNormal), for: .normal)
        button.setBackgroundImage(UIImage(asset: .noteButtonPress), for: .highlighted)
        button.setBackgroundImage(UIImage(asset: .noteButtonPress), for: .selected)
        return button
    }()
    /// 学科标签
    private lazy var subjectLabel: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named:"subject_background"), for: .normal)
        button.setTitle("数学", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: -2)
        button.isUserInteractionEnabled = false
        return button
    }()
    /// 标题标签
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: L10n.report,
            fontSize: 15,
            textColor: UIColor(named: .ArticleTitle)
        )
        return label
    }()
    /// 中央垂直分割线
    private lazy var separator: UIView = {
        let view = UIView(UIColor(named: .SeparatorLine))
        return view
    }()
    /// 答题数标签
    private lazy var answerNumberLabel: UILabel = {
        let label = UILabel(
            text: "0",
            fontSize: 35,
            textColor: UIColor(named: .ArticleTitle)
        )
        label.textAlignment = .center
        return label
    }()
    /// 正确率标签
    private lazy var correctRateLabel: UILabel = {
        let label = UILabel(
            text: "0％",
            fontSize: 35,
            textColor: UIColor(named: .ArticleTitle)
        )
        label.textAlignment = .center
        return label
    }()
    /// 答题数图例
    private lazy var answerNumberLegend: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(asset: .answerNumber), for: .normal)
        button.setTitle("答题数", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(UIColor(named: .ArticleText), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
        button.isUserInteractionEnabled = false
        return button
    }()
    /// 正确率图例
    private lazy var correctRateLegend: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(asset: .correctRate), for: .normal)
        button.setTitle("正确率", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(UIColor(named: .ArticleText), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    
    // MARK: - Instance Method
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setup() {
        setupDefaultStyle(image: .reportNormal, title: "学习报告目前只支持数学科目！", buttonTitle: "查看学习报告样本")
        actionButton.addTarget(self, action: #selector(MemberReportCell.buttonDidTap), for: .touchUpInside)
    }
    
    
    // MARK: - Event Response
    @objc private func buttonDidTap() {
        NotificationCenter.default.post(name: MalaNotification_ShowLearningReport, object: 0)
    }
    /// 登录
    @objc private func login() {
        println("登录")
        NotificationCenter.default.post(name: MalaNotification_ShowLearningReport, object: -1)
    }
    /// 显示学习报告样本
    @objc private func showReportDemo() {
        println("样本")
        NotificationCenter.default.post(name: MalaNotification_ShowLearningReport, object: 0)
    }
    /// 显示我的学习报告
    @objc private func showMyReport() {
        println("报告")
        NotificationCenter.default.post(name: MalaNotification_ShowLearningReport, object: 1)
    }
    /// 重新获取学习报告
    @objc private func reloadStatus() {
        println("重新获取")
        NotificationCenter.default.post(name: MalaNotification_ReloadLearningReport, object: nil)
    }
}
