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
    func OrderFormPayment()
    ///  再次购买
    func OrderFormBuyAgain()
    ///  取消订单
    func OrderFormCancel()
}


class OrderFormOperatingView: UIView {
    
    // MARK: - Property
    /// 需支付金额
    var price: Int = 0 {
        didSet{
            self.priceLabel.text = price.amountCNY
        }
    }
    /// 订单状态
    var orderStatus: MalaOrderStatus = .Canceled {
        didSet {
            DispatchQueue.main.async(execute: { [weak self] () -> Void in
                self?.changeDisplayMode()
            })
        }
    }
    /// 老师上架状态标记
    var isTeacherPublished: Bool? {
        didSet {
            // 设置老师下架状态
            disabledLabel.isHidden = !(isTeacherPublished == false)
        }
    }
    weak var delegate: OrderFormOperatingViewDelegate?
    
    
    // MARK: - Components
    private lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.4
        return view
    }()
    /// 价格说明标签
    private lazy var stringLabel: UILabel = {
        let stringLabel = UILabel()
        stringLabel.font = UIFont.systemFont(ofSize: 14)
        stringLabel.textColor = MalaColor_333333_0
        stringLabel.text = "合计:"
        return stringLabel
    }()
    /// 金额标签
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = MalaColor_E26254_0
        priceLabel.textAlignment = .left
        priceLabel.text = "￥0.00"
        return priceLabel
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
        button.addTarget(self, action: #selector(OrderFormOperatingView.buyAgain), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(OrderFormOperatingView.cancelOrderForm), for: .touchUpInside)
        return button
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
        self.backgroundColor = UIColor.white
        
        // SubViews
        addSubview(topLine)
        addSubview(stringLabel)
        addSubview(priceLabel)
        addSubview(cancelButton)
        addSubview(confirmButton)
        addSubview(disabledLabel)
        
        // Autolayout
        topLine.snp.makeConstraints({ (maker) -> Void in
            maker.top.equalTo(self.snp.top)
            maker.left.equalTo(self.snp.left)
            maker.right.equalTo(self.snp.right)
            maker.height.equalTo(MalaScreenOnePixel)
        })
        stringLabel.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(self.snp.left).offset(12)
            maker.centerY.equalTo(self.snp.centerY)
            maker.height.equalTo(14)
        }
        priceLabel.snp.makeConstraints { (maker) -> Void in
            maker.left.equalTo(stringLabel.snp.right)
            maker.width.equalTo(100)
            maker.bottom.equalTo(stringLabel.snp.bottom)
            maker.height.equalTo(14)
        }
        confirmButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-12)
            maker.centerY.equalTo(self.snp.centerY)
            maker.width.equalTo(confirmButton.snp.height).multipliedBy(2.78)
            maker.height.equalTo(self.snp.height).multipliedBy(0.55)
        }
        cancelButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(confirmButton.snp.left).offset(-10)
            maker.centerY.equalTo(confirmButton.snp.centerY)
            maker.width.equalTo(confirmButton.snp.height).multipliedBy(2.78)
            maker.height.equalTo(self.snp.height).multipliedBy(0.55)
        }
        disabledLabel.snp.makeConstraints { (maker) in
            maker.center.equalTo(confirmButton)
        }
    }
    
    /// 根据当前订单状态，渲染对应UI样式
    private func changeDisplayMode() {
        
        // 解除绑定事件
        cancelButton.removeTarget(self, action: #selector(OrderFormOperatingView.cancelOrderForm), for: .touchUpInside)
        confirmButton.removeTarget(self, action: #selector(OrderFormOperatingView.pay), for: .touchUpInside)
        confirmButton.removeTarget(self, action: #selector(OrderFormOperatingView.buyAgain), for: .touchUpInside)
        
        // 渲染UI样式
        switch orderStatus {
        case .Penging:
            
            // 待付款
            cancelButton.isHidden = false
            confirmButton.isHidden = false
            
            confirmButton.setTitleColor(MalaColor_E26254_0, for: UIControlState())
            
            confirmButton.setTitle("立即支付", for: UIControlState())
            confirmButton.setBackgroundImage(UIImage.withColor(MalaColor_E26254_0), for: UIControlState())
            confirmButton.setTitleColor(UIColor.white, for: UIControlState())
            
            cancelButton.addTarget(self, action: #selector(OrderFormOperatingView.cancelOrderForm), for: .touchUpInside)
            confirmButton.addTarget(self, action: #selector(OrderFormOperatingView.pay), for: .touchUpInside)
            break
            
        case .Paid:
            
            // 已付款
            cancelButton.isHidden = true
            confirmButton.isHidden = false
            
            confirmButton.setTitle("再次购买", for: UIControlState())
            confirmButton.setBackgroundImage(UIImage.withColor(UIColor.white), for: UIControlState())
            confirmButton.setTitleColor(MalaColor_E26254_0, for: UIControlState())
            
            confirmButton.addTarget(self, action: #selector(OrderFormOperatingView.buyAgain), for: .touchUpInside)
            break
            
        case .Canceled:
            
            // 已取消
            cancelButton.isHidden = true
            confirmButton.isHidden = false
            
            confirmButton.setTitle("再次购买", for: UIControlState())
            confirmButton.setBackgroundImage(UIImage.withColor(UIColor.white), for: UIControlState())
            confirmButton.setTitleColor(MalaColor_E26254_0, for: UIControlState())
            
            confirmButton.addTarget(self, action: #selector(OrderFormOperatingView.buyAgain), for: .touchUpInside)
            break
            
        case .Refund:
            
            // 已退款
            cancelButton.isHidden = true
            confirmButton.isHidden = true
            break
            
        case .Confirm:
            
            // 确认订单
            cancelButton.isHidden = true
            confirmButton.isHidden = false
            
            confirmButton.setTitle("提交订单", for: UIControlState())
            confirmButton.setTitleColor(MalaColor_E26254_0, for: UIControlState())
            confirmButton.addTarget(self, action: #selector(OrderFormOperatingView.pay), for: .touchUpInside)
            break
        }
        
        if isTeacherPublished == false {
            cancelButton.isHidden = true
            confirmButton.isHidden = true
        }
    }
    
    
    // MARK: - Event Response
    /// 立即支付（确认订单页－提交订单）
    @objc func pay() {
        delegate?.OrderFormPayment()
    }
    /// 再次购买
    @objc func buyAgain() {
        delegate?.OrderFormBuyAgain()
    }
    /// 取消订单
    @objc func cancelOrderForm() {
        delegate?.OrderFormCancel()
    }
}
