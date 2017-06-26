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
            
            if let title = model.attrCourseTitle {
                titleLabel.attributedText = title
            }else {
                titleLabel.text = model.courseName
            }
            roomCapacityLabel.text = String(format: "%d人小班  ", model.roomCapacity ?? 0)
            courseGradeLabel.text = (model.courseGrade ?? "")+"  "
            dateLabel.text = String(format: "%@ - %@", getDateString(model.courseStart), getDateString(model.courseEnd))
            scheduleLabel.text = model.coursePeriod?.trim().replacingOccurrences(of: ";", with: "\n")
            checkinLabel.text = String(format: "%d人", model.remaining)
            schoolLabel.attributedText = model.attrAddressString
            progressBar.progress = CGFloat((model.studentsCount ?? 0)/(model.roomCapacity ?? 0))
        }
    }
    
    
    // MARK: - Components
    /// 班级规模
    private lazy var roomCapacityLabel: UILabel = {
        let label = UILabel(
            text: "班级规模",
            font: FontFamily.PingFangSC.Regular.font(12),
            textColor: UIColor(named: .liveDetailThemeBlue),
            textAlignment: .center,
            borderColor: UIColor(named: .liveDetailThemeBlue),
            borderWidth: 1.0,
            cornerRadius: 2
        )
        return label
    }()
    /// 课程年级
    private lazy var courseGradeLabel: UILabel = {
        let label = UILabel(
            text: "课程年级",
            font: FontFamily.PingFangSC.Regular.font(12),
            textColor: UIColor(named: .liveDetailThemeBlue),
            textAlignment: .center,
            borderColor: UIColor(named: .liveDetailThemeBlue),
            borderWidth: 1.0,
            cornerRadius: 2
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
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .ArticleTitle)
        )
        return label
    }()
    /// 上课时间标签
    private lazy var scheduleLabel: UILabel = {
        let label = UILabel(
            text: "上课时间",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .protocolGary)
        )
        label.numberOfLines = 0
        return label
    }()
    /// 报课人数图标
    private lazy var checkinIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_checkin")
        return imageView
    }()
    /// 报课人数条形图
    private lazy var progressBar: YLProgressBar = {
        let bar = YLProgressBar()
        bar.indicatorTextDisplayMode = .progress
        bar.behavior = .indeterminate
        bar.stripesOrientation = .left
        bar.progressTintColor = UIColor(named: .pageControlGray)
        bar.trackTintColor = UIColor(named: .pageControlGray)
        bar.stripesColor = UIColor(named: .pageControlGray)
        bar.progressTintColors = [UIColor(named: .indexBlue)]
        bar.hideGloss = true
        return bar
    }()
    /// 报课人数标签
    private lazy var checkinStringLabel: UILabel = {
        let label = UILabel(
            text: "剩余名额: ",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .ArticleTitle)
        )
        return label
    }()
    /// 报课人数标签
    private lazy var checkinLabel: UILabel = {
        let label = UILabel(
            text: "人数",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .liveDetailThemeRed)
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
        cardContent.addSubview(courseGradeLabel)
        cardContent.addSubview(roomCapacityLabel)
        
        content.addSubview(scheduleIcon)
        content.addSubview(dateLabel)
        content.addSubview(scheduleLabel)
        content.addSubview(checkinIcon)
        content.addSubview(progressBar)
        content.addSubview(checkinStringLabel)
        content.addSubview(checkinLabel)
        content.addSubview(schoolIcon)
        content.addSubview(schoolLabel)
        
        // Autolayout
        courseGradeLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(titleLabel)
            maker.right.equalTo(line)
            maker.height.equalTo(20)
        }
        roomCapacityLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(courseGradeLabel)
            maker.right.equalTo(courseGradeLabel.snp.left).offset(-6)
            maker.height.equalTo(20)
        }
        scheduleIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(line.snp.bottom).offset(20)
            maker.left.equalTo(line)
            maker.height.equalTo(15)
            maker.width.equalTo(15)
        }
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(scheduleIcon.snp.right).offset(6)
            maker.centerY.equalTo(scheduleIcon)
            maker.height.equalTo(15)
        }
        scheduleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(dateLabel.snp.bottom).offset(10)
            maker.left.equalTo(dateLabel)
            maker.right.equalTo(line)
        }
        checkinIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(scheduleLabel.snp.bottom).offset(12)
            maker.left.equalTo(line)
            maker.height.equalTo(15)
            maker.width.equalTo(15)
        }
        progressBar.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(checkinIcon)
            maker.left.equalTo(dateLabel)
            maker.right.equalTo(line)
            maker.height.equalTo(6)
        }
        checkinStringLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(progressBar)
            maker.top.equalTo(progressBar.snp.bottom).offset(10)
            maker.height.equalTo(15)
        }
        checkinLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(checkinStringLabel.snp.right)
            maker.centerY.equalTo(checkinStringLabel)
            maker.height.equalTo(15)
        }
        schoolIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(checkinLabel.snp.bottom).offset(15)
            maker.left.equalTo(line)
            maker.width.equalTo(15)
            maker.height.equalTo(15)
        }
        schoolLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(schoolIcon).offset(-2)
            maker.left.equalTo(checkinStringLabel)
            maker.right.equalTo(content)
            maker.bottom.equalTo(content)
        }
    }
}
