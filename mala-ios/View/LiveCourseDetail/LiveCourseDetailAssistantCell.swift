//
//  LiveCourseDetailAssistantCell.swift
//  mala-ios
//
//  Created by 王新宇 on 2016/11/21.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LiveCourseDetailAssistantCell: MalaBaseLiveCourseCell {

    // MARK: - Property
    /// 课程模型
    var model: LiveClassModel? {
        didSet{
            guard let model = model else { return }
            assistantNameLabel.text = String(format: "助教：%@", model.assistantName ?? "")
        }
    }
    
    
    // MARK: - Components
    /// 讲师姓名
    private lazy var assistantNameLabel: UILabel = {
        let label = UILabel(
            text: "助教",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .ArticleTitle)
        )
        return label
    }()
    /// 说明文字
    private lazy var descLabel: UILabel = {
        let label = UILabel(
            text: "对课程有疑问？快打电话咨询助教老师吧！",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .protocolGary)
        )
        label.numberOfLines = 0
        return label
    }()
    /// 头像框
    private lazy var phoneIcon: UIImageView = {
        let imageView = UIImageView(image: "live_phone")
        imageView.addTapEvent(target: self, action: #selector(LiveCourseDetailAssistantCell.phoneDidTap))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    // MARK: - Instance Method
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // SubViews
        content.addSubview(assistantNameLabel)
        content.addSubview(descLabel)
        content.addSubview(phoneIcon)
        
        // Autolayout
        assistantNameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(10)
            maker.left.equalTo(content)
            maker.height.equalTo(14)
        }
        descLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(assistantNameLabel.snp.bottom).offset(10)
            maker.left.equalTo(assistantNameLabel)
            maker.bottom.equalTo(content).offset(-10)
        }
        phoneIcon.snp.makeConstraints { (maker) in
            maker.right.equalTo(content).offset(-6)
            maker.centerY.equalTo(content)
            maker.height.equalTo(44)
            maker.width.equalTo(44)
        }
    }
    
    
    // MARK: - Events Response
    @objc private func phoneDidTap() {
        NotificationCenter.default.post(name: MalaNotification_MakePhoneCall, object: model?.assistantPhone)
    }
}
