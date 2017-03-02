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
            // 订单课程数据
            orderIdString.text = model?.orderId
            subjectString.text = (model?.gradeName ?? "") + " " + (model?.subjectName ?? "")
            schoolString.text = model?.schoolName
            amountString.text = model?.amount.priceCNY
            // 订单状态
            if let status = model?.status, let orderStatus = MalaOrderStatus(rawValue: status) {
                self.orderStatus = orderStatus
            }
            
            // 仅课程类型为一对一课程时,老师下架状态才会生效
            if let isLiveCourse = model?.isLiveCourse, isLiveCourse == false  {
                disabledLabel.isHidden = !(model?.isTeacherPublished == false)
            }
            
            // 根据课程类型加载数据
            if let isLive = model?.isLiveCourse, isLive == true {
                setupLiveCourseOrderInfo()
            }else {
                setupPrivateTuitionOrderInfo()
            }
        }
    }
    /// 订单状态
    private var orderStatus: MalaOrderStatus = .canceled {
        didSet {
            DispatchQueue.main.async {
                self.changeDisplayMode()
            }
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
        let view = UIView(UIColor(named: .ThemeBlue))
        return view
    }()
    /// "订单编号"文字
    private lazy var orderIdLabel: UILabel = {
        let label = UILabel(
            text: "订单编号：",
            font: UIFont.systemFont(ofSize: 11),
            textColor: UIColor.white
        )
        return label
    }()
    /// 订单编号
    private lazy var orderIdString: UILabel = {
        let label = UILabel(
            font: UIFont.systemFont(ofSize: 11),
            textColor: UIColor.white
        )
        return label
    }()
    /// 中部订单信息布局容器
    private lazy var middleLayoutView: UIView = {
        let view = UIView()
        return view
    }()
    /// "老师姓名"文字
    private lazy var teacherNameLabel: UILabel = {
        let label = UILabel(
            text: "教师姓名：",
            font: UIFont.systemFont(ofSize: 11),
            textColor: UIColor(named: .ArticleText)
        )
        return label
    }()
    /// 老师姓名
    private lazy var teacherNameString: UILabel = {
        let label = UILabel(
            font: UIFont.systemFont(ofSize: 11),
            textColor: UIColor(named: .HeaderTitle)
        )
        return label
    }()
    /// "课程名称"文字
    private lazy var subjectLabel: UILabel = {
        let label = UILabel(
            text: "课程名称：",
            font: UIFont.systemFont(ofSize: 11),
            textColor: UIColor(named: .ArticleText)
        )
        return label
    }()
    /// 课程名称
    private lazy var subjectString: UILabel = {
        let label = UILabel(
            font: UIFont.systemFont(ofSize: 11),
            textColor: UIColor(named: .HeaderTitle)
        )
        return label
    }()
    /// "上课地点"文字
    private lazy var schoolLabel: UILabel = {
        let label = UILabel(
            text: "上课地点：",
            font: UIFont.systemFont(ofSize: 11),
            textColor: UIColor(named: .ArticleText)
        )
        return label
    }()
    /// 课程名称
    private lazy var schoolString: UILabel = {
        let label = UILabel(
            font: UIFont.systemFont(ofSize: 11),
            textColor: UIColor(named: .HeaderTitle)
        )
        return label
    }()
    /// 订单状态
    private lazy var statusString: UILabel = {
        let label = UILabel(
            text: "订单状态",
            font: UIFont.systemFont(ofSize: 12),
            textColor: UIColor(named: .HeaderTitle)
        )
        return label
    }()
    /// 老师头像
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView(cornerRadius: 55/2, image: "avatar_placeholder")
        return imageView
    }()
    /// 双师直播课程头像
    private lazy var liveCourseAvatarView: LiveCourseAvatarView = {
        let view = LiveCourseAvatarView()
        return view
    }()
    /// 中部分割线
    private lazy var separatorLine: UIView = {
        let view = UIView(UIColor(named: .SeparatorLine))
        return view
    }()
    
    /// 底部价格及操作布局容器
    private lazy var bottomLayoutView: UIView = {
        let view = UIView()
        return view
    }()
    /// "共计"文字
    private lazy var amountLabel: UILabel = {
        let label = UILabel(
            text: "共计：",
            font: UIFont.systemFont(ofSize: 12),
            textColor: UIColor(named: .ArticleText)
        )
        return label
    }()
    /// 共计金额
    private lazy var amountString: UILabel = {
        let label = UILabel(
            text: "共计：",
            font: UIFont.systemFont(ofSize: 16),
            textColor: UIColor(named: .ArticleTitle)
        )
        return label
    }()
    /// 老师已下架样式
    private lazy var disabledLabel: UILabel = {
        let label = UILabel(
            text: "该老师已下架",
            fontSize: 12,
            textColor: UIColor(named: .HeaderTitle)
        )
        label.isHidden = true
        return label
    }()
    /// 确定按钮（确认支付、再次购买、重新购买）
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        
        button.layer.borderColor = UIColor(named: .ThemeRed).cgColor
        button.layer.borderWidth = MalaScreenOnePixel
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitle("再次购买", for: .normal)
        button.setTitleColor(UIColor(named: .ThemeRed), for: .normal)
        button.addTarget(self, action: #selector(OrderFormViewCell.buyAgain), for: .touchUpInside)
        return button
    }()
    /// 取消按钮（取消订单）
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        button.layer.borderColor = UIColor(named: .HeaderTitle).cgColor
        button.layer.borderWidth = MalaScreenOnePixel
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitle(L10n.cancelOrder, for: .normal)
        button.setTitleColor(UIColor(named: .HeaderTitle), for: .normal)
        button.addTarget(self, action: #selector(OrderFormViewCell.cancelOrderForm), for: .touchUpInside)
        return button
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
        contentView.backgroundColor = UIColor(named: .RegularBackground)
        
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
        middleLayoutView.addSubview(liveCourseAvatarView)
        
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
        liveCourseAvatarView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(statusString)
            maker.bottom.equalTo(middleLayoutView).offset(-14)
            maker.width.equalTo(72)
            maker.height.equalTo(45)
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
    
    /// 加载一对一课程订单数据
    private func setupPrivateTuitionOrderInfo() {
        // 显示老师信息
        teacherNameLabel.isHidden = false
        teacherNameString.isHidden = false
        avatarView.isHidden = false
        liveCourseAvatarView.isHidden = true
        
        teacherNameString.text = model?.teacherName
        avatarView.setImage(withURL: model?.avatarURL)

    }
    
    /// 加载双师直播课程订单数据
    private func setupLiveCourseOrderInfo() {
        // 隐藏老师信息
        teacherNameLabel.isHidden = true
        teacherNameString.isHidden = true
        avatarView.isHidden = true
        liveCourseAvatarView.isHidden = false
        
        subjectString.text = model?.liveClass?.courseName
        liveCourseAvatarView.setAvatar(lecturer: model?.liveClass?.lecturerAvatar, assistant: model?.liveClass?.assistantAvatar)
    }
    
    /// 根据当前订单状态，渲染对应UI样式
    private func changeDisplayMode() {
                
        // 解除绑定事件
        cancelButton.removeTarget(self, action: #selector(OrderFormViewCell.cancelOrderForm), for: .touchUpInside)
        confirmButton.removeTarget(self, action: #selector(OrderFormViewCell.pay), for: .touchUpInside)
        confirmButton.removeTarget(self, action: #selector(OrderFormViewCell.buyAgain), for: .touchUpInside)
        
        // 渲染UI样式
        switch orderStatus {
        case .penging:
            // 待付款
            topLayoutView.backgroundColor = UIColor(named: .ThemeBlue)
            statusString.text = "订单待支付"
            statusString.textColor = UIColor(named: .ThemeRed)
            cancelButton.isHidden = false
            confirmButton.isHidden = false
            confirmButton.setTitle("立即支付", for: .normal)
            confirmButton.setBackgroundImage(UIImage.withColor(UIColor(named: .ThemeRed)), for: .normal)
            confirmButton.setTitleColor(UIColor.white, for: .normal)
            cancelButton.addTarget(self, action: #selector(OrderFormViewCell.cancelOrderForm), for: .touchUpInside)
            confirmButton.addTarget(self, action: #selector(OrderFormViewCell.pay), for: .touchUpInside)
            break
        
        case .paid:
            // 已付款
            topLayoutView.backgroundColor = UIColor(named: .ThemeBlue)
            statusString.text = "交易完成"
            statusString.textColor = UIColor(named: .ThemeBlue)
            cancelButton.isHidden = true
            confirmButton.isHidden = false
            confirmButton.setTitle("再次购买", for: .normal)
            confirmButton.setBackgroundImage(UIImage.withColor(UIColor(named: .ThemeRedHighlight)), for: .normal)
            confirmButton.setTitleColor(UIColor(named: .ThemeRed), for: .normal)
            confirmButton.addTarget(self, action: #selector(OrderFormViewCell.buyAgain), for: .touchUpInside)
            if let isLiveCourse = model?.isLiveCourse, isLiveCourse == true {
                cancelButton.isHidden = true
                confirmButton.isHidden = true
                break
            }
            break
        
        case .canceled:
            // 已取消
            statusString.text = "订单已关闭"
            topLayoutView.backgroundColor = UIColor(named: .Disabled)
            statusString.textColor = UIColor(named: .HeaderTitle)
            cancelButton.isHidden = true
            confirmButton.isHidden = false
            confirmButton.setTitle("重新购买", for: .normal)
            confirmButton.setBackgroundImage(UIImage.withColor(UIColor.white), for: .normal)
            confirmButton.setTitleColor(UIColor(named: .ThemeRed), for: .normal)
            confirmButton.addTarget(self, action: #selector(OrderFormViewCell.buyAgain), for: .touchUpInside)
            
            if let isLiveCourse = model?.isLiveCourse, isLiveCourse == true {
                cancelButton.isHidden = true
                confirmButton.isHidden = true
                break
            }
            break
        
        case .refund:
            // 已退款
            topLayoutView.backgroundColor = UIColor(named: .ThemeBlue)
            statusString.text = "退款成功"
            statusString.textColor = UIColor(named: .OrderGreen)
            cancelButton.isHidden = true
            confirmButton.isHidden = true
            break
            
        case .confirm:
            break
            
        default:
            break
        }
        
        if model?.isTeacherPublished == false {
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
