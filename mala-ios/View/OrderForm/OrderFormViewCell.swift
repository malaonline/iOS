//
//  OrderFormViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/6.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class OrderFormViewCell: UITableViewCell {
    
    // MARK: - Property
    /// 订单模型
    var model: OrderForm? {
        didSet {
            // 加载订单数据
            orderIdString.text = model?.order_id
            teacherNameString.text = model?.teacherName
            subjectString.text = (model?.gradeName ?? "") + " " + (model?.subjectName ?? "")
            schoolString.text = model?.schoolName
            amountString.text = model?.amount.priceCNY
            
            // 老师头像
            avatarView.setImage(withURL: model?.avatarURL, placeholderImage: "profileAvatar_placeholder")
            
            // 设置订单状态
            if let status = model?.status, let orderStatus = MalaOrderStatus(rawValue: status) {
                self.orderStatus = orderStatus
            }
            
            // 设置老师下架状态
            disabledLabel.isHidden = !(model?.teacherPublished == false)
        }
    }
    /// 订单状态
    private var orderStatus: MalaOrderStatus = .Canceled {
        didSet {
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                self?.changeDisplayMode()
            })
        }
    }
    
    
    // MARK: - Components
    /// 顶部分隔视图
    private lazy var separatorView: UIView = {
        let view = UIView()
        return view
    }()
    /// 父布局容器
    private lazy var content: UIImageView = {
        let imageView = UIImageView(imageName: "orderForm_background")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    /// 顶部订单编号布局容器
    private lazy var topLayoutView: UIView = {
        let view = UIView(MalaColor_B1D0E8_0)
        return view
    }()
    /// "订单编号"文字
    private lazy var orderIdLabel: UILabel = {
        let label = UILabel()
        label.text = "订单编号："
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.white
        return label
    }()
    /// 订单编号
    private lazy var orderIdString: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.white
        return label
    }()
    /// 中部订单信息布局容器
    private lazy var middleLayoutView: UIView = {
        let view = UIView()
        return view
    }()
    /// "老师姓名"文字
    private lazy var teacherNameLabel: UILabel = {
        let label = UILabel()
        label.text = "教师姓名："
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = MalaColor_636363_0
        return label
    }()
    /// 老师姓名
    private lazy var teacherNameString: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = MalaColor_939393_0
        return label
    }()
    /// "课程名称"文字
    private lazy var subjectLabel: UILabel = {
        let label = UILabel()
        label.text = "课程名称："
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = MalaColor_636363_0
        return label
    }()
    /// 课程名称
    private lazy var subjectString: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = MalaColor_939393_0
        return label
    }()
    /// "上课地点"文字
    private lazy var schoolLabel: UILabel = {
        let label = UILabel()
        label.text = "上课地点："
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = MalaColor_636363_0
        return label
    }()
    /// 课程名称
    private lazy var schoolString: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = MalaColor_939393_0
        return label
    }()
    /// 订单状态
    private lazy var statusString: UILabel = {
        let label = UILabel()
        label.text = "订单状态"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MalaColor_939393_0
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
    /// 中部分割线
    private lazy var separatorLine: UIView = {
        let view = UIView(MalaColor_DADADA_0)
        return view
    }()
    
    /// 底部价格及操作布局容器
    private lazy var bottomLayoutView: UIView = {
        let view = UIView()
        return view
    }()
    /// "共计"文字
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "共计："
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MalaColor_636363_0
        return label
    }()
    /// 共计金额
    private lazy var amountString: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = MalaColor_333333_0
        return label
    }()
    /// 老师已下架样式
    private lazy var disabledLabel: UILabel = {
        let label = UILabel(
            text: "该老师已下架",
            fontSize: 12,
            textColor: MalaColor_939393_0
        )
        label.isHidden = true
        return label
    }()
    /// 确定按钮（确认支付、再次购买、重新购买）
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        
        button.layer.borderColor = MalaColor_E26254_0.cgColor
        button.layer.borderWidth = MalaScreenOnePixel
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitle("再次购买", for: UIControlState())
        button.setTitleColor(MalaColor_E26254_0, for: UIControlState())
        button.addTarget(self, action: #selector(OrderFormViewCell.buyAgain), for: .touchUpInside)
        return button
    }()
    /// 取消按钮（取消订单）
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        button.layer.borderColor = MalaColor_939393_0.cgColor
        button.layer.borderWidth = MalaScreenOnePixel
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitle("取消订单", for: UIControlState())
        button.setTitleColor(MalaColor_939393_0, for: UIControlState())
        button.addTarget(self, action: #selector(OrderFormViewCell.cancelOrderForm), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Constructed
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
        contentView.addSubview(separatorView)
        contentView.addSubview(content)
        
        content.addSubview(topLayoutView)
        topLayoutView.addSubview(orderIdLabel)
        topLayoutView.addSubview(orderIdString)
        
        content.addSubview(middleLayoutView)
        middleLayoutView.addSubview(teacherNameLabel)
        middleLayoutView.addSubview(teacherNameString)
        middleLayoutView.addSubview(subjectLabel)
        middleLayoutView.addSubview(subjectString)
        middleLayoutView.addSubview(schoolLabel)
        middleLayoutView.addSubview(schoolString)
        middleLayoutView.addSubview(separatorLine)
        middleLayoutView.addSubview(statusString)
        middleLayoutView.addSubview(avatarView)
        
        content.addSubview(bottomLayoutView)
        bottomLayoutView.addSubview(amountLabel)
        bottomLayoutView.addSubview(amountString)
        bottomLayoutView.addSubview(confirmButton)
        bottomLayoutView.addSubview(cancelButton)
        bottomLayoutView.addSubview(disabledLabel)
        
        
        // Autolayout
        separatorView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(contentView)
            maker.left.equalTo(contentView).offset(6)
            maker.bottom.equalTo(content.snp.top)
            maker.right.equalTo(contentView).offset(-6)
            maker.height.equalTo(6)
        }
        content.snp.makeConstraints { (maker) in
            maker.top.equalTo(separatorView.snp.bottom)
            maker.left.equalTo(contentView).offset(6)
            maker.bottom.equalTo(contentView)
            maker.right.equalTo(contentView).offset(-6)
        }
        
        topLayoutView.snp.makeConstraints { (maker) in
            maker.top.equalTo(content)
            maker.left.equalTo(content).offset(MalaScreenOnePixel)
            maker.right.equalTo(content).offset(-MalaScreenOnePixel)
            maker.height.equalTo(content).multipliedBy(0.15)
        }
        orderIdLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(11)
            maker.centerY.equalTo(topLayoutView)
            maker.left.equalTo(topLayoutView).offset(12)
        }
        orderIdString.snp.makeConstraints { (maker) in
            maker.height.equalTo(11)
            maker.centerY.equalTo(orderIdLabel)
            maker.left.equalTo(orderIdLabel.snp.right)
        }
        
        middleLayoutView.snp.makeConstraints { (maker) in
            maker.top.equalTo(topLayoutView.snp.bottom)
            maker.left.equalTo(content).offset(12)
            maker.right.equalTo(content).offset(-12)
            maker.height.equalTo(content).multipliedBy(0.55)
        }
        teacherNameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(middleLayoutView).offset(14)
            maker.left.equalTo(middleLayoutView)
            maker.height.equalTo(11)
        }
        teacherNameString.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherNameLabel)
            maker.left.equalTo(teacherNameLabel.snp.right)
            maker.height.equalTo(11)
        }
        subjectLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherNameLabel.snp.bottom).offset(14)
            maker.left.equalTo(middleLayoutView)
            maker.height.equalTo(11)
        }
        subjectString.snp.makeConstraints { (maker) in
            maker.top.equalTo(subjectLabel)
            maker.left.equalTo(subjectLabel.snp.right)
            maker.height.equalTo(11)
        }
        schoolLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(subjectLabel.snp.bottom).offset(14)
            maker.left.equalTo(middleLayoutView)
            maker.height.equalTo(11)
        }
        schoolString.snp.makeConstraints { (maker) in
            maker.top.equalTo(schoolLabel)
            maker.left.equalTo(schoolLabel.snp.right)
            maker.height.equalTo(11)
        }
        statusString.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(confirmButton)
            maker.top.equalTo(middleLayoutView).offset(14)
            maker.height.equalTo(12)
        }
        avatarView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(statusString)
            maker.bottom.equalTo(middleLayoutView).offset(-14)
            maker.height.equalTo(55)
            maker.width.equalTo(55)
        }
        separatorLine.snp.makeConstraints { (maker) in
            maker.left.equalTo(middleLayoutView).offset(-3)
            maker.right.equalTo(middleLayoutView).offset(3)
            maker.bottom.equalTo(middleLayoutView)
            maker.height.equalTo(MalaScreenOnePixel)
        }
        
        bottomLayoutView.snp.makeConstraints { (maker) in
            maker.top.equalTo(middleLayoutView.snp.bottom)
            maker.left.equalTo(content).offset(12)
            maker.right.equalTo(content).offset(-12)
            maker.height.equalTo(content).multipliedBy(0.24)
        }
        amountLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(bottomLayoutView)
            maker.left.equalTo(bottomLayoutView)
            maker.height.equalTo(12)
        }
        amountString.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(bottomLayoutView)
            maker.left.equalTo(amountLabel.snp.right)
            maker.height.equalTo(16)
        }
        confirmButton.snp.makeConstraints { (maker) in
            maker.width.equalTo(content).multipliedBy(0.23)
            maker.height.equalTo(24)
            maker.centerY.equalTo(bottomLayoutView)
            maker.right.equalTo(bottomLayoutView)
        }
        disabledLabel.snp.makeConstraints { (maker) in
            maker.center.equalTo(confirmButton)
        }
        cancelButton.snp.makeConstraints { (maker) in
            maker.width.equalTo(content).multipliedBy(0.23)
            maker.height.equalTo(24)
            maker.centerY.equalTo(bottomLayoutView)
            maker.right.equalTo(confirmButton.snp.left).offset(-14)
        }
    }
    
    /// 根据当前订单状态，渲染对应UI样式
    private func changeDisplayMode() {
                
        // 解除绑定事件
        cancelButton.removeTarget(self, action: #selector(OrderFormViewCell.cancelOrderForm), for: .touchUpInside)
        confirmButton.removeTarget(self, action: #selector(OrderFormViewCell.pay), for: .touchUpInside)
        confirmButton.removeTarget(self, action: #selector(OrderFormViewCell.buyAgain), for: .touchUpInside)
        
        // 渲染UI样式
        switch orderStatus {
        case .Penging:
            // 待付款
            topLayoutView.backgroundColor = MalaColor_8FBCDD_0
            statusString.text = "订单待支付"
            statusString.textColor = MalaColor_E26254_0
            
            cancelButton.isHidden = false
            confirmButton.isHidden = false
            
            confirmButton.setTitle("立即支付", for: UIControlState())
            confirmButton.setBackgroundImage(UIImage.withColor(MalaColor_E26254_0), for: UIControlState())
            confirmButton.setTitleColor(UIColor.white, for: UIControlState())
            
            cancelButton.addTarget(self, action: #selector(OrderFormViewCell.cancelOrderForm), for: .touchUpInside)
            confirmButton.addTarget(self, action: #selector(OrderFormViewCell.pay), for: .touchUpInside)
            break
        
        case .Paid:
            // 已付款
            topLayoutView.backgroundColor = MalaColor_B1D0E8_0
            statusString.text = "交易完成"
            statusString.textColor = MalaColor_8FBCDD_0
            
            cancelButton.isHidden = true
            confirmButton.isHidden = false
            
            confirmButton.setTitle("再次购买", for: UIControlState())
            confirmButton.setBackgroundImage(UIImage.withColor(UIColor.white), for: UIControlState())
            confirmButton.setTitleColor(MalaColor_E26254_0, for: UIControlState())
            
            confirmButton.addTarget(self, action: #selector(OrderFormViewCell.buyAgain), for: .touchUpInside)
            break
        
        case .Canceled:
            // 已取消
            topLayoutView.backgroundColor = MalaColor_CFCFCF_0
            statusString.text = "订单已关闭"
            statusString.textColor = MalaColor_939393_0
            
            cancelButton.isHidden = true
            confirmButton.isHidden = false
            
            confirmButton.setTitle("重新购买", for: UIControlState())
            confirmButton.setBackgroundImage(UIImage.withColor(UIColor.white), for: UIControlState())
            confirmButton.setTitleColor(MalaColor_E26254_0, for: UIControlState())
            
            confirmButton.addTarget(self, action: #selector(OrderFormViewCell.buyAgain), for: .touchUpInside)
            break
        
        case .Refund:
            // 已退款
            topLayoutView.backgroundColor = MalaColor_B1D0E8_0
            statusString.text = "退款成功"
            statusString.textColor = MalaColor_83B84F_0
            
            cancelButton.isHidden = true
            confirmButton.isHidden = true
            break
            
        case .Confirm:
            break
        }
        
        if model?.teacherPublished == false {
            cancelButton.isHidden = true
            confirmButton.isHidden = true
        }
    }
    
    
    // MARK: - Event Response
    /// 立即支付
    @objc private func pay() {
        NotificationCenter.default.post(name: MalaNotification_PushToPayment, object: self.model)
    }
    
    /// 再次购买
    @objc private func buyAgain() {
        MalaIsHasBeenEvaluatedThisSubject = model?.evaluated
        NotificationCenter.default.post(name: MalaNotification_PushTeacherDetailView, object: self.model)
    }
    
    /// 取消订单
    @objc private func cancelOrderForm() {
        NotificationCenter.default.post(name: MalaNotification_CancelOrderForm, object: self.model?.id)
    }
    
    
    
    // MARK: - Override
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        cancelButton.hidden = false
//        confirmButton.hidden = false
//        disabledLabel.hidden = false
    }
}
