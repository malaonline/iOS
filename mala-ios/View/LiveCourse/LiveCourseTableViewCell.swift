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
    var model: LiveClassModel? {
        didSet {
            guard let model = model else { return }
            
            lecturerAvatar.setImage(withURL: model.lecturerAvatar)
            assistantAvatar.setImage(withURL: model.assistantAvatar)
            lecturerNameLabel.text = model.lecturerName
            assistantNameLabel.text = String(format: "助教:%@", (model.assistantName ?? 0))
            lecturerTitleLabel.text = model.lecturerTitle
            
            courseName.text = model.courseName
            gradeLabel.text = (model.courseGrade ?? "")+"  "
            courseDateLabel.text = String(format: "%@-%@", getDateString(model.courseStart, format: "MM月dd日"), getDateString(model.courseEnd, format: "MM月dd日"))
            priceLabel.text = String(format: "%@/", model.courseFee?.liveCoursePrice ?? "")
            lessionsLabel.text = String(format: "%d次", model.courseLessons ?? 0)
        }
    }
    
    
    // MARK: - Components
    /// 卡片容器
    private lazy var content: UIView = {
        let view = UIView(UIColor.white)
        view.addShadow(color: UIColor(named: .ShadowGray))
        return view
    }()
    /// 教师信息布局容器
    private lazy var teacherContent: UIView = {
        let view = UIView(UIColor(named: .LiveClassCardBlue))
        view.clipsToBounds = true
        return view
    }()
    /// 课程信息布局容器
    private lazy var courseContent: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// 老师头像
    private lazy var lecturerAvatar: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 64, height: 64),
            cornerRadius: 32,
            image: "avatar_placeholder"
        )
        return imageView
    }()
    /// 老师头像背景
    private lazy var lecturerAvatarBackground: UIView = {
        let view = UIView(UIColor(named: .LiveAvatarBack), cornerRadius: 35)
        return view
    }()
    /// 直播图标
    private lazy var liveIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_icon")
        return imageView
    }()
    /// 助教头像
    private lazy var assistantAvatar: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 54, height: 54),
            cornerRadius: 27,
            image: "avatar_placeholder"
        )
        return imageView
    }()
    /// 助教头像背景
    private lazy var assistantAvatarBackground: UIView = {
        let view = UIView(UIColor(named: .LiveAvatarBack), cornerRadius: 29)
        return view
    }()
    /// 老师姓名
    private lazy var lecturerNameLabel: UILabel = {
        let label = UILabel(
            text: "主讲老师",
            font: FontFamily.PingFangSC.Regular.font(17),
            textColor: UIColor.white
        )
        return label
    }()
    /// 老师title
    private lazy var lecturerTitleLabel: UILabel = {
        let label = UILabel(
            text: "主讲老师主要成就",
            font: FontFamily.PingFangSC.Light.font(14),
            textColor: UIColor.white,
            opacity: 0.56
        )
        return label
    }()
    /// 助教姓名
    private lazy var assistantNameLabel: UILabel = {
        let label = UILabel(
            text: "助教",
            font: FontFamily.PingFangSC.Light.font(14),
            textColor: UIColor.white
        )
        return label
    }()
    private lazy var avatarLine1: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    private lazy var avatarLine2: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// 课程名称
    private lazy var courseName: UILabel = {
        let label = UILabel(
            text: "课程名称",
            font: FontFamily.PingFangSC.Light.font(17),
            textColor: UIColor(named: .ArticleText)
        )
        return label
    }()
    /// 课程日期图标
    private lazy var dateIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_time")
        return imageView
    }()
    /// 课程日期
    private lazy var courseDateLabel: UILabel = {
        let label = UILabel(
            text: "课程日期",
            font: FontFamily.PingFangSC.Light.font(12),
            textColor: UIColor(named: .ArticleSubTitle)
        )
        return label
    }()
    /// 课程年级信息
    private lazy var gradeLabel: UILabel = {
        let label = UILabel(
            text: "课程年级区间",
            font: FontFamily.PingFangSC.Light.font(12),
            textColor: UIColor(named: .OptionSelectColor),
            textAlignment: .center,
            borderColor: UIColor(named: .OptionSelectColor),
            borderWidth: MalaScreenOnePixel,
            cornerRadius: 2
        )
        return label
    }()
    /// 价格标签
    private lazy var priceLabel: UILabel = {
        let label = UILabel(
            text: "价格/",
            font: FontFamily.PingFangSC.Light.font(20),
            textColor: UIColor(named: .ThemeRed),
            textAlignment: .right
        )
        return label
    }()
    /// 课时数标签
    private lazy var lessionsLabel: UILabel = {
        let label = UILabel(
            text: "次数",
            font: FontFamily.PingFangSC.Light.font(14),
            textColor: UIColor(named: .ThemeRed),
            textAlignment: .right
        )
        return label
    }()
    
    
    
    // MARK: - Instace Method
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
        contentView.backgroundColor = UIColor(named: .themeLightBlue)
        selectionStyle = .none
        
        // SubViews
        contentView.addSubview(content)
        content.addSubview(teacherContent)
        content.addSubview(courseContent)
        teacherContent.addSubview(lecturerAvatar)
        teacherContent.insertSubview(lecturerAvatarBackground, belowSubview: lecturerAvatar)
        teacherContent.addSubview(liveIcon)
        teacherContent.addSubview(assistantAvatar)
        teacherContent.insertSubview(assistantAvatarBackground, belowSubview: assistantAvatar)
        teacherContent.addSubview(lecturerNameLabel)
        teacherContent.addSubview(assistantNameLabel)
        teacherContent.addSubview(lecturerTitleLabel)
        teacherContent.addSubview(avatarLine1)
        teacherContent.addSubview(avatarLine2)
        courseContent.addSubview(courseName)
        courseContent.addSubview(dateIcon)
        courseContent.addSubview(courseDateLabel)
        courseContent.addSubview(gradeLabel)
        courseContent.addSubview(lessionsLabel)
        courseContent.addSubview(priceLabel)
        
        // Autolayout
        content.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView).offset(4)
            maker.left.equalTo(contentView).offset(12)
            maker.bottom.equalTo(contentView).offset(-4)
            maker.right.equalTo(contentView).offset(-12)
        }
        teacherContent.snp.makeConstraints { (maker) in
            maker.top.equalTo(content)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
        }
        courseContent.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherContent.snp.bottom)
            maker.left.equalTo(content)
            maker.right.equalTo(content)
            maker.bottom.equalTo(content)
        }
        lecturerAvatarBackground.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherContent).offset(12)
            maker.centerX.equalTo(teacherContent.snp.right).multipliedBy(0.25)
            maker.width.equalTo(70)
            maker.height.equalTo(70)
        }
        lecturerAvatar.snp.makeConstraints { (maker) in
            maker.center.equalTo(lecturerAvatarBackground)
            maker.width.equalTo(64)
            maker.height.equalTo(64)
        }
        liveIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherContent).offset(18)
            maker.right.equalTo(lecturerAvatar).offset(10)
            maker.width.equalTo(24)
            maker.height.equalTo(18)
        }
        assistantAvatarBackground.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(lecturerAvatar)
            maker.centerX.equalTo(teacherContent.snp.right).multipliedBy(0.75)
            maker.width.equalTo(58)
            maker.height.equalTo(58)
        }
        assistantAvatar.snp.makeConstraints { (maker) in
            maker.center.equalTo(assistantAvatarBackground)
            maker.width.equalTo(54)
            maker.height.equalTo(54)
        }
        lecturerNameLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(lecturerAvatar)
            maker.top.equalTo(lecturerAvatar.snp.bottom).offset(8)
            maker.height.equalTo(17)
            maker.bottom.equalTo(lecturerTitleLabel.snp.top).offset(-6)
        }
        assistantNameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(assistantAvatar.snp.bottom).offset(8)
            maker.centerX.equalTo(assistantAvatar)
            maker.height.equalTo(14)
        }
        lecturerTitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(lecturerNameLabel.snp.bottom).offset(6)
            maker.centerX.equalTo(lecturerNameLabel)
            maker.height.equalTo(14)
            maker.bottom.equalTo(teacherContent).offset(-12)
        }
        avatarLine1.snp.makeConstraints { (maker) in
            maker.height.equalTo(MalaScreenOnePixel)
            maker.width.equalTo(teacherContent).multipliedBy(0.168)
            maker.centerX.equalTo(teacherContent).offset(-20)
            maker.centerY.equalTo(lecturerAvatar).offset(-5)
        }
        avatarLine2.snp.makeConstraints { (maker) in
            maker.height.equalTo(MalaScreenOnePixel)
            maker.width.equalTo(teacherContent).multipliedBy(0.168)
            maker.centerX.equalTo(teacherContent).offset(20)
            maker.centerY.equalTo(lecturerAvatar).offset(5)
        }
        courseName.snp.makeConstraints { (maker) in
            maker.top.equalTo(courseContent).offset(17)
            maker.left.equalTo(courseContent).offset(12)
            maker.height.equalTo(17)
            maker.bottom.equalTo(dateIcon.snp.top).offset(-12)
        }
        dateIcon.snp.makeConstraints { (maker) in
            maker.width.equalTo(10)
            maker.height.equalTo(10)
            maker.top.equalTo(courseName.snp.bottom).offset(12)
            maker.left.equalTo(courseContent).offset(12)
            maker.bottom.equalTo(courseContent).offset(-18)
        }
        courseDateLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(dateIcon).offset(MalaScreenOnePixel)
            maker.left.equalTo(dateIcon.snp.right).offset(4)
            maker.height.equalTo(13)
        }
        gradeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(courseContent).offset(15)
            maker.right.equalTo(courseContent).offset(-12)
            maker.height.equalTo(courseName)
        }
        lessionsLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(gradeLabel)
            maker.bottom.equalTo(priceLabel)
            maker.height.equalTo(14)
        }
        priceLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(gradeLabel.snp.bottom).offset(12)
            maker.right.equalTo(lessionsLabel.snp.left)
            maker.bottom.equalTo(courseContent).offset(-12)
            maker.height.equalTo(20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lecturerAvatar.image = UIImage(asset: .avatarPlaceholder)
    }
}
