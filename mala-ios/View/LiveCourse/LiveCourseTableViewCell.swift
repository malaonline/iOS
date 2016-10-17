//
//  LiveCourseTableViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LiveCourseTableViewCell: UITableViewCell {
    
    // MARK: - Property
    /// 老师简介模型
    var model: TeacherModel? {
        didSet{
            
            guard let model = model else {
                return
            }
            
           
        }
    }
    
    
    // MARK: - Components
    /// 布局视图
    private lazy var content: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    /// 教师信息布局视图
    private lazy var teacherContent: UIView = {
        let view = UIView()
        return view
    }()
    /// 课程信息布局视图
    private lazy var infoContent: UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    /// 老师姓名label
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 17)
        nameLabel.textColor = MalaColor_4A4A4A_0
        return nameLabel
    }()
    /// 老师级别label
    private lazy var levelLabel: UILabel = {
        let levelLabel = UILabel()
        levelLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 13)
        levelLabel.backgroundColor = UIColor.white
        levelLabel.textColor = MalaColor_E26254_0
        return levelLabel
    }()
    /// 级别所在分割线
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = MalaColor_DADADA_0
        return separator
    }()
    /// 老师头像ImageView
    private lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.frame = CGRect(x: 0, y: 0, width: MalaLayout_AvatarSize, height: MalaLayout_AvatarSize)
        avatarView.layer.cornerRadius = MalaLayout_AvatarSize * 0.5
        avatarView.layer.masksToBounds = true
        avatarView.image = UIImage(named: "avatar_placeholder")
        avatarView.contentMode = .scaleAspectFill
        return avatarView
    }()
    /// 授课价格label
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = MalaColor_6C6C6C_0
        return priceLabel
    }()
    /// 风格标签label
    private lazy var tagsLabel: UILabel = {
        let tagsLabel = UILabel()
        tagsLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 11)
        tagsLabel.textColor = MalaColor_333333_6
        return tagsLabel
    }()
    
    
    // MARK: - Constructed
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        contentView.backgroundColor = MalaColor_EDEDED_0
        selectionStyle = .none
        
        // SubViews
        contentView.addSubview(content)
        content.addSubview(nameLabel)
        content.addSubview(levelLabel)
        content.insertSubview(separator, belowSubview: levelLabel)
        content.addSubview(avatarView)
        content.addSubview(priceLabel)
        content.addSubview(tagsLabel)
        
        // Autolayout
        content.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.contentView.snp.top).offset(4)
            maker.left.equalTo(self.contentView.snp.left).offset(12)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-4)
            maker.right.equalTo(self.contentView.snp.right).offset(-12)
        }
        nameLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.content.snp.top).offset(15)
            maker.centerX.equalTo(self.content.snp.centerX)
            maker.height.equalTo(17)
        }
        levelLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            maker.centerX.equalTo(self.content.snp.centerX)
            maker.height.equalTo(13)
        }
        separator.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(self.content.snp.centerX)
            maker.centerY.equalTo(self.levelLabel.snp.centerY)
            maker.left.equalTo(self.content.snp.left).offset(10)
            maker.right.equalTo(self.content.snp.right).offset(-10)
            maker.height.equalTo(MalaScreenOnePixel)
        }
        avatarView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.levelLabel.snp.bottom).offset(12)
            maker.centerX.equalTo(self.content.snp.centerX)
            maker.width.equalTo(MalaLayout_AvatarSize)
            maker.height.equalTo(MalaLayout_AvatarSize)
        }
        priceLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.avatarView.snp.bottom).offset(11)
            maker.centerX.equalTo(self.content.snp.centerX)
            maker.height.equalTo(14)
        }
        tagsLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.priceLabel.snp.bottom).offset(12)
            maker.centerX.equalTo(self.content.snp.centerX)
            maker.height.equalTo(11)
            maker.bottom.equalTo(self.content.snp.bottom).offset(-15)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = UIImage(named: "avatar_placeholder")
    }
}
