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
            orderIdLabel.text = "订单编号：" + (model?.orderId ?? "")
            subjectLabel.attributedText = model?.orderCourseInfoAttr
            schoolLabel.attributedText = model?.orderSchoolAttr
            amountLabel.attributedText = model?.orderAmountPriceAttr
            
            // 订单状态
            if let status = model?.status, let orderStatus = MalaOrderStatus(rawValue: status) {
                self.orderStatus = orderStatus
            }
            // 根据课程类型加载数据
            if let isLive = model?.isLiveCourse, isLive == true {
                setupLiveCourseOrderInfo()
            }else {
                setupPrivateTuitionOrderInfo()
            }
            // 仅课程类型为一对一课程时,老师下架状态才会生效
            if let isLiveCourse = model?.isLiveCourse, isLiveCourse == false  {
                disabledLabel.isHidden = !(model?.isTeacherPublished == false)
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
    /// container card
    lazy var cardContent: UIView = {
        let view = UIView(UIColor.white)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    lazy var contentShadow: UIView = {
        let view = UIView(UIColor.clear)
        view.layer.shadowColor = UIColor(named: .themeShadowBlue).cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1.0
        return view
    }()
    /// 顶部订单编号布局容器
    private lazy var topLayoutView: UIView = {
        let view = UIView(UIColor(named: .ThemeBlue))
        return view
    }()
    /// 订单编号
    private lazy var orderIdLabel: UILabel = {
        let label = UILabel(
            text: "订单编号：",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor.white
        )
        return label
    }()
    /// 订单状态
    private lazy var statusLabel: UILabel = {
        let label = UILabel(
            text: "订单状态",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor.white
        )
        return label
    }()
    /// 老师姓名
    private lazy var teacherNameLabel: UILabel = {
        let label = UILabel(
            text: "教师姓名：",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .ArticleTitle)
        )
        return label
    }()
    /// "课程名称"文字
    private lazy var subjectLabel: UILabel = {
        let label = UILabel(
            text: "课程名称：",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .ArticleTitle)
        )
        return label
    }()
    /// "上课地点"文字
    private lazy var schoolLabel: UILabel = {
        let label = UILabel(
            text: "上课地点：",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .ArticleTitle)
        )
        return label
    }()
    /// lecturer-avatar background
    private lazy var avatarBackground: UIView = {
        let view = UIView(UIColor(named: .LiveAvatarBack), cornerRadius: 58/2)
        return view
    }()
    /// lecturer-avatar
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView(cornerRadius: 54/2, image: "avatar_placeholder")
        return imageView
    }()
    /// 双师直播课程头像
    private lazy var liveCourseAvatarView: LiveCourseAvatarView = {
        let view = LiveCourseAvatarView()
        return view
    }()
    /// 中部分割线
    private lazy var separatorLine: UIView = {
        let view = UIView(UIColor(named: .themeLightBlue))
        return view
    }()
    /// 金额
    private lazy var amountLabel: UILabel = {
        let label = UILabel(
            text: "共    计：",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .livePriceRed)
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
        
        button.layer.borderColor = UIColor(named: .livePriceRed).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        
        button.titleLabel?.font = FontFamily.PingFangSC.Regular.font(18)
        button.setTitle("再次购买", for: .normal)
        button.setTitleColor(UIColor(named: .livePriceRed), for: .normal)
        button.setBackgroundImage(UIImage.withColor(UIColor.white), for: .normal)
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .livePriceRedHighlight)), for: .highlighted)
        button.addTarget(self, action: #selector(OrderFormViewCell.buyAgain), for: .touchUpInside)
        return button
    }()
    /// 取消按钮（取消订单）
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        button.layer.borderColor = UIColor(named: .HeaderTitle).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        
        button.titleLabel?.font = FontFamily.PingFangSC.Regular.font(18)
        button.setTitle(L10n.cancelOrder, for: .normal)
        button.setTitleColor(UIColor(named: .HeaderTitle), for: .normal)
        button.setBackgroundImage(UIImage.withColor(UIColor.white), for: .normal)
        button.setBackgroundImage(UIImage.withColor(UIColor(named: .protocolGaryHighlight)), for: .highlighted)
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
        contentView.addSubview(contentShadow)
        contentShadow.addSubview(cardContent)
        
        cardContent.addSubview(topLayoutView)
        topLayoutView.addSubview(orderIdLabel)
        topLayoutView.addSubview(statusLabel)
        
        cardContent.addSubview(teacherNameLabel)
        cardContent.addSubview(subjectLabel)
        cardContent.addSubview(schoolLabel)
        cardContent.addSubview(amountLabel)
        cardContent.addSubview(avatarBackground)
        avatarBackground.addSubview(avatarView)
        cardContent.addSubview(liveCourseAvatarView)
        
        cardContent.addSubview(separatorLine)
        cardContent.addSubview(confirmButton)
        cardContent.addSubview(cancelButton)
        cardContent.addSubview(disabledLabel)
        
        // Autolayout
        contentShadow.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(0)
            maker.left.equalTo(contentView).offset(10)
            maker.bottom.equalTo(contentView).offset(-10)
            maker.right.equalTo(contentView).offset(-10)
        }
        cardContent.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentShadow)
            maker.left.equalTo(contentShadow)
            maker.right.equalTo(contentShadow)
            maker.bottom.equalTo(contentShadow)
        }
        topLayoutView.snp.makeConstraints { (maker) in
            maker.top.equalTo(cardContent)
            maker.left.equalTo(cardContent)
            maker.right.equalTo(cardContent)
            maker.height.equalTo(40)
            maker.bottom.equalTo(teacherNameLabel.snp.top).offset(-20)
        }
        orderIdLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(topLayoutView).offset(10)
            maker.centerY.equalTo(topLayoutView)
            maker.height.equalTo(14)
        }
        statusLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(topLayoutView)
            maker.right.equalTo(cardContent).offset(-24)
            maker.height.equalTo(14)
        }
        teacherNameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(topLayoutView.snp.bottom).offset(20)
            maker.left.equalTo(cardContent).offset(10)
            maker.height.equalTo(14)
            maker.bottom.equalTo(subjectLabel.snp.top).offset(-14)
        }
        subjectLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(teacherNameLabel.snp.bottom).offset(14)
            maker.left.equalTo(teacherNameLabel)
            maker.height.equalTo(14)
            maker.bottom.equalTo(schoolLabel.snp.top).offset(-14)
        }
        schoolLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(subjectLabel.snp.bottom).offset(14)
            maker.left.equalTo(teacherNameLabel)
            maker.height.equalTo(14)
            maker.bottom.equalTo(amountLabel.snp.top).offset(-14)
        }
        amountLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(schoolLabel.snp.bottom).offset(14)
            maker.left.equalTo(teacherNameLabel)
            maker.height.equalTo(14)
            maker.bottom.equalTo(separatorLine.snp.top).offset(-20)
        }
        avatarBackground.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(statusLabel)
            maker.centerY.equalTo(subjectLabel.snp.bottom).offset(5)
            maker.height.equalTo(58)
            maker.width.equalTo(58)
        }
        avatarView.snp.makeConstraints { (maker) in
            maker.center.equalTo(avatarBackground)
            maker.height.equalTo(54)
            maker.width.equalTo(54)
        }
        liveCourseAvatarView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(statusLabel)
            maker.centerY.equalTo(schoolLabel)
            maker.width.equalTo(72)
            maker.height.equalTo(45)
        }
        separatorLine.snp.makeConstraints { (maker) in
            maker.top.equalTo(amountLabel.snp.bottom).offset(20)
            maker.left.equalTo(cardContent)
            maker.right.equalTo(cardContent)
            maker.height.equalTo(1)
        }
        confirmButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(separatorLine.snp.bottom).offset(10)
            maker.bottom.equalTo(cardContent).offset(-10)
            maker.width.equalTo(120)
            maker.height.equalTo(34)
            maker.centerX.equalTo(cardContent.snp.right).multipliedBy(0.754)
        }
        disabledLabel.snp.makeConstraints { (maker) in
            maker.center.equalTo(confirmButton)
        }
        cancelButton.snp.makeConstraints { (maker) in
            maker.width.equalTo(120)
            maker.height.equalTo(34)
            maker.centerY.equalTo(confirmButton)
            maker.centerX.equalTo(cardContent.snp.right).multipliedBy(0.246)
        }
    }
    
    /// 加载一对一课程订单数据
    private func setupPrivateTuitionOrderInfo() {
        // 显示老师信息
        teacherNameLabel.snp.remakeConstraints { (maker) in
            maker.top.equalTo(topLayoutView.snp.bottom).offset(20)
            maker.left.equalTo(cardContent).offset(10)
            maker.height.equalTo(14)
        }
        subjectLabel.snp.remakeConstraints { (maker) in
            maker.top.equalTo(teacherNameLabel.snp.bottom).offset(14)
            maker.left.equalTo(teacherNameLabel)
            maker.height.equalTo(14)
        }
        avatarBackground.isHidden = false
        liveCourseAvatarView.isHidden = true
        
        teacherNameLabel.attributedText = model?.orderTeacherNameAttr
        avatarView.setImage(withURL: model?.avatarURL)

    }
    
    /// 加载双师直播课程订单数据
    private func setupLiveCourseOrderInfo() {
        // 隐藏老师信息
        teacherNameLabel.snp.remakeConstraints { (maker) in
            maker.top.equalTo(topLayoutView.snp.bottom).offset(20)
            maker.left.equalTo(cardContent).offset(10)
            maker.height.equalTo(0)
        }
        subjectLabel.snp.remakeConstraints { (maker) in
            maker.top.equalTo(topLayoutView.snp.bottom).offset(20)
            maker.left.equalTo(teacherNameLabel)
            maker.height.equalTo(14)
        }
        avatarBackground.isHidden = true
        liveCourseAvatarView.isHidden = false
        
        subjectLabel.attributedText = model?.orderLiveCourseNameAttr
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
            topLayoutView.backgroundColor = UIColor(named: .orderLightRed)
            orderIdLabel.alpha = 0.5
            statusLabel.text = "订单待支付"
            cancelButton.isHidden = false
            cancelButton.addTarget(self, action: #selector(OrderFormViewCell.cancelOrderForm), for: .touchUpInside)
            confirmButton.isHidden = false
            confirmButton.setTitle("立即支付", for: .normal)
            confirmButton.layer.borderColor = UIColor(named: .livePriceRed).cgColor
            confirmButton.setBackgroundImage(UIImage.withColor(UIColor.white), for: .normal)
            confirmButton.setBackgroundImage(UIImage.withColor(UIColor(named: .livePriceRedHighlight)), for: .highlighted)
            confirmButton.setTitleColor(UIColor(named: .livePriceRed), for: .normal)
            confirmButton.addTarget(self, action: #selector(OrderFormViewCell.pay), for: .touchUpInside)
            showButtonPanel()
            break
        
        case .paid:
            // 已付款
            topLayoutView.backgroundColor = UIColor(named: .indexBlue)
            orderIdLabel.alpha = 0.5
            statusLabel.text = "交易完成"
            cancelButton.isHidden = true
            confirmButton.isHidden = false
            confirmButton.setTitle("再次购买", for: .normal)
            confirmButton.setTitleColor(UIColor(named: .indexBlue), for: .normal)
            confirmButton.layer.borderColor = UIColor(named: .indexBlue).cgColor
            confirmButton.setBackgroundImage(UIImage.withColor(UIColor.white), for: .normal)
            confirmButton.setBackgroundImage(UIImage.withColor(UIColor(named: .indexBlueClear)), for: .highlighted)
            confirmButton.addTarget(self, action: #selector(OrderFormViewCell.buyAgain), for: .touchUpInside)
            if let isLiveCourse = model?.isLiveCourse, isLiveCourse == true {
                cancelButton.isHidden = true
                confirmButton.isHidden = true
                hideButtonPanel()
            }else {
                showButtonPanel(onlyOneButton: true)
            }
            break
        
        case .canceled:
            // 已取消
            topLayoutView.backgroundColor = UIColor(named: .orderDisabledGray)
            orderIdLabel.alpha = 1
            statusLabel.text = "订单已关闭"
            cancelButton.isHidden = true
            confirmButton.isHidden = false
            confirmButton.setTitle("重新购买", for: .normal)
            confirmButton.setBackgroundImage(UIImage.withColor(UIColor.white), for: .normal)
            confirmButton.setTitleColor(UIColor(named: .ThemeRed), for: .normal)
            confirmButton.addTarget(self, action: #selector(OrderFormViewCell.buyAgain), for: .touchUpInside)
            
            if let isLiveCourse = model?.isLiveCourse, isLiveCourse == true {
                cancelButton.isHidden = true
                confirmButton.isHidden = true
                hideButtonPanel()
            }else {
                showButtonPanel(onlyOneButton: true)
            }
            break
        
        case .refund:
            // 已退款
            topLayoutView.backgroundColor = UIColor(named: .indexBlue)
            orderIdLabel.alpha = 0.5
            statusLabel.text = "退款成功"
            cancelButton.isHidden = true
            confirmButton.isHidden = true
            
            hideButtonPanel()
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
    
    
    private func hideButtonPanel() {
        separatorLine.snp.remakeConstraints { (maker) in
            maker.top.equalTo(amountLabel.snp.bottom).offset(20)
            maker.left.equalTo(cardContent)
            maker.right.equalTo(cardContent)
            maker.height.equalTo(1)
            maker.bottom.equalTo(cardContent)
        }
        confirmButton.snp.remakeConstraints { (maker) in
            maker.top.equalTo(separatorLine.snp.bottom).offset(10)
            maker.width.equalTo(120)
            maker.height.equalTo(34)
            maker.centerX.equalTo(cardContent.snp.right).multipliedBy(0.754)
        }
        cancelButton.snp.remakeConstraints { (maker) in
            maker.width.equalTo(120)
            maker.height.equalTo(34)
            maker.centerY.equalTo(confirmButton)
            maker.centerX.equalTo(cardContent.snp.right).multipliedBy(0.246)
        }
    }
    
    private func showButtonPanel(onlyOneButton: Bool = false) {
        separatorLine.snp.remakeConstraints { (maker) in
            maker.top.equalTo(amountLabel.snp.bottom).offset(20)
            maker.left.equalTo(cardContent)
            maker.right.equalTo(cardContent)
            maker.height.equalTo(1)
        }
        
        disabledLabel.snp.remakeConstraints { (maker) in
            maker.center.equalTo(confirmButton)
        }
        cancelButton.snp.remakeConstraints { (maker) in
            maker.width.equalTo(120)
            maker.height.equalTo(34)
            maker.centerY.equalTo(confirmButton)
            maker.centerX.equalTo(cardContent.snp.right).multipliedBy(0.246)
        }
        
        if onlyOneButton {
            confirmButton.snp.remakeConstraints { (maker) in
                maker.top.equalTo(separatorLine.snp.bottom).offset(10)
                maker.bottom.equalTo(cardContent).offset(-10)
                maker.width.equalTo(120)
                maker.height.equalTo(34)
                maker.centerX.equalTo(cardContent)
            }
        }else {
            confirmButton.snp.remakeConstraints { (maker) in
                maker.top.equalTo(separatorLine.snp.bottom).offset(10)
                maker.bottom.equalTo(cardContent).offset(-10)
                maker.width.equalTo(120)
                maker.height.equalTo(34)
                maker.centerX.equalTo(cardContent.snp.right).multipliedBy(0.754)
            }
        }
    }
    
    // MARK: - Override
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        cancelButton.hidden = false
//        confirmButton.hidden = false
//        disabledLabel.hidden = false
    }
}
