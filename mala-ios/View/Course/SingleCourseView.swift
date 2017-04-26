//
//  SingleCourseView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/6/15.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class SingleCourseView: UIView {
    
    // MARK: - Property
    /// 单次课程数据模型
    var model: StudentCourseModel? {
        didSet {
            DispatchQueue.main.async {
                self.changeDisplayMode()
                self.setupCourseInfo()
            }
        }
    }
    
    
    // MARK: - Components
    /// 信息背景视图
    private lazy var headerBackground: UIView = {
        let view = UIView(UIColor(named: .Disabled))
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    /// 学科年级信息标签
    private lazy var subjectLabel: UILabel = {
        let label = UILabel(
            text: "学科",
            fontSize: 14,
            textColor: UIColor(named: .WhiteTranslucent9)
        )
        return label
    }()
    /// 直播课程图标
    private lazy var liveCourseIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_courseIcon")
        return imageView
    }()
    /// 老师姓名图标
    private lazy var teacherIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_teacher")
        return imageView
    }()
    /// 老师姓名标签
    private lazy var teacherLabel: UILabel = {
        let label = UILabel(
            text: "老师姓名",
            fontSize: 14,
            textColor: UIColor(named: .ArticleSubTitle)
        )
        return label
    }()
    /// 助教老师姓名
    private lazy var assistantLabel: UILabel = {
        let label = UILabel(
            text: "助教老师姓名",
            fontSize: 13,
            textColor: UIColor(named: .HeaderTitle)
        )
        return label
    }()
    /// 上课时间图标
    private lazy var timeSlotIcon: UIImageView = {
        let imageView = UIImageView(imageName: "comment_time")
        return imageView
    }()
    /// 上课时间信息
    private lazy var timeSlotLabel: UILabel = {
        let label = UILabel(
            text: "上课时间",
            fontSize: 13,
            textColor: UIColor(named: .ArticleSubTitle)
        )
        return label
    }()
    /// 上课地点图标
    private lazy var schoolIcon: UIImageView = {
        let imageView = UIImageView(imageName: "comment_location")
        return imageView
    }()
    /// 上课地点
    private lazy var schoolLabel: UILabel = {
        let label = UILabel(
            text: "上课地点",
            fontSize: 13,
            textColor: UIColor(named: .ArticleSubTitle)
        )
        label.numberOfLines = 0
        return label
    }()
    /// 评论按钮
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        button.isHidden = true
        return button
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    private func setupUserInterface() {
        backgroundColor = UIColor.white 
        // SubView
        addSubview(headerBackground)
        headerBackground.addSubview(subjectLabel)
        headerBackground.addSubview(liveCourseIcon)
        
        addSubview(teacherIcon)
        addSubview(teacherLabel)
        addSubview(assistantLabel)
        addSubview(timeSlotIcon)
        addSubview(timeSlotLabel)
        addSubview(schoolIcon)
        addSubview(schoolLabel)
        addSubview(commentButton)
        
        // AutoLayout
        headerBackground.snp.makeConstraints { (maker) in
            maker.top.equalTo(self)
            maker.height.equalTo(32)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
        }
        subjectLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(14)
            maker.left.equalTo(headerBackground).offset(10)
            maker.centerY.equalTo(headerBackground)
        }
        liveCourseIcon.snp.makeConstraints { (maker) in
            maker.height.equalTo(21)
            maker.right.equalTo(headerBackground).offset(-10)
            maker.centerY.equalTo(headerBackground)
        }
        teacherIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerBackground.snp.bottom).offset(10)
            maker.left.equalTo(headerBackground)
            maker.width.equalTo(13)
            maker.height.equalTo(13)
        }
        teacherLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherIcon)
            maker.left.equalTo(teacherIcon.snp.right).offset(5)
            maker.height.equalTo(13)
        }
        assistantLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherIcon)
            maker.left.equalTo(teacherLabel.snp.right).offset(27.5)
            maker.height.equalTo(13)
        }
        timeSlotIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherIcon.snp.bottom).offset(10)
            maker.left.equalTo(headerBackground)
            maker.width.equalTo(13)
            maker.height.equalTo(13)
        }
        timeSlotLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(timeSlotIcon)
            maker.left.equalTo(timeSlotIcon.snp.right).offset(5)
            maker.height.equalTo(13)
        }
        schoolIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(timeSlotIcon.snp.bottom).offset(10)
            maker.left.equalTo(headerBackground)
            maker.width.equalTo(13)
            maker.height.equalTo(15)
        }
        schoolLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(schoolIcon)
            maker.left.equalTo(schoolIcon.snp.right).offset(5)
            maker.right.equalTo(self)
            maker.bottom.equalTo(self).offset(-20)
        }
        commentButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherLabel)
            maker.right.equalTo(headerBackground)
            maker.height.equalTo(24)
        }
    }
    
    ///  加载课程数据
    private func setupCourseInfo() {
        
        guard let course = model else { return }
        
        // 课程类型
        if course.isLiveCourse == true {
            liveCourseIcon.isHidden = false
            assistantLabel.isHidden = false
            teacherLabel.text = course.lecturer?.name
            assistantLabel.text = String(format: "助教：%@", course.teacher?.name ?? "")
        }else {
            liveCourseIcon.isHidden = true
            assistantLabel.isHidden = true
            teacherLabel.text = course.teacher?.name
        }
        
        // 课程信息
        subjectLabel.text = String(format: "%@%@", course.grade, course.subject)
        timeSlotLabel.text = String(format: "%@-%@", getDateString(course.start, format: "HH:mm"), getDateString(course.end, format: "HH:mm"))
        schoolLabel.attributedText = model?.attrAddressString
        
        // 课程状态
        switch course.status {
        case .Past:
            headerBackground.backgroundColor = UIColor(named: .Disabled)
            commentButton.isHidden = false
            break
            
        case .Today:
            headerBackground.backgroundColor = UIColor(named: .ThemeDeepBlue)
            commentButton.isHidden = true
            break
            
        case .Future:
            headerBackground.backgroundColor = UIColor(named: .ThemeDeepBlue)
            commentButton.isHidden = true
            break
        }
    }
    
    /// 根据当前课程评价状态，渲染对应UI样式
    private func changeDisplayMode() {
        // 课程评价状态
        if model?.comment != nil {
            setStyleCommented()
        }else if model?.isExpired == true {
            setStyleExpired()
        }else {
            setStyleNoComments()
        }
    }
    
    ///  设置过期样式
    private func setStyleExpired() {
        commentButton.layer.borderColor = UIColor(named: .HeaderTitle).cgColor
        commentButton.setTitle("评价已过期", for: .normal)
        commentButton.setTitleColor(UIColor(named: .HeaderTitle), for: .normal)
        commentButton.setBackgroundImage(UIImage.withColor(UIColor.white), for: .normal)
        commentButton.setBackgroundImage(UIImage.withColor(UIColor(named: .HeaderTitle)), for: .highlighted)
        commentButton.titleLabel?.font = FontFamily.PingFangSC.Regular.font(12)
        commentButton.isEnabled = false
    }
    
    ///  设置待评论样式
    private func setStyleNoComments() {
        commentButton.layer.borderColor = UIColor(named: .ThemeRed).cgColor
        commentButton.setTitle("去评价", for: .normal)
        commentButton.setTitleColor(UIColor(named: .ThemeRed), for: .normal)
        commentButton.setBackgroundImage(UIImage.withColor(UIColor.white), for: .normal)
        commentButton.setBackgroundImage(UIImage.withColor(UIColor(named: .ThemeRedHighlight)), for: .highlighted)
        commentButton.titleLabel?.font = FontFamily.PingFangSC.Regular.font(12)
        commentButton.addTarget(self, action: #selector(SingleCourseView.toComment), for: .touchUpInside)
    }
    
    ///  设置已评论样式
    private func setStyleCommented() {
        commentButton.layer.borderColor = UIColor(named: .commentBlue).cgColor
        commentButton.setTitle("查看评价", for: .normal)
        commentButton.setTitleColor(UIColor(named: .commentBlue), for: .normal)
        commentButton.setBackgroundImage(UIImage.withColor(UIColor.white), for: .normal)
        commentButton.setBackgroundImage(UIImage.withColor(UIColor(named: .CommitHighlightBlue)), for: .highlighted)
        commentButton.titleLabel?.font = FontFamily.PingFangSC.Regular.font(12)
        commentButton.addTarget(self, action: #selector(SingleCourseView.showComment), for: .touchUpInside)
    }
    
    
    // MARK: - Event Response
    ///  去评价
    @objc private func toComment() {
        let commentWindow = CommentViewWindow(contentView: UIView())
        
        commentWindow.finishedAction = { [weak self] in
            self?.commentButton.removeTarget(self, action: #selector(SingleCourseView.toComment), for: .touchUpInside)
            self?.setStyleCommented()
        }
        
        commentWindow.model = self.model ?? StudentCourseModel()
        commentWindow.isJustShow = false
        commentWindow.show()
    }
    
    ///  查看评价
    @objc private func showComment() {
        let commentWindow = CommentViewWindow(contentView: UIView())
        commentWindow.model = self.model ?? StudentCourseModel()
        commentWindow.isJustShow = true
        commentWindow.show()
    }
}
