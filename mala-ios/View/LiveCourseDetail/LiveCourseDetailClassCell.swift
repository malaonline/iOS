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
            guard let model = model else {
                return
            }
            
            title = model.courseName
            roomCapacityLabel.text = String(format: " %d人小班  ", model.roomCapacity ?? 0)
            courseGradeLabel.text = (model.courseGrade ?? "")+"  "
            dateLabel.text = String(format: "%@-%@", getDateString(model.courseStart), getDateString(model.courseEnd))
            scheduleLabel.text = model.coursePeriod?.trim().replacingOccurrences(of: ";", with: "\n")
            
            
            let string = String(format: "已报: %d人", model.studentsCount ?? 0)
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: string)
            let rangeLocation = (string as NSString).range(of: " ").location
            attrString.addAttribute(
                NSForegroundColorAttributeName,
                value: MalaColor_636363_0,
                range: NSMakeRange(0, rangeLocation)
            )
            attrString.addAttribute(
                NSForegroundColorAttributeName,
                value: MalaColor_E26254_0,
                range: NSMakeRange(rangeLocation, 4)
            )
            
            checkinLabel.attributedText = attrString
        }
    }
    
    
    // MARK: - Components
    /// 班级规模
    private lazy var roomCapacityLabel: UILabel = {
        let label = UILabel(
            text: "班级规模",
            font: UIFont(name: "PingFang-SC-Light", size: 12),
            textColor: UIColor.white,
            textAlignment: .center,
            backgroundColor: MalaColor_9BC3E1_0,
            cornerRadius: 3
        )
        return label
    }()
    /// 课程年级
    private lazy var courseGradeLabel: UILabel = {
        let label = UILabel(
            text: "课程年级",
            font: UIFont(name: "PingFang-SC-Light", size: 12),
            textColor: UIColor.white,
            textAlignment: .center,
            backgroundColor: MalaColor_9BC3E1_0,
            cornerRadius: 3
        )
        return label
    }()
    /// 课程日期图标
    private lazy var scheduleIcon: UIImageView = {
        let imageView = UIImageView(image: "live_schedule")
        return imageView
    }()
    /// 课程日期标签
    private lazy var dateLabel: UILabel = {
        let label = UILabel(
            text: "课程日期",
            font: UIFont(name: "FZLTXHK", size: 13),
            textColor: MalaColor_636363_0
        )
        return label
    }()
    /// 上课时间标签
    private lazy var scheduleLabel: UILabel = {
        let label = UILabel(
            text: "上课时间",
            font: UIFont(name: "FZLTXHK", size: 13),
            textColor: MalaColor_939393_0,
            opacity: 0.8
        )
        label.numberOfLines = 0
        return label
    }()
    /// 报课人数图标
    private lazy var checkinIcon: UIImageView = {
        let imageView = UIImageView(image: "live_checkin")
        return imageView
    }()
    /// 报课人数标签
    private lazy var checkinLabel: UILabel = {
        let label = UILabel(
            text: "已报人数",
            font: UIFont(name: "FZLTXHK", size: 13),
            textColor: MalaColor_636363_0
        )
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
        // Style
        
        // SubViews
        content.addSubview(roomCapacityLabel)
        content.addSubview(courseGradeLabel)
        content.addSubview(scheduleIcon)
        content.addSubview(dateLabel)
        content.addSubview(scheduleLabel)
        content.addSubview(checkinIcon)
        content.addSubview(checkinLabel)
        
        // Autolayout
        roomCapacityLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(12)
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
            maker.height.equalTo(14)
        }
        scheduleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(dateLabel.snp.bottom).offset(12)
            maker.left.equalTo(dateLabel)
        }
        checkinIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(scheduleLabel.snp.bottom).offset(12)
            maker.left.equalTo(content)
            maker.height.equalTo(15)
            maker.width.equalTo(15)
            maker.bottom.equalTo(content).offset(-18)
        }
        checkinLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(checkinIcon.snp.right).offset(6)
            maker.centerY.equalTo(checkinIcon)
            maker.height.equalTo(15)
        }
    }
}
