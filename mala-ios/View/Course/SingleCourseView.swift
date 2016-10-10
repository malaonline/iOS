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
    /// 单个课程数据模型
    var model: StudentCourseModel? {
        didSet {
            
            guard let course = model else {
                return
            }
            
            subjectLabel.text = String(format: "%@ %@", course.grade, course.subject)
            nameLabel.text = course.teacher?.name
            timeLabel.text = String(format: "%@-%@", getDateString(course.start, format: "HH:mm"), getDateString(course.end, format: "HH:mm"))
            schoolLabel.text = model?.school
            changeUI()
        }
    }
    
    
    // MARK: - Components
    /// 信息背景视图
    private lazy var headerBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.backgroundColor = MalaColor_CFCFCF_0
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
    /// 老师姓名标签
    private lazy var nameLabel: UILabel = {
        let label = UILabel(
            text: "老师姓名",
            fontSize: 14,
            textColor: MalaColor_FFFFFF_9
        )
        return label
    }()
    /// 上课时间图标
    private lazy var timeSlotIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "comment_time"))
        return imageView
    }()
    /// 上课时间信息
    private lazy var timeLabel: UILabel = {
        let label = UILabel(
            text: "上课时间",
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
        )
        return label
    }()
    /// 上课地点图标
    private lazy var schoolIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "comment_location"))
        return imageView
    }()
    /// 上课地点
    private lazy var schoolLabel: UILabel = {
        let label = UILabel(
            text: "上课地点",
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
        )
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
        headerBackground.addSubview(nameLabel)
        
        addSubview(timeSlotIcon)
        addSubview(timeLabel)
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
            maker.left.equalTo(headerBackground.snp.left).offset(10)
            maker.centerY.equalTo(headerBackground.snp.centerY)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(14)
            maker.right.equalTo(headerBackground.snp.right).offset(-10)
            maker.centerY.equalTo(headerBackground.snp.centerY)
        }
        timeSlotIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerBackground.snp.bottom).offset(10)
            maker.left.equalTo(headerBackground.snp.left)
            maker.width.equalTo(13)
            maker.height.equalTo(13)
        }
        timeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(timeSlotIcon.snp.top)
            maker.left.equalTo(timeSlotIcon.snp.right).offset(5)
            maker.height.equalTo(13)
        }
        schoolIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(timeSlotIcon.snp.bottom).offset(10)
            maker.left.equalTo(headerBackground.snp.left)
            maker.width.equalTo(13)
            maker.height.equalTo(15)
        }
        schoolLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(schoolIcon.snp.centerY)
            maker.left.equalTo(schoolIcon.snp.right).offset(5)
            maker.height.equalTo(13)
        }
    }
    
    ///  根据课程状态渲染UI
    private func changeUI() {
        
        guard let course = model else {
            return
        }
        
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
