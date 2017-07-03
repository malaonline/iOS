//
//  LiveCourseAvatarView.swift
//  mala-ios
//
//  Created by 王新宇 on 2016/10/31.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LiveCourseAvatarView: UIView {

    // MARK: - Property
    /// 主讲老师头像URL
    var lecturerAvatarURL: String? {
        didSet {
            lecturerAvatar.setImage(withURL: lecturerAvatarURL)
        }
    }
    /// 助教老师头像URL
    var assistantAvatarURL: String? {
        didSet {
            assistantAvatar.setImage(withURL: assistantAvatarURL)
        }
    }
    
    
    // MARK: - Components
    /// lecturer-avatar
    private lazy var lecturerAvatar: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 54, height: 54),
            cornerRadius: 27,
            image: "avatar_placeholder"
        )
        return imageView
    }()
    /// lecturer-avatar background
    private lazy var lecturerAvatarBackground: UIView = {
        let view = UIView(UIColor(named: .LiveAvatarBack), cornerRadius: 29)
        return view
    }()
    /// assistant-avatar
    private lazy var assistantAvatar: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 33, height: 33),
            cornerRadius: 16.5,
            image: "avatar_placeholder"
        )
        return imageView
    }()
    /// assistant-avatar background
    private lazy var assistantAvatarBackground: UIView = {
        let view = UIView(UIColor(named: .LiveAvatarBack), cornerRadius: 17.5)
        return view
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)) {
        super.init(frame: frame)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setupUserInterface() {
        // Style
        backgroundColor = UIColor.white
        
        // SubViews
        addSubview(lecturerAvatar)
        insertSubview(lecturerAvatarBackground, belowSubview: lecturerAvatar)
        addSubview(assistantAvatar)
        insertSubview(assistantAvatarBackground, belowSubview: assistantAvatar)
        
        // AutoLayout
        self.snp.makeConstraints { (maker) in
            maker.width.equalTo(87)
            maker.height.equalTo(58)
        }
        lecturerAvatarBackground.snp.makeConstraints { (maker) in
            maker.left.equalTo(self)
            maker.centerY.equalTo(self)
            maker.width.equalTo(58)
            maker.height.equalTo(58)
        }
        lecturerAvatar.snp.makeConstraints { (maker) in
            maker.center.equalTo(lecturerAvatarBackground)
            maker.width.equalTo(54)
            maker.height.equalTo(54)
        }
        assistantAvatarBackground.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(lecturerAvatarBackground)
            maker.right.equalTo(self)
            maker.width.equalTo(35)
            maker.height.equalTo(35)
        }
        assistantAvatar.snp.makeConstraints { (maker) in
            maker.center.equalTo(assistantAvatarBackground)
            maker.width.equalTo(33)
            maker.height.equalTo(33)
        }
    }
    
    
    // MARK: - API
    /// 同时设置主讲和助教老师的头像
    ///
    /// - parameter lecturer:  主讲老师头像URL
    /// - parameter assistant: 助教老师头像URL
    public func setAvatar(lecturer: String? = nil, assistant: String? = nil) {
        lecturerAvatarURL = lecturer
        assistantAvatarURL = assistant
    }
}
