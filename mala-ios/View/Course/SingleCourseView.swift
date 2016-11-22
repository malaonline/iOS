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
            DispatchQueue.main.async { [weak self] in
                self?.setupCourseInfo()
            }
        }
    }
    
    
    // MARK: - Components
    /// 信息背景视图
    private lazy var headerBackground: UIView = {
        let view = UIView(MalaColor_CFCFCF_0)
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    /// 学科年级信息标签
    private lazy var subjectLabel: UILabel = {
        let label = UILabel(
            text: "学科",
            fontSize: 14,
            textColor: MalaColor_FFFFFF_9
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
            textColor: MalaColor_6C6C6C_0
        )
        return label
    }()
    /// 助教老师姓名
    private lazy var assistantLabel: UILabel = {
        let label = UILabel(
            text: "助教老师姓名",
            fontSize: 13,
            textColor: MalaColor_939393_0
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
            textColor: MalaColor_6C6C6C_0
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
            textColor: MalaColor_6C6C6C_0
        )
        label.numberOfLines = 0
        return label
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
            headerBackground.backgroundColor = MalaColor_CFCFCF_0
            break
            
        case .Today:
            headerBackground.backgroundColor = MalaColor_6DB2E5_0
            break
            
        case .Future:
            headerBackground.backgroundColor = MalaColor_6DB2E5_0
            break
        }
    }
}
