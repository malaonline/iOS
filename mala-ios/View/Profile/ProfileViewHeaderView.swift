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
    func loginButtonDidTap(_ sender: UIButton)
}

class ProfileViewHeaderView: UIView {

    // MARK: - Property
    /// 学生姓名
    var name: String = L10n.studentName {
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
    var avatar: UIImage = UIImage(asset: .profileAvatarPlaceholder) ?? UIImage() {
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
        let imageView = UIImageView(imageName: "profileAvatar_placeholder")
        imageView.layer.cornerRadius = (MalaLayout_AvatarSize-5)*0.5
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.addTapEvent(target: self, action: #selector(ProfileViewHeaderView.avatarViewDidTap(_:)))
        return imageView
    }()
    /// 头像背景
    private lazy var avatarBackground: UIView = {
        let view = UIView(UIColor(named: .profileAvatarBG))
        view.layer.cornerRadius = MalaLayout_AvatarSize*0.5
        view.layer.masksToBounds = true
        return view
    }()
    /// 姓名label控件
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = FontFamily.PingFangSC.Regular.font(16)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addTapEvent(target: self, action: #selector(ProfileViewHeaderView.nameEditButtonDidTap(_:)))
        label.isHidden = !MalaUserDefaults.isLogined
        return label
    }()
    /// 姓名修改按钮
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(asset: .editIcon), for: .normal)
        button.setBackgroundImage(UIImage(asset: .editIconPress), for: .highlighted)
        button.setBackgroundImage(UIImage(asset: .editIconPress), for: .disabled)
        button.addTarget(self, action: #selector(ProfileViewHeaderView.nameEditButtonDidTap(_:)), for: .touchUpInside)
        button.isHidden = !MalaUserDefaults.isLogined
        return button
    }()
    /// 登录按钮
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(asset: .profileLogin), for: .normal)
        button.addTarget(self, action: #selector(ProfileViewHeaderView.loginButtonDidTap(_:)), for: .touchUpInside)
        button.isHidden = MalaUserDefaults.isLogined
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
        avatarURL = MalaUserDefaults.avatar.value ?? ""
        
        // SubViews
        addSubview(avatarBackground)
        addSubview(avatarView)
        addSubview(nameLabel)
        addSubview(editButton)
        addSubview(loginButton)
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
        loginButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(avatarBackground.snp.bottom).offset(14)
            maker.centerX.equalTo(avatarView)
            maker.width.equalTo(108)
            maker.height.equalTo(32)
        }
        editButton.snp.makeConstraints { (maker) -> Void in
            maker.bottom.equalTo(nameLabel)
            maker.left.equalTo(nameLabel.snp.right).offset(3)
            maker.width.equalTo(18)
            maker.height.equalTo(18)
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
    
    @objc private func loginButtonDidTap(_ sender: UIButton) {
        self.delegate?.loginButtonDidTap(sender)
    }
    
    
    // MARK: - Public Method
    ///  使用UserDefaults中的头像URL刷新头像
    func refreshDataWithUserDefaults() {
        nameLabel.isHidden = !MalaUserDefaults.isLogined
        editButton.isHidden = !MalaUserDefaults.isLogined
        loginButton.isHidden = MalaUserDefaults.isLogined
        
        if !MalaUserDefaults.isLogined {
            avatarView.setImage(withImageName: "profileAvatar_placeholder")
        }
        
        delay(3) { 
            if let url = MalaUserDefaults.avatar.value, MalaUserDefaults.isLogined {
                self.avatarURL = url
            }
            self.name = MalaUserDefaults.studentName.value ?? "学生姓名"
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: MalaNotification_RefreshStudentName, object: nil)
    }
}
