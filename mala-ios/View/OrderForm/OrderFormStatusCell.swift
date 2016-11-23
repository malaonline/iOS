//
//  OrderFormStatusCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/13.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class OrderFormStatusCell: UITableViewCell {
    
    // MARK: - Property
    /// 订单详情模型
    var model: OrderForm? {
        didSet {
            guard let model = model else { return }
        
            // 订单状态
            changeDisplayMode()
            
            // 课程类型
            if let isLive = model.isLiveCourse, isLive == true {
                setupLiveCourseOrderInfo()
            }else {
                setupPrivateTuitionOrderInfo()
            }
        }
    }
    

    // MARK: - Components
    /// 布局容器
    private lazy var content: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// 标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "订单状态",
            fontSize: 15,
            textColor: MalaColor_84B3D7_0
        )
        return label
    }()
    /// 订单状态
    private lazy var statusLabel: UILabel = {
        let label = UILabel(
            text: "状态",
            fontSize: 13,
            textColor: MalaColor_E36A5C_0
        )
        return label
    }()
    /// 分割线
    private lazy var separatorLine: UIView = {
        let view = UIView(MalaColor_F2F2F2_0)
        return view
    }()
    
    // MARK: Components for Private Tuition
    /// 老师图标
    private lazy var teacherIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_teacher")
        return imageView
    }()
    /// 老师标签
    private lazy var teacherLabel: UILabel = {
        let label = UILabel(
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
        )
        return label
    }()
    /// 学科信息图标
    private lazy var subjectIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_class")
        return imageView
    }()
    /// 学科信息
    private lazy var subjectLabel: UILabel = {
        let label = UILabel(
            text: "年级-学科",
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
        )
        return label
    }()
    /// 上课地点图标
    private lazy var schoolIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_location")
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
    /// 老师头像
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView(cornerRadius: 55/2, image: "avatar_placeholder")
        return imageView
    }()
    
    // MARK: Components for LiveCourse
    /// 课程图标
    private lazy var classIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_class")
        return imageView
    }()
    /// 课程标签
    private lazy var classLabel: UILabel = {
        let label = UILabel(
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
        )
        return label
    }()
    /// 班型
    private lazy var roomCapacityIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_students")
        return imageView
    }()
    /// 班型标签
    private lazy var roomCapacityLabel: UILabel = {
        let label = UILabel(
            fontSize: 13,
            textColor: MalaColor_636363_0
        )
        return label
    }()
    /// 上课次数
    private lazy var courseLessonsIcon: UIImageView = {
        let imageView = UIImageView(imageName: "live_times")
        return imageView
    }()
    /// 上课次数标签
    private lazy var courseLessonsLabel: UILabel = {
        let label = UILabel(
            fontSize: 13,
            textColor: MalaColor_636363_0
        )
        return label
    }()
    /// 双师直播课程头像
    private lazy var liveCourseAvatarView: LiveCourseAvatarView = {
        let view = LiveCourseAvatarView()
        return view
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
        contentView.backgroundColor = MalaColor_F2F2F2_0
        
        // SubViews
        contentView.addSubview(content)
        content.addSubview(titleLabel)
        content.addSubview(statusLabel)
        content.addSubview(separatorLine)
        
        // AutoLayout
        content.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView)
            maker.left.equalTo(contentView).offset(12)
            maker.right.equalTo(contentView).offset(-12)
            maker.bottom.equalTo(contentView)
        }
        titleLabel.snp.updateConstraints { (maker) -> Void in
            maker.top.equalTo(content).offset(9.5)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(17)
        }
        statusLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(titleLabel)
            maker.right.equalTo(content).offset(-12)
            maker.height.equalTo(14)
        }
        separatorLine.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(36)
            maker.left.equalTo(content).offset(7)
            maker.right.equalTo(content).offset(-7)
            maker.height.equalTo(MalaScreenOnePixel)
        }
    }
    
    /// 加载一对一课程订单数据
    private func setupPrivateTuitionOrderInfo() {
        // SubViews
        content.addSubview(teacherIcon)
        content.addSubview(teacherLabel)
        content.addSubview(subjectIcon)
        content.addSubview(subjectLabel)
        content.addSubview(schoolIcon)
        content.addSubview(schoolLabel)
        content.addSubview(avatarView)
        
        // Autolayout
        teacherIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(separatorLine.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        teacherLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(teacherIcon)
            maker.left.equalTo(teacherIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        subjectIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherIcon.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        subjectLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(subjectIcon)
            maker.left.equalTo(subjectIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        schoolIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(subjectIcon.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        schoolLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(schoolIcon)
            maker.left.equalTo(teacherLabel)
            maker.right.equalTo(content).offset(-12)
            maker.bottom.equalTo(content).offset(-10)
        }
        avatarView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(subjectIcon)
            maker.right.equalTo(separatorLine)
            maker.height.equalTo(55)
            maker.width.equalTo(55)
        }
        
        /// 课程信息
        avatarView.setImage(withURL: model?.avatarURL)
        teacherLabel.text = model?.teacherName
        subjectLabel.text = (model?.gradeName ?? "") + " " + (model?.subjectName ?? "")
        schoolLabel.attributedText = model?.attrAddressString
    }
    
    /// 加载双师直播课程订单数据
    private func setupLiveCourseOrderInfo() {
        // SubViews
        content.addSubview(teacherIcon)
        content.addSubview(teacherLabel)
        content.addSubview(classIcon)
        content.addSubview(classLabel)
        content.addSubview(roomCapacityIcon)
        content.addSubview(roomCapacityLabel)
        content.addSubview(courseLessonsIcon)
        content.addSubview(courseLessonsLabel)
        content.addSubview(schoolIcon)
        content.addSubview(schoolLabel)
        content.addSubview(liveCourseAvatarView)
        
        // Autolayout
        teacherIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(separatorLine.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        teacherLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(teacherIcon)
            maker.left.equalTo(teacherIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        classIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherIcon.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        classLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(classIcon)
            maker.left.equalTo(teacherLabel)
            maker.height.equalTo(13)
        }
        roomCapacityIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(classIcon.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        roomCapacityLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(roomCapacityIcon)
            maker.left.equalTo(teacherLabel)
            maker.height.equalTo(13)
        }
        courseLessonsIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(roomCapacityIcon.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        courseLessonsLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(courseLessonsIcon)
            maker.left.equalTo(teacherLabel)
            maker.height.equalTo(13)
        }
        schoolIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(courseLessonsIcon.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        schoolLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(schoolIcon)
            maker.left.equalTo(teacherLabel)
            maker.right.equalTo(content).offset(-12)
            maker.bottom.equalTo(content).offset(-10)
        }
        liveCourseAvatarView.snp.makeConstraints { (maker) in
            maker.right.equalTo(content).offset(-12)
            maker.centerY.equalTo(roomCapacityLabel.snp.bottom)
            maker.width.equalTo(72)
            maker.height.equalTo(45)
        }
        
        /// 课程信息
        liveCourseAvatarView.setAvatar(lecturer: model?.liveClass?.lecturerAvatar, assistant: model?.liveClass?.assistantAvatar)
        teacherLabel.attributedText = model?.attrTeacherString
        classLabel.text = model?.liveClass?.courseName
        roomCapacityLabel.text = String(format: "%d人小班", model?.liveClass?.roomCapacity ?? 0)
        courseLessonsLabel.text = String(format: "共 %d 次课", model?.liveClass?.courseLessons ?? 0)
        schoolLabel.attributedText = model?.attrAddressString
    }
    
    /// 根据当前订单状态，渲染对应UI样式
    private func changeDisplayMode() {
        /// 订单状态
        if let status = MalaOrderStatus(rawValue: (model?.status ?? "")) {
            switch status {
            case .penging:
                statusLabel.text = "待支付"
                statusLabel.textColor = MalaColor_E36A5D_0
                break
                
            case .paid:
                statusLabel.text = "支付成功"
                statusLabel.textColor = MalaColor_7bb045_0
                break
                
            case .canceled:
                statusLabel.text = "已关闭"
                statusLabel.textColor = MalaColor_939393_0
                break
                
            case .refund:
                statusLabel.text = "已退款"
                statusLabel.textColor = MalaColor_7bb045_0
                break
                
            case .confirm:
                statusLabel.text = "确认订单"
                statusLabel.textColor = MalaColor_E36A5D_0
                break
                
            default:
                break
            }
        }
    }
}
