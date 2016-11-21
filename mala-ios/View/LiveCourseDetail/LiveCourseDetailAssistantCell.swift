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
            assistantAvatar.setImage(withURL: model.assistantAvatar, placeholderImage: "avatar_placeholder")
        }
    }
    
    
    // MARK: - Components
    /// 讲师姓名
    private lazy var assistantNameLabel: UILabel = {
        let label = UILabel(
            text: "助教",
            font: UIFont(name: "PingFang-SC-Light", size: 14),
            textColor: MalaColor_636363_0
        )
        return label
    }()
    /// 说明文字
    private lazy var descLabel: UILabel = {
        let label = UILabel(
            text: "对订单有疑问？快打电话咨询助教老师吧！",
            font: UIFont(name: "STHeitiSC-Light", size: 13),
            textColor: MalaColor_939393_0
        )
        label.numberOfLines = 0
        return label
    }()
    /// 助教头像
    private lazy var assistantAvatar: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 36, height: 36),
            cornerRadius: 18,
            image: "avatar_placeholder"
        )
        return imageView
    }()
    /// 头像框
    private lazy var phoneLayer: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 57, height: 57),
            image: "live_phone"
        )
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
        content.addSubview(assistantAvatar)
        content.addSubview(phoneLayer)
        
        // Autolayout
        assistantNameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(content)
            maker.left.equalTo(content)
            maker.height.equalTo(15)
        }
        descLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(assistantNameLabel.snp.bottom).offset(6)
            maker.left.equalTo(assistantNameLabel)
            maker.right.equalTo(phoneLayer.snp.left).offset(-18)
            maker.bottom.equalTo(content)
        }
        phoneLayer.snp.makeConstraints { (maker) in
            maker.right.equalTo(content)
            maker.centerY.equalTo(content)
            maker.height.equalTo(57)
            maker.width.equalTo(57)
        }
        assistantAvatar.snp.makeConstraints { (maker) in
            maker.center.equalTo(phoneLayer)
            maker.height.equalTo(36)
            maker.width.equalTo(36)
        }
    }
    
    
    // MARK: - Events Response
    @objc private func phoneDidTap() {
        NotificationCenter.default.post(name: MalaNotification_MakePhoneCall, object: model?.assistantPhone)
    }
}
