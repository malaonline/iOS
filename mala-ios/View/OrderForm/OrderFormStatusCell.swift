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
            
            guard let _ = model else {
                return
            }
            
            // 订单状态
            self.changeDisplayMode()
            // 课程类型
            if let isLive = self.model?.isLiveCourse, isLive == true {
                self.setupLiveCourseOrderInfo()
            }else {
                self.setupPrivateTuitionOrderInfo()
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
            textColor: MalaColor_333333_0
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
    /// 名称图标
    private lazy var nameIcon: UIImageView = {
        let imageView = UIImageView(imageName: "order_teacher")
        return imageView
    }()
    /// 名称（老师名 或 课程名）
    private lazy var nameLabel: UILabel = {
        let label = UILabel(
            text: "名称",
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
        )
        return label
    }()
    /// 学科信息图标
    private lazy var subjectIcon: UIImageView = {
        let imageView = UIImageView(imageName: "order_subject")
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
        let imageView = UIImageView(imageName: "order_school")
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
    /// 老师头像
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView(cornerRadius: 55/2, image: "profileAvatar_placeholder")
        return imageView
    }()
    
    // MARK: Components for LiveCourse
    /// 班型
    private lazy var roomCapacityIcon: UIImageView = {
        let imageView = UIImageView(imageName: "order_school")
        return imageView
    }()
    /// 班型标签
    private lazy var roomCapacityLabel: UILabel = {
        let label = UILabel(
            text: "班    型：",
            fontSize: 13,
            textColor: MalaColor_636363_0
        )
        return label
    }()
    /// 上课次数
    private lazy var courseLessonsIcon: UIImageView = {
        let imageView = UIImageView(imageName: "order_school")
        return imageView
    }()
    /// 上课次数标签
    private lazy var courseLessonsLabel: UILabel = {
        let label = UILabel(
            text: "上课次数：",
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
        content.addSubview(nameIcon)
        content.addSubview(nameLabel)
        content.addSubview(subjectIcon)
        content.addSubview(subjectLabel)
        content.addSubview(schoolIcon)
        content.addSubview(schoolLabel)
        content.addSubview(avatarView)
        
        // Autolayout
        nameIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(separatorLine.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(nameIcon)
            maker.left.equalTo(nameIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        subjectIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(nameIcon.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        subjectLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(subjectIcon)
            maker.left.equalTo(subjectIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        schoolIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(subjectIcon.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
            maker.bottom.equalTo(content).offset(-10)
        }
        schoolLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(schoolIcon)
            maker.left.equalTo(schoolIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        avatarView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(subjectIcon)
            maker.right.equalTo(separatorLine)
            maker.height.equalTo(55)
            maker.width.equalTo(55)
        }
        
        
        /// 课程信息
        avatarView.setImage(withURL: model?.avatarURL, placeholderImage: "profileAvatar_placeholder")
        nameLabel.text = model?.teacherName
        subjectLabel.text = (model?.gradeName ?? "") + " " + (model?.subjectName ?? "")
        schoolLabel.text = model?.schoolName
    }
    
    /// 加载双师直播课程订单数据
    private func setupLiveCourseOrderInfo() {
        // SubViews
        content.addSubview(nameIcon)
        content.addSubview(nameLabel)
        content.addSubview(roomCapacityIcon)
        content.addSubview(roomCapacityLabel)
        content.addSubview(courseLessonsIcon)
        content.addSubview(courseLessonsLabel)
        content.addSubview(schoolIcon)
        content.addSubview(schoolLabel)
        content.addSubview(liveCourseAvatarView)
        
        // Autolayout
        nameIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(separatorLine.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(nameIcon)
            maker.left.equalTo(nameIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        roomCapacityIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(nameIcon.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        roomCapacityLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(roomCapacityIcon)
            maker.left.equalTo(roomCapacityIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        courseLessonsIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(roomCapacityIcon.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        courseLessonsLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(courseLessonsIcon)
            maker.left.equalTo(courseLessonsIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        schoolIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(courseLessonsIcon.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
            maker.bottom.equalTo(content).offset(-10)
        }
        schoolLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(schoolIcon)
            maker.left.equalTo(schoolIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        liveCourseAvatarView.snp.makeConstraints { (maker) in
            maker.right.equalTo(content).offset(-12)
            maker.top.equalTo(roomCapacityIcon.snp.centerY)
            maker.width.equalTo(72)
            maker.height.equalTo(45)
        }
        
        /// 课程信息
        liveCourseAvatarView.setAvatar(lecturer: model?.liveClass?.lecturerAvatar, assistant: model?.liveClass?.assistantAvatar)
        nameIcon.setImage(withImageName: "live_class")
        nameLabel.text = String(format: "课程名称：%@", model?.liveClass?.courseName ?? "")
        roomCapacityIcon.setImage(withImageName: "live_students")
        roomCapacityLabel.text = String(format: "班       型：%d人", model?.liveClass?.roomCapacity ?? 0)
        courseLessonsIcon.setImage(withImageName: "live_times")
        courseLessonsLabel.text = String(format: "上课次数：%d次", model?.liveClass?.courseLessons ?? 0)
        schoolIcon.setImage(withImageName: "live_location")
        schoolLabel.text = String(format: "上课地点：%@", model?.schoolName ?? "")
    }
    
    /// 根据当前订单状态，渲染对应UI样式
    private func changeDisplayMode() {
        /// 订单状态
        if let status = MalaOrderStatus(rawValue: (model?.status ?? "")) {
            switch status {
            case .penging:
                statusLabel.text = "订单待支付"
                break
                
            case .paid:
                statusLabel.text = "支付成功"
                break
                
            case .canceled:
                statusLabel.text = "订单已关闭"
                break
                
            case .refund:
                statusLabel.text = "退款成功"
                break
                
            case .confirm:
                statusLabel.text = "确认订单"
                break
                
            default:
                break
            }
        }
    }
}
