//
//  LiveCourseAvatarView.swift
//  mala-ios
//
//  Created by 王新宇 on 2016/10/31.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LiveCourseAvatarView: UIImageView {

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
    /// 主讲老师头像
    private lazy var lecturerAvatar: UIImageView = {
        let imageView = UIImageView(cornerRadius: 30/2, image: "avatar_placeholder")
        return imageView
    }()
    /// 助教老师头像
    private lazy var assistantAvatar: UIImageView = {
        let imageView = UIImageView(cornerRadius: 30/2, image: "avatar_placeholder")
        return imageView
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
        image = UIImage(asset: .liveAvatarBackground)
        
        // SubViews
        addSubview(lecturerAvatar)
        addSubview(assistantAvatar)
        
        // AutoLayout
        self.snp.makeConstraints { (maker) in
            maker.width.equalTo(72)
            maker.height.equalTo(45)
        }
        lecturerAvatar.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp.top).offset(22.5)
            maker.centerX.equalTo(self.snp.left).offset(22.5)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
        }
        assistantAvatar.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp.top).offset(22.5)
            maker.centerX.equalTo(self.snp.right).offset(-22.5)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
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
