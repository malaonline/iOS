//
//  TeacherTableViewCell.swift
//  mala-ios
//
//  Created by Elors on 1/14/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class TeacherTableViewCell: UITableViewCell {

    // MARK: - Property
    /// 老师简介模型
    var model: TeacherModel? {
        didSet{
            guard let model = model else { return }
            
            courseLabel.setTitle((model.grades_shortname ?? "")+" • "+(model.subject ?? ""), for: UIControlState())
            nameLabel.text = model.name
            levelLabel.text = String(format: "  T%d  ", model.level)
            avatarView.setImage(withURL: model.avatar)
            
            let string = String(MinPrice: model.min_price.money, MaxPrice: model.max_price.money)
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: string)
            let rangeLocation = (string as NSString).range(of: "元").location
            attrString.addAttribute(
                NSForegroundColorAttributeName,
                value: UIColor(named: .ThemeBlue),
                range: NSMakeRange(0, rangeLocation)
            )
            attrString.addAttribute(
                NSFontAttributeName,
                value: UIFont.systemFont(ofSize: 14),
                range: NSMakeRange(0, rangeLocation)
            )
            attrString.addAttribute(
                NSForegroundColorAttributeName,
                value: UIColor(named: .ArticleSubTitle),
                range: NSMakeRange(rangeLocation, 4)
            )
            attrString.addAttribute(
                NSFontAttributeName,
                value: UIFont.systemFont(ofSize: 12),
                range: NSMakeRange(rangeLocation, 4)
            )
            priceLabel.attributedText = attrString
            
            tagsLabel.text = model.tags?.joined(separator: "｜")
        }
    }
    
    
    // MARK: - Components
    /// 布局视图（卡片式Cell白色背景）
    private lazy var content: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// 授课年级及科目label
    private lazy var courseLabel: UIButton = {
        let courseLabel = UIButton()
        courseLabel.setBackgroundImage(UIImage(asset: .tagsTitle), for: UIControlState())
        courseLabel.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        courseLabel.titleEdgeInsets = UIEdgeInsets(top: -1, left: 0, bottom: 1, right: 0)
        courseLabel.isUserInteractionEnabled = false
        return courseLabel
    }()
    /// 老师姓名label
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = FontFamily.HelveticaNeue.Thin.font(17)
        nameLabel.textColor = UIColor(named: .ArticleTitle)
        return nameLabel
    }()
    /// 老师级别label
    private lazy var levelLabel: UILabel = {
        let levelLabel = UILabel()
        levelLabel.font = FontFamily.HelveticaNeue.Thin.font(13)
        levelLabel.backgroundColor = UIColor.white
        levelLabel.textColor = UIColor(named: .ThemeRed)
        return levelLabel
    }()
    /// 级别所在分割线
    private lazy var separator: UIView = {
        let separator = UIView(UIColor(named: .SeparatorLine))
        return separator
    }()
    /// 老师头像ImageView
    private lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.frame = CGRect(x: 0, y: 0, width: MalaLayout_AvatarSize, height: MalaLayout_AvatarSize)
        avatarView.layer.cornerRadius = MalaLayout_AvatarSize * 0.5
        avatarView.layer.masksToBounds = true
        avatarView.image = UIImage(asset: .avatarPlaceholder)
        avatarView.contentMode = .scaleAspectFill
        return avatarView
    }()
    /// 授课价格label
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = UIColor(named: .ArticleSubTitle)
        return priceLabel
    }()
    /// 风格标签label
    private lazy var tagsLabel: UILabel = {
        let tagsLabel = UILabel()
        tagsLabel.font = FontFamily.HelveticaNeue.Thin.font(11)
        tagsLabel.textColor = UIColor(named: .CardTag)
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
        contentView.backgroundColor = UIColor(named: .loginLightBlue)
        selectionStyle = .none
        
        // SubViews
        contentView.addSubview(content)
        contentView.addSubview(courseLabel)
        content.addSubview(nameLabel)
        content.addSubview(levelLabel)
        content.insertSubview(separator, belowSubview: levelLabel)
        content.addSubview(avatarView)
        content.addSubview(priceLabel)
        content.addSubview(tagsLabel)
        
        // Autolayout
        content.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView).offset(4)
            maker.left.equalTo(contentView).offset(12)
            maker.bottom.equalTo(contentView).offset(-4)
            maker.right.equalTo(contentView).offset(-12)
        }
        courseLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView).offset(4)
            maker.left.equalTo(contentView)
            maker.height.equalTo(24)
            maker.width.equalTo(100)
        }
        nameLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(content).offset(15)
            maker.centerX.equalTo(content)
            maker.height.equalTo(17)
        }
        levelLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(nameLabel.snp.bottom).offset(10)
            maker.centerX.equalTo(content)
            maker.height.equalTo(13)
        }
        separator.snp.makeConstraints { (maker) -> Void in
            maker.centerX.equalTo(content)
            maker.centerY.equalTo(levelLabel)
            maker.left.equalTo(content).offset(10)
            maker.right.equalTo(content).offset(-10)
            maker.height.equalTo(MalaScreenOnePixel)
        }
        avatarView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(levelLabel.snp.bottom).offset(12)
            maker.centerX.equalTo(content)
            maker.width.equalTo(MalaLayout_AvatarSize)
            maker.height.equalTo(MalaLayout_AvatarSize)
        }
        priceLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(avatarView.snp.bottom).offset(11)
            maker.centerX.equalTo(content)
            maker.height.equalTo(14)
        }
        tagsLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(priceLabel.snp.bottom).offset(12)
            maker.centerX.equalTo(content)
            maker.height.equalTo(11)
            maker.bottom.equalTo(content).offset(-15)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = UIImage(asset: .avatarPlaceholder)
    }
}
