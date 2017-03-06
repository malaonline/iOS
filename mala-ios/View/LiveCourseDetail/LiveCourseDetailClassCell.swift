//
//  LiveCourseDetailClassCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/20.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class LiveCourseDetailClassCell: MalaBaseLiveCourseCell {

    // MARK: - Property
    /// 课程模型
    var model: LiveClassModel? {
        didSet{
            guard let model = model else { return }
            
            title = model.courseName
            roomCapacityLabel.text = String(format: "%d人小班  ", model.roomCapacity ?? 0)
            courseGradeLabel.text = (model.courseGrade ?? "")+"  "
            dateLabel.text = String(format: "%@-%@", getDateString(model.courseStart), getDateString(model.courseEnd))
            scheduleLabel.text = model.coursePeriod?.trim().replacingOccurrences(of: ";", with: "\n")
            checkinLabel.text = String(format: "%d人", model.studentsCount ?? 0)
            schoolLabel.attributedText = model.attrAddressString
        }
    }
    
    
    // MARK: - Components
    /// 班级规模
    private lazy var roomCapacityLabel: UILabel = {
        let label = UILabel(
            text: "班级规模",
            font: FontFamily.PingFangSC.Light.font(14),
            textColor: UIColor.white,
            textAlignment: .center,
            backgroundColor: UIColor(named: .ThemeBlue),
            cornerRadius: 3
        )
        return label
    }()
    /// 课程年级
    private lazy var courseGradeLabel: UILabel = {
        let label = UILabel(
            text: "课程年级",
            font: FontFamily.PingFangSC.Light.font(14),
            textColor: UIColor.white,
            textAlignment: .center,
            backgroundColor: UIColor(named: .ThemeBlue),
            cornerRadius: 3
        )
        return label
    }()
    /// 课程日期图标
    private lazy var scheduleIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_schedule")
        return imageView
    }()
    /// 课程日期标签
    private lazy var dateLabel: UILabel = {
        let label = UILabel(
            text: "课程日期",
            font: FontFamily.PingFangSC.Light.font(15),
            textColor: UIColor(named: .ArticleText)
        )
        return label
    }()
    /// 上课时间标签
    private lazy var scheduleLabel: UILabel = {
        let label = UILabel(
            text: "上课时间",
            font: FontFamily.PingFangSC.Light.font(15),
            textColor: UIColor(named: .HeaderTitle),
            opacity: 0.8
        )
        label.numberOfLines = 0
        return label
    }()
    /// 报课人数图标
    private lazy var checkinIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_checkin")
        return imageView
    }()
    /// 报课人数标签
    private lazy var checkinStringLabel: UILabel = {
        let label = UILabel(
            text: "已报: ",
            font: FontFamily.PingFangSC.Light.font(15),
            textColor: UIColor(named: .ArticleText)
        )
        return label
    }()
    /// 报课人数标签
    private lazy var checkinLabel: UILabel = {
        let label = UILabel(
            text: "人数",
            font: FontFamily.PingFangSC.Light.font(15),
            textColor: UIColor(named: .ThemeRed)
        )
        return label
    }()
    /// 上课地点图标
    private lazy var schoolIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_location")
        return imageView
    }()
    /// 上课地点标签
    private lazy var schoolLabel: UILabel = {
        let label = UILabel(
            text: "上课地点",
            font: FontFamily.PingFangSC.Light.font(14),
            textColor: UIColor(named: .ArticleText)
        )
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Instance Method
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // SubViews
        content.addSubview(roomCapacityLabel)
        content.addSubview(courseGradeLabel)
        content.addSubview(scheduleIcon)
        content.addSubview(dateLabel)
        content.addSubview(scheduleLabel)
        content.addSubview(checkinIcon)
        content.addSubview(checkinStringLabel)
        content.addSubview(checkinLabel)
        content.addSubview(schoolIcon)
        content.addSubview(schoolLabel)
        
        // Autolayout
        roomCapacityLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(content)
            maker.left.equalTo(dateLabel)
            maker.height.equalTo(21)
        }
        courseGradeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(roomCapacityLabel)
            maker.left.equalTo(roomCapacityLabel.snp.right).offset(9)
            maker.height.equalTo(roomCapacityLabel)
        }
        scheduleIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(roomCapacityLabel.snp.bottom).offset(12)
            maker.left.equalTo(content)
            maker.height.equalTo(15)
            maker.width.equalTo(15)
        }
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(scheduleIcon.snp.right).offset(6)
            maker.centerY.equalTo(scheduleIcon)
            maker.height.equalTo(15)
        }
        scheduleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(dateLabel.snp.bottom).offset(12)
            maker.left.equalTo(dateLabel)
            maker.right.equalTo(line)
        }
        checkinIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(scheduleLabel.snp.bottom).offset(12)
            maker.left.equalTo(content)
            maker.height.equalTo(15)
            maker.width.equalTo(15)
        }
        checkinStringLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(scheduleLabel)
            maker.centerY.equalTo(checkinIcon)
            maker.height.equalTo(15)
        }
        checkinLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(checkinStringLabel.snp.right)
            maker.centerY.equalTo(checkinStringLabel)
            maker.height.equalTo(15)
        }
        schoolIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(checkinIcon.snp.bottom).offset(12)
            maker.left.equalTo(content)
            maker.width.equalTo(15)
            maker.height.equalTo(15)
        }
        schoolLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(schoolIcon)
            maker.left.equalTo(checkinStringLabel)
            maker.right.equalTo(content)
            maker.bottom.equalTo(content)
        }
    }
}
