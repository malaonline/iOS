//
//  OrderFormOperatingView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/13.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

public protocol OrderFormOperatingViewDelegate: class {
    ///  立即支付
    func orderFormPayment()
    ///  再次购买
    func orderFormBuyAgain()
    ///  取消订单
    func orderFormCancel()
    ///  申请退费
    func requestRefund()
}


class OrderFormOperatingView: UIView {
    
    // MARK: - Property
    /// 需支付金额
    var price: Int = 0 {
        didSet{
            priceLabel.text = price.amountCNY
        }
    }
    /// 订单详情模型
    var model: OrderForm? {
        didSet {
            /// 渲染底部视图UI
            isTeacherPublished = model?.isTeacherPublished
            orderStatus = model?.orderStatus ?? .confirm
            price = isForConfirm ? MalaCurrentCourse.getAmount() ?? 0 : model?.amount ?? 0
        }
    }
    /// 标识是否为确认订单状态
    var isForConfirm: Bool = false {
        didSet {
            /// 渲染底部视图UI
            if isForConfirm {
                orderStatus = .confirm
            }
        }
    }
    /// 订单状态
    var orderStatus: MalaOrderStatus = .canceled {
        didSet {
            DispatchQueue.main.async {
                self.changeDisplayMode()
            }
        }
    }
    /// 老师上架状态标记
    var isTeacherPublished: Bool?
    weak var delegate: OrderFormOperatingViewDelegate?
    
    
    // MARK: - Components
    /// 价格容器
    private lazy var priceContainer: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// 合计标签
    private lazy var stringLabel: UILabel = {
        let label = UILabel(
            text: "合计:",
            font: FontFamily.PingFangSC.Light.font(13),
            textColor: UIColor(named: .ArticleTitle)
        )
        return label
    }()
    /// 金额标签
    private lazy var priceLabel: UILabel = {
        let label = UILabel(
            text: "￥0.00",
            font: FontFamily.PingFangSC.Light.font(18),
            textColor: UIColor(named: .ThemeRed)
        )
        return label
    }()
    /// 确定按钮（确认支付、再次购买、重新购买）
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    /// 取消按钮（取消订单）
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    
    // MARK: - Constructed
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private method
    private func setupUserInterface() {
        // Style
        backgroundColor = UIColor.white
        
        // SubViews
        addSubview(priceContainer)
        priceContainer.addSubview(stringLabel)
        priceContainer.addSubview(priceLabel)
        addSubview(cancelButton)
        addSubview(confirmButton)
        
        // Autolayout
        priceContainer.snp.makeConstraints{ (maker) -> Void in
            maker.top.equalTo(self)
            maker.left.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.44)
            maker.height.equalTo(44)
            maker.bottom.equalTo(self)
        }
        stringLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(priceLabel.snp.left)
            maker.centerY.equalTo(priceContainer)
            maker.height.equalTo(18.5)
        }
        priceLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(priceContainer)
            maker.centerX.equalTo(priceContainer).offset(17)
            maker.height.equalTo(25)
        }
        confirmButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(self)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.28)
            maker.height.equalTo(self)
        }
        cancelButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(confirmButton.snp.left)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.28)
            maker.height.equalTo(self)
        }
    }
    
    /// 根据当前订单状态，渲染对应UI样式
    private func changeDisplayMode() {
        
        // 仅当订单金额已支付, 课程类型为一对一课程时
        // 老师下架状态才会生效
        if let isLiveCourse = model?.isLiveCourse, isLiveCourse == false &&
            isTeacherPublished == false && orderStatus != .penging && orderStatus != .confirm {
            setTeacherDisable()
            return
        }
        
        switch orderStatus {
        case .penging: setOrderPending()
        case .paid: setOrderPaid()
        case .paidRefundable: setOrderPaidRefundable()
        case .finished: setOrderFinished()
        case .refunding: setOrderRefunding()
        case .refund: setOrderRefund()
        case .canceled: setOrderCanceled()
        case .confirm: setOrderConfirm()
        }
    }
    
    /// 待支付样式
    private func setOrderPending() {
        cancelButton.isHidden = false
        cancelButton.setTitle(L10n.cancelOrder, for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setBackgroundImage(UIImage.withColor(UIColor(named: .ThemeBlue)), for: .normal)
        cancelButton.addTarget(self, action: #selector(OrderFormOperatingView.cancelOrderForm), for: .touchUpInside)
        
        setButton("去支付", UIColor(named: .ThemeBlue), enabled: false, action: #selector(OrderFormOperatingView.pay), relayout: false)
    }
    
    /// 进行中不可退费样式(only for private tuition)
    private func setOrderPaid() {
        setButton("再次购买", UIColor(named: .ThemeRed), action: #selector(OrderFormOperatingView.buyAgain))
    }
    
    /// 进行中可退费样式(only for live course)
    private func setOrderPaidRefundable() {
        setButton("申请退费", UIColor(named: .ThemeGreen), action: #selector(OrderFormOperatingView.requestRefund))
    }
    
    /// 已完成样式(only for live course)
    private func setOrderFinished() {
        setButton("再次购买", UIColor(named: .ThemeRed), hidden: true, action: #selector(OrderFormOperatingView.buyAgain))
        cancelButton.isHidden = true
    }
    
    /// 退费审核中样式(only for live course)
    private func setOrderRefunding() {
        setButton("审核中...", UIColor(named: .Disabled), enabled: false)
    }
    
    /// 已退费样式
    private func setOrderRefund() {
        setButton("已退费", UIColor(named: .ThemeGreen), enabled: false)
    }
    
    /// 已取消样式
    private func setOrderCanceled() {
        var color = UIColor(named: .Disabled)
        var action: Selector?
        var enable = true
        var string = "重新购买"
        
        if let isLive = model?.isLiveCourse, isLive == true {
            string = "订单已关闭"
            enable = false
        }else {
            color = UIColor(named: .ThemeRed)
            action = #selector(OrderFormOperatingView.buyAgain)
        }
        setButton(string, color, enabled: enable, action: action)
    }
    
    /// 订单预览样式
    private func setOrderConfirm() {
        setButton("提交订单", UIColor(named: .ThemeRed), action: #selector(OrderFormOperatingView.pay))
    }
    
    /// 教师已下架样式
    private func setTeacherDisable() {
        setButton("该老师已下架", UIColor(named: .Disabled), enabled: false)
    }
    
    private func setButton( _ title: String, _ bgColor: UIColor, _ titleColor: UIColor = UIColor.white, enabled: Bool? = nil, hidden: Bool = false,
                            action: Selector? = nil, relayout: Bool = true) {
        cancelButton.isHidden = true
        confirmButton.isHidden = false
        
        confirmButton.isHidden = hidden
        if let enabled = enabled {
            confirmButton.isEnabled = enabled
        }
        if let action = action {
            confirmButton.addTarget(self, action: action, for: .touchUpInside)
        }
        
        confirmButton.setTitle(title, for: .normal)
        confirmButton.setBackgroundImage(UIImage.withColor(bgColor), for: .normal)
        confirmButton.setTitleColor(titleColor, for: .normal)
        
        guard relayout == true else { return }
        
        confirmButton.snp.remakeConstraints { (maker) in
            maker.right.equalTo(self)
            maker.centerY.equalTo(self)
            maker.width.equalTo(self).multipliedBy(0.5)
            maker.height.equalTo(self)
        }
    }
    
    
    // MARK: - Event Response
    /// 立即支付
    @objc func pay() {
        delegate?.orderFormPayment()
    }
    /// 再次购买
    @objc func buyAgain() {
        delegate?.orderFormBuyAgain()
    }
    /// 取消订单
    @objc func cancelOrderForm() {
        delegate?.orderFormCancel()
    }
    /// 申请退费
    @objc func requestRefund() {
        delegate?.requestRefund()
    }
    
    
    deinit {
        println("Order Form Operation View Deinit")
    }
}
