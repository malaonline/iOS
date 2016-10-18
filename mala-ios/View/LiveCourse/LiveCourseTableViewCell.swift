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
    var model: LiveCourseModel? {
        didSet{
            
            let model = LiveCourseModel(
                teacherAvatar: "http://s3.cn-north-1.amazonaws.com.cn/dev-upload/avatars/avatar21_161101?X-Amz-Expires=86400&X-Amz-Signature=517143d11c51518bba37c9f71c4b9f59327daf9c8b9ed9afe183127e14a49412&X-Amz-SignedHeaders=host&X-Amz-Date=20161018T040232Z&X-Amz-Credential=AKIAOSV3WMTYCF7T4LTA/20161018/cn-north-1/s3/aws4_request&X-Amz-Algorithm=AWS4-HMAC-SHA256",
                assistantAvatar: "http://s3.cn-north-1.amazonaws.com.cn/dev-upload/avatars/avatar22_11290?X-Amz-Expires=86400&X-Amz-Signature=0e082c8967e8d8bac5be78d225ef5a104d5c9069dd0a2d21c2ac928e24ff10d3&X-Amz-SignedHeaders=host&X-Amz-Date=20161018T041156Z&X-Amz-Credential=AKIAOSV3WMTYCF7T4LTA/20161018/cn-north-1/s3/aws4_request&X-Amz-Algorithm=AWS4-HMAC-SHA256",
                teacherName: "何芳",
                assistantName: "刘孟军",
                teacherTitle: "著名外语节目主持人",
                courseName: "新概念英语初级周末上午班",
                courseGrade: "小学四－六年级",
                classLevel: 20
            )
            
            teacherAvatar.setImage(withURL: model.teacherAvatar, placeholderImage: "avatar_placeholder")
            assistantAvatar.setImage(withURL: model.assistantAvatar, placeholderImage: "avatar_placeholder")
            teacherNameLabel.text = model.teacherName
            assistantNameLabel.text = model.assistantName
            teacherTitleLabel.text = model.teacherTitle
            courseName.text = model.courseName
            gradeLabel.text = model.courseGrade
            classLevelLabel.text = String(format: "%d人小班", model.classLevel ?? 12)
        }
    }
    
    
    // MARK: - Components
    /// 卡片容器
    private lazy var content: UIView = {
        let view = UIView(UIColor.white)
        view.addShadow(color: MalaColor_D7D7D7_0)
        return view
    }()
    /// 教师信息布局容器
    private lazy var teacherContent: UIView = {
        let view = UIView(MalaColor_5FAEEA_0)
        view.clipsToBounds = true
        return view
    }()
    /// 课程信息布局容器
    private lazy var courseContent: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// 老师头像
    private lazy var teacherAvatar: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 60, height: 60),
            cornerRadius: 27,
            image: "avatar_placeholder"
        )
        return imageView
    }()
    /// 老师头像背景
    private lazy var teacherAvatarBackground: UIView = {
        let view = UIView(MalaColor_A8D0FF_0, cornerRadius: 30)
        return view
    }()
    /// 直播图标
    private lazy var liveIcon: UIImageView = {
        let imageView = UIImageView(image: "live_icon")
        return imageView
    }()
    /// 助教头像
    private lazy var assistantAvatar: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 48, height: 48),
            cornerRadius: 22,
            image: "avatar_placeholder"
        )
        return imageView
    }()
    /// 助教头像背景
    private lazy var assistantAvatarBackground: UIView = {
        let view = UIView(MalaColor_A8D0FF_0, cornerRadius: 24)
        return view
    }()
    /// 老师姓名
    private lazy var teacherNameLabel: UILabel = {
        let label = UILabel(
            text: "主讲老师",
            font: UIFont(name: "PingFang-SC-Regular", size: 15),
            textColor: UIColor.white
        )
        return label
    }()
    /// 老师title
    private lazy var teacherTitleLabel: UILabel = {
        let label = UILabel(
            text: "主讲老师主要成就",
            font: UIFont(name: "PingFang-SC-Light", size: 12),
            textColor: UIColor.white,
            opacity: 0.56
        )
        return label
    }()
    /// 助教姓名
    private lazy var assistantNameLabel: UILabel = {
        let label = UILabel(
            text: "助教",
            font: UIFont(name: "PingFang-SC-Light", size: 12),
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
    /// 班级级别标签
    private lazy var classLevelLabel: UILabel = {
        let label = UILabel(
            text: "班级规模",
            font: UIFont(name: "PingFang-SC-Light", size: 10),
            textColor: UIColor.white,
            textAlignment: .center,
            backgroundColor: MalaColor_7ED321_0
        )
        label.addShadow(color: MalaColor_3E8CC7_0)
        return label
    }()
    /// 课程名称
    private lazy var courseName: UILabel = {
        let label = UILabel(
            text: "课程名称",
            font: UIFont(name: "PingFang-SC-Light", size: 15),
            textColor: MalaColor_636363_0
        )
        return label
    }()
    /// 课程日期图标
    private lazy var dateIcon: UIImageView = {
        let imageView = UIImageView(image: "live_time")
        return imageView
    }()
    /// 课程日期
    private lazy var courseDateLabel: UILabel = {
        let label = UILabel(
            text: "课程日期",
            font: UIFont(name: "PingFang-SC-Light", size: 9),
            textColor: MalaColor_778CA4_0
        )
        return label
    }()
    /// 课程年级信息
    private lazy var gradeLabel: UILabel = {
        let label = UILabel(
            text: "课程年级区间",
            font: UIFont(name: "PingFang-SC-Light", size: 9),
            textColor: MalaColor_8DBEDE_0,
            textAlignment: .center,
            borderColor: MalaColor_8DBEDE_0,
            borderWidth: MalaScreenOnePixel,
            cornerRadius: 2
        )
        return label
    }()
    /// 价格标签
    private lazy var priceLabel: UILabel = {
        let label = UILabel(
            text: "价格/",
            font: UIFont(name: "PingFang-SC-Light", size: 18),
            textColor: MalaColor_E26254_0,
            textAlignment: .right
        )
        return label
    }()
    /// 课时数标签
    private lazy var periodLabel: UILabel = {
        let label = UILabel(
            text: "次数",
            font: UIFont(name: "PingFang-SC-Light", size: 12),
            textColor: MalaColor_E26254_0,
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
        contentView.backgroundColor = MalaColor_EDEDED_0
        selectionStyle = .none
        
        // SubViews
        contentView.addSubview(content)
        content.addSubview(teacherContent)
        content.addSubview(courseContent)
        teacherContent.addSubview(teacherAvatar)
        teacherContent.insertSubview(teacherAvatarBackground, belowSubview: teacherAvatar)
        teacherContent.addSubview(liveIcon)
        teacherContent.addSubview(assistantAvatar)
        teacherContent.insertSubview(assistantAvatarBackground, belowSubview: assistantAvatar)
        teacherContent.addSubview(teacherNameLabel)
        teacherContent.addSubview(assistantNameLabel)
        teacherContent.addSubview(teacherTitleLabel)
        teacherContent.addSubview(avatarLine1)
        teacherContent.addSubview(avatarLine2)
        teacherContent.addSubview(classLevelLabel)
        courseContent.addSubview(courseName)
        courseContent.addSubview(dateIcon)
        courseContent.addSubview(courseDateLabel)
        courseContent.addSubview(gradeLabel)
        courseContent.addSubview(periodLabel)
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
        teacherAvatarBackground.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherContent).offset(12)
            maker.centerX.equalTo(teacherContent.snp.right).multipliedBy(0.25)
            maker.width.equalTo(60)
            maker.height.equalTo(60)
        }
        teacherAvatar.snp.makeConstraints { (maker) in
            maker.center.equalTo(teacherAvatarBackground)
            maker.width.equalTo(54)
            maker.height.equalTo(54)
        }
        liveIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherContent).offset(18)
            maker.right.equalTo(teacherAvatar).offset(10)
            maker.width.equalTo(24)
            maker.height.equalTo(14)
        }
        assistantAvatarBackground.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(teacherAvatar)
            maker.centerX.equalTo(teacherContent.snp.right).multipliedBy(0.75)
            maker.width.equalTo(48)
            maker.height.equalTo(48)
        }
        assistantAvatar.snp.makeConstraints { (maker) in
            maker.center.equalTo(assistantAvatarBackground)
            maker.width.equalTo(44)
            maker.height.equalTo(44)
        }
        teacherNameLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(teacherAvatar)
            maker.top.equalTo(teacherAvatar.snp.bottom).offset(5)
            maker.height.equalTo(15)
            maker.bottom.equalTo(teacherTitleLabel.snp.top).offset(-6)
        }
        assistantNameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(assistantAvatar.snp.bottom).offset(5)
            maker.centerX.equalTo(assistantAvatar)
            maker.height.equalTo(12)
        }
        teacherTitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherNameLabel.snp.bottom).offset(6)
            maker.centerX.equalTo(teacherNameLabel)
            maker.height.equalTo(12)
            maker.bottom.equalTo(teacherContent).offset(-12)
        }
        avatarLine1.snp.makeConstraints { (maker) in
            maker.height.equalTo(MalaScreenOnePixel)
            maker.width.equalTo(teacherContent).multipliedBy(0.168)
            maker.centerX.equalTo(teacherContent).offset(-20)
            maker.centerY.equalTo(teacherAvatar).offset(-5)
        }
        avatarLine2.snp.makeConstraints { (maker) in
            maker.height.equalTo(MalaScreenOnePixel)
            maker.width.equalTo(teacherContent).multipliedBy(0.168)
            maker.centerX.equalTo(teacherContent).offset(20)
            maker.centerY.equalTo(teacherAvatar).offset(5)
        }
        classLevelLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(teacherContent).offset(15.6)
            maker.top.equalTo(teacherContent).offset(11)
            maker.height.equalTo(15)
            maker.width.equalTo(70)
        }
        classLevelLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
        courseName.snp.makeConstraints { (maker) in
            maker.top.equalTo(courseContent).offset(17)
            maker.left.equalTo(courseContent).offset(12)
            maker.height.equalTo(15)
            maker.bottom.equalTo(dateIcon.snp.top).offset(-12)
        }
        dateIcon.snp.makeConstraints { (maker) in
            maker.width.equalTo(9)
            maker.height.equalTo(9.5)
            maker.top.equalTo(courseName.snp.bottom).offset(12)
            maker.left.equalTo(courseContent).offset(12)
            maker.bottom.equalTo(courseContent).offset(-18)
        }
        courseDateLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(dateIcon)
            maker.left.equalTo(dateIcon.snp.right).offset(4)
            maker.height.equalTo(9)
        }
        gradeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(courseContent).offset(15)
            maker.right.equalTo(courseContent).offset(-12)
            maker.width.equalTo(75)
            maker.height.equalTo(courseName)
        }
        periodLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(gradeLabel)
            maker.bottom.equalTo(priceLabel)
            maker.height.equalTo(12)
        }
        priceLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(gradeLabel.snp.bottom).offset(12)
            maker.right.equalTo(periodLabel.snp.left)
            maker.bottom.equalTo(courseContent).offset(-12)
            maker.height.equalTo(18)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        teacherAvatar.image = UIImage(named: "avatar_placeholder")
    }
}
