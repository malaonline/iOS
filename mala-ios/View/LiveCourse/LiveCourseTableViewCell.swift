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
            assistantNameLabel.text = String(format: "助教 %@", (model.assistantName ?? 0))
            lecturerTitleLabel.text = model.lecturerTitle
            
            courseName.text = model.courseName
            gradeLabel.text = (model.courseGrade ?? "")+"  "
            courseDateLabel.text = String(format: "%@-%@", getDateString(model.courseStart, format: "MM月dd日"), getDateString(model.courseEnd, format: "MM月dd日"))
            priceLabel.text = String(format: "%@/", model.courseFee?.liveCoursePrice ?? "")
            lessionsLabel.text = String(format: "%d次", model.courseLessons ?? 0)
            
            subjectLabel.text = model.subjectString?.subStringToIndex(1)
        }
    }
    
    
    // MARK: - Components
    /// card container
    private lazy var content: UIView = {
        let view = UIView(UIColor.white)
        view.addShadow(color: UIColor(named: .liveShadowBlue))
        return view
    }()
    /// teacher-info container
    private lazy var teacherContent: UIView = {
        let view = UIView(UIColor(named: .liveThemeBlue))
        view.clipsToBounds = true
        return view
    }()
    /// live-course title
    private lazy var courseName: UILabel = {
        let label = UILabel(
            text: "课程名称",
            font: FontFamily.PingFangSC.Regular.font(18),
            textColor: UIColor(named: .labelBlack)
        )
        return label
    }()
    /// course state
    private lazy var courseState: UIImageView = {
        let imageView = UIImageView(image: UIImage(asset: .preEnrollment))
        return imageView
    }()
    /// subject label
    private lazy var subjectLabel: UILabel = {
        let label = UILabel(
            text: "科",
            font: FontFamily.PingFangSC.Regular.font(12),
            textColor: UIColor(named: .liveMathGreen),
            textAlignment: .center,
            borderColor: UIColor(named: .liveMathGreen),
            borderWidth: 1.0,
            cornerRadius: 2
        )
        return label
    }()
    /// live-course type
    private lazy var classTypeLabel: UILabel = {
        let label = UILabel(
            text: "暑期班",
            font: FontFamily.PingFangSC.Regular.font(12),
            textColor: UIColor(named: .liveCourseTypeBlue),
            textAlignment: .center,
            borderColor: UIColor(named: .liveCourseTypeBlue),
            borderWidth: 1.0,
            cornerRadius: 2
        )
        return label
    }()
    /// lecturer-avatar
    private lazy var lecturerAvatar: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 82, height: 82),
            cornerRadius: 41,
            image: "avatar_placeholder"
        )
        return imageView
    }()
    /// lecturer-avatar background
    private lazy var lecturerAvatarBackground: UIView = {
        let view = UIView(UIColor(named: .LiveAvatarBack), cornerRadius: 44)
        return view
    }()
    /// assistant-avatar
    private lazy var assistantAvatar: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 50, height: 50),
            cornerRadius: 25,
            image: "avatar_placeholder"
        )
        return imageView
    }()
    /// assistant-avatar background
    private lazy var assistantAvatarBackground: UIView = {
        let view = UIView(UIColor(named: .LiveAvatarBack), cornerRadius: 28)
        return view
    }()
    /// lecturer-name
    private lazy var lecturerNameLabel: UILabel = {
        let label = UILabel(
            text: "主讲老师",
            font: FontFamily.PingFangSC.Regular.font(18),
            textColor: UIColor.white,
            textAlignment: .right
        )
        return label
    }()
    /// lecturer-intro
    private lazy var lecturerTitleLabel: UILabel = {
        let label = UILabel(
            text: "主讲老师主要成就",
            font: FontFamily.PingFangSC.Light.font(14),
            textColor: UIColor.white,
            textAlignment: .right,
            opacity: 0.8
        )
        label.numberOfLines = 0
        return label
    }()
    /// assistant-name
    private lazy var assistantNameLabel: UILabel = {
        let label = UILabel(
            text: "助教",
            font: FontFamily.PingFangSC.Light.font(14),
            textColor: UIColor.white
        )
        return label
    }()
    /// course-data label
    private lazy var courseDateLabel: UILabel = {
        let label = UILabel(
            text: "课程日期",
            font: FontFamily.PingFangSC.Regular.font(12),
            textColor: UIColor(named: .protocolGary)
        )
        return label
    }()
    /// grade
    private lazy var gradeLabel: UILabel = {
        let label = UILabel(
            text: "课程年级区间",
            font: FontFamily.PingFangSC.Regular.font(12),
            textColor: UIColor(named: .protocolGary)
        )
        return label
    }()
    /// price
    private lazy var priceLabel: UILabel = {
        let label = UILabel(
            text: "价格/",
            font: FontFamily.PingFangSC.Light.font(20),
            textColor: UIColor(named: .livePriceRed),
            textAlignment: .right
        )
        return label
    }()
    /// period
    private lazy var lessionsLabel: UILabel = {
        let label = UILabel(
            text: "次数",
            font: FontFamily.PingFangSC.Light.font(14),
            textColor: UIColor(named: .livePriceRed),
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
        content.addSubview(subjectLabel)
        content.addSubview(classTypeLabel)
        content.addSubview(courseName)
        content.addSubview(courseState)
        
        teacherContent.addSubview(lecturerAvatar)
        teacherContent.insertSubview(lecturerAvatarBackground, belowSubview: lecturerAvatar)
        teacherContent.addSubview(assistantAvatar)
        teacherContent.insertSubview(assistantAvatarBackground, belowSubview: assistantAvatar)
        teacherContent.addSubview(lecturerNameLabel)
        teacherContent.addSubview(lecturerTitleLabel)
        teacherContent.addSubview(assistantNameLabel)
        
        content.addSubview(courseDateLabel)
        content.addSubview(gradeLabel)
        content.addSubview(priceLabel)
        content.addSubview(lessionsLabel)
        
        // Autolayout
        content.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView).offset(4)
            maker.left.equalTo(contentView).offset(10)
            maker.bottom.equalTo(contentView).offset(-4)
            maker.right.equalTo(contentView).offset(-10)
        }
        teacherContent.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(45)
            maker.left.equalTo(content)
            maker.bottom.equalTo(content).offset(-38)
            maker.right.equalTo(content)
        }
        subjectLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(12)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(20)
            maker.width.equalTo(20)
        }
        classTypeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(12)
            maker.left.equalTo(subjectLabel.snp.right).offset(6)
            maker.height.equalTo(20)
            maker.width.equalTo(45)
        }
        courseName.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(classTypeLabel)
            maker.left.equalTo(classTypeLabel.snp.right).offset(8)
            maker.right.equalTo(courseState.snp.left).offset(-10)
            maker.height.equalTo(25)
        }
        courseState.snp.makeConstraints { (maker) in
            maker.height.equalTo(36)
            maker.width.equalTo(50)
            maker.right.equalTo(content).offset(-8)
            maker.top.equalTo(content).offset(-3)
        }
        lecturerAvatarBackground.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(content.snp.right).multipliedBy(0.48)
            maker.centerY.equalTo(content.snp.bottom).multipliedBy(0.48)
            maker.width.equalTo(88)
            maker.height.equalTo(88)
        }
        lecturerAvatar.snp.makeConstraints { (maker) in
            maker.center.equalTo(lecturerAvatarBackground)
            maker.width.equalTo(82)
            maker.height.equalTo(82)
        }
        assistantAvatarBackground.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(lecturerAvatarBackground)
            maker.left.equalTo(lecturerAvatarBackground.snp.right).offset(-6)
            maker.width.equalTo(56)
            maker.height.equalTo(56)
        }
        assistantAvatar.snp.makeConstraints { (maker) in
            maker.center.equalTo(assistantAvatarBackground)
            maker.width.equalTo(50)
            maker.height.equalTo(50)
        }
        lecturerNameLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(lecturerAvatarBackground.snp.left).offset(-6)
            maker.height.equalTo(25)
            maker.centerY.equalTo(lecturerAvatarBackground)
        }
        lecturerTitleLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(lecturerNameLabel)
            maker.left.equalTo(teacherContent).offset(22)
            maker.top.equalTo(lecturerNameLabel).offset(6)
            maker.bottom.equalTo(teacherContent)
        }
        assistantNameLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(20)
            maker.left.equalTo(assistantAvatarBackground.snp.right).offset(1)
            maker.right.equalTo(teacherContent).offset(-6)
            maker.top.equalTo(assistantAvatar.snp.centerY)
        }
        courseDateLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(17)
            maker.bottom.equalTo(content).offset(-10.5)
            maker.left.equalTo(content).offset(11)
        }
        gradeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(courseDateLabel.snp.right).offset(10)
            maker.right.equalTo(priceLabel.snp.left).offset(-10)
            maker.height.equalTo(17)
            maker.bottom.equalTo(content).offset(-10.5)
        }
        lessionsLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(content).offset(-12)
            maker.bottom.equalTo(content).offset(-12)
            maker.height.equalTo(14)
        }
        priceLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(lessionsLabel.snp.left)
            maker.centerY.equalTo(lessionsLabel)
            maker.height.equalTo(20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lecturerAvatar.image = UIImage(asset: .avatarPlaceholder)
    }
}
