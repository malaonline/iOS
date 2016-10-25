//
//  ProfileViewHeaderView.swift
//  mala-ios
//
//  Created by 王新宇 on 3/10/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

protocol ProfileViewHeaderViewDelegate: NSObjectProtocol {
    func avatarViewDidTap(_ sender: UIImageView)
    func nameEditButtonDidTap(_ sender: UIButton)
}

class ProfileViewHeaderView: UIView {

    // MARK: - Property
    /// 学生姓名
    var name: String = "学生姓名" {
        didSet {
            nameLabel.text = name
        }
    }
    /// 用户头像URL
    var avatarURL: String = "" {
        didSet {
            avatarView.setImage(withURL: avatarURL, placeholderImage: "profileAvatar_placeholder")
        }
    }
    /// 用户头像
    var avatar: UIImage = UIImage(named: "profileAvatar_placeholder") ?? UIImage() {
        didSet {
            avatarView.image = avatar
        }
    }
    /// 头像刷新指示器
    var refreshAvatar: Bool = false {
        didSet {
            refreshAvatar ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
    weak var delegate: ProfileViewHeaderViewDelegate?
    
    
    // MARK: - Components
    /// 头像ImageView控件
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView(imageName: "avatar_placeholder")
        imageView.layer.cornerRadius = (MalaLayout_AvatarSize-5)*0.5
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewHeaderView.avatarViewDidTap(_:))))
        return imageView
    }()
    /// 头像背景
    private lazy var avatarBackground: UIView = {
        let view = UIView(UIColor.white)
        view.layer.cornerRadius = MalaLayout_AvatarSize*0.5
        view.layer.masksToBounds = true
        return view
    }()
    /// 姓名label控件
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = MalaColor_82B4D9_0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewHeaderView.nameEditButtonDidTap(_:))))
        return label
    }()
    /// 姓名修改按钮
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "edit_icon"), for: UIControlState())
        button.addTarget(self, action: #selector(ProfileViewHeaderView.nameEditButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    /// 头像刷新指示器
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
        setupNotification()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Private
    private func setupUserInterface() {
        // Style
        backgroundColor = UIColor.clear
        self.avatarURL = MalaUserDefaults.avatar.value ?? ""
        
        // SubViews
        addSubview(avatarBackground)
        addSubview(avatarView)
        addSubview(nameLabel)
        addSubview(editButton)
        avatarView.addSubview(activityIndicator)
        
        // Autolayout
        avatarBackground.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(16)
            maker.centerX.equalTo(self)
            maker.width.equalTo(MalaLayout_AvatarSize)
            maker.height.equalTo(MalaLayout_AvatarSize)
        }
        avatarView.snp.makeConstraints({ (maker) -> Void in
            maker.center.equalTo(avatarBackground)
            maker.size.equalTo(avatarBackground).offset(-5)
        })
        nameLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(avatarView.snp.bottom).offset(10)
            maker.centerX.equalTo(avatarView)
            maker.height.equalTo(14)
        }
        editButton.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(nameLabel)
            maker.left.equalTo(nameLabel.snp.right).offset(3)
            maker.width.equalTo(9)
            maker.height.equalTo(13)
        }
        activityIndicator.snp.makeConstraints { (maker) -> Void in
            maker.center.equalTo(avatarView)
        }
    }
    
    private func setupNotification() {
        // 刷新学生姓名
        NotificationCenter.default.addObserver(
            forName: MalaNotification_RefreshStudentName,
            object: nil,
            queue: nil) { [weak self] (notification) -> Void in
                self?.nameLabel.text = MalaUserDefaults.studentName.value
        }
    }
    
    
    // MARK: - Event Response
    @objc private func avatarViewDidTap(_ sender: UIImageView) {
        self.delegate?.avatarViewDidTap(sender)
    }
    
    @objc private func nameEditButtonDidTap(_ sender: UIButton) {
        self.delegate?.nameEditButtonDidTap(sender)
    }
    
    // MARK: - Public Method
    ///  使用UserDefaults中的头像URL刷新头像
    func refreshDataWithUserDefaults() {
        avatarURL = MalaUserDefaults.avatar.value ?? ""
        name = MalaUserDefaults.studentName.value ?? ""
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: MalaNotification_RefreshStudentName, object: nil)
    }
}
