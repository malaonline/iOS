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
            /// 老师头像
            
            if let url = model?.avatarURL {
                self.avatarView.setImage(withURL: url, placeholderImage: "profileAvatar_placeholder")
            }
            
            /// 订单状态
            if let status = MalaOrderStatus(rawValue: (model?.status ?? "")) {
                switch status {
                case .penging:
                    self.statusLabel.text = "订单待支付"
                    break
                    
                case .paid:
                    self.statusLabel.text = "支付成功"
                    break
                    
                case .canceled:
                    self.statusLabel.text = "订单已关闭"
                    break
                    
                case .refund:
                    self.statusLabel.text = "退款成功"
                    break
                    
                case .confirm:
                    self.statusLabel.text = "确认订单"
                    break
                    
                default:
                    break
                }
            }
            
            self.teacherLabel.text = model?.teacherName
            self.subjectLabel.text = (model?.gradeName ?? "") + " " + (model?.subjectName ?? "")
            self.schoolLabel.text = model?.schoolName
        }
    }
    

    // MARK: - Components
    /// 布局容器
    private lazy var content: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// cell标题
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
    /// 老师姓名图标
    private lazy var teacherIcon: UIImageView = {
        let imageView = UIImageView(imageName: "order_teacher")
        return imageView
    }()
    /// 老师姓名
    private lazy var teacherLabel: UILabel = {
        let label = UILabel(
            text: "教师姓名",
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
        let imageView = UIImageView(imageName: "profileAvatar_placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 55/2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    // MARK: - Contructed
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
        
        // SubViews
        contentView.addSubview(content)
        content.addSubview(titleLabel)
        content.addSubview(statusLabel)
        content.addSubview(separatorLine)
        content.addSubview(teacherIcon)
        content.addSubview(teacherLabel)
        content.addSubview(subjectIcon)
        content.addSubview(subjectLabel)
        content.addSubview(schoolIcon)
        content.addSubview(schoolLabel)
        content.addSubview(avatarView)
        
        // Autolayout
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
        teacherIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(separatorLine.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        teacherLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherIcon)
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
    }
}
