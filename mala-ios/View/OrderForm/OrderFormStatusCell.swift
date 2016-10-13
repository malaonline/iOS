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
            
            if let urlString = model?.avatarURL, let url = URL(string: (urlString)) {
                self.avatarView.ma_setImage(url, placeholderImage: UIImage(named: "profileAvatar_placeholder"))
            }
            
            /// 订单状态
            if let status = MalaOrderStatus(rawValue: (model?.status ?? "")) {
                switch status {
                case .Penging:
                    self.statusLabel.text = "订单待支付"
                    break
                    
                case .Paid:
                    self.statusLabel.text = "支付成功"
                    break
                    
                case .Canceled:
                    self.statusLabel.text = "订单已关闭"
                    break
                    
                case .Refund:
                    self.statusLabel.text = "退款成功"
                    break
                    
                case .Confirm:
                    self.statusLabel.text = "确认订单"
                    break
                }
            }
            
            self.teacherLabel.text = model?.teacherName
            self.subjectLabel.text = (model?.gradeName ?? "") + " " + (model?.subjectName ?? "")
            self.schoolLabel.text = model?.schoolName
        }
    }
    

    // MARK: - Components
    /// cell标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "订单状态",
            fontSize: 13,
            textColor: MalaColor_6C6C6C_0
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
        let view = UIView.separator(MalaColor_E5E5E5_0)
        return view
    }()
    /// 老师姓名图标
    private lazy var teacherIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "order_teacher"))
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
        let imageView = UIImageView(image: UIImage(named: "order_subject"))
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
        let imageView = UIImageView(image: UIImage(named: "order_school"))
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
        let imageView = UIImageView(image: UIImage(named: "profileAvatar_placeholder"))
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
        // SubViews
        contentView.addSubview(titleLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(separatorLine)
        
        contentView.addSubview(teacherIcon)
        contentView.addSubview(teacherLabel)
        contentView.addSubview(subjectIcon)
        contentView.addSubview(subjectLabel)
        contentView.addSubview(schoolIcon)
        contentView.addSubview(schoolLabel)
        
        contentView.addSubview(avatarView)
        
        // Autolayout
        // Remove margin
        titleLabel.snp.updateConstraints { (maker) -> Void in
            maker.top.equalTo(self.contentView.snp.top).offset(10)
            maker.left.equalTo(self.contentView.snp.left).offset(12)
            maker.height.equalTo(13)
        }
        statusLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.top)
            maker.right.equalTo(self.contentView.snp.right).offset(-12)
        }
        separatorLine.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
            maker.left.equalTo(self.contentView.snp.left).offset(12)
            maker.right.equalTo(self.contentView.snp.right).offset(-12)
            maker.height.equalTo(MalaScreenOnePixel)
        }
        teacherIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(separatorLine.snp.bottom).offset(10)
            maker.left.equalTo(self.contentView.snp.left).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        teacherLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherIcon.snp.top)
            maker.left.equalTo(teacherIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        subjectIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherIcon.snp.bottom).offset(10)
            maker.left.equalTo(self.contentView.snp.left).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
        }
        subjectLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(subjectIcon.snp.top)
            maker.left.equalTo(subjectIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        schoolIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(subjectIcon.snp.bottom).offset(10)
            maker.left.equalTo(self.contentView.snp.left).offset(12)
            maker.height.equalTo(13)
            maker.width.equalTo(13)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
        schoolLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(schoolIcon.snp.top)
            maker.left.equalTo(schoolIcon.snp.right).offset(10)
            maker.height.equalTo(13)
        }
        avatarView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(subjectIcon.snp.centerY)
            maker.right.equalTo(separatorLine.snp.right)
            maker.height.equalTo(55)
            maker.width.equalTo(55)
        }
    }
}
