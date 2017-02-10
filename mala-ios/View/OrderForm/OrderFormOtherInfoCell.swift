//
//  OrderFormOtherInfoCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/13.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class OrderFormOtherInfoCell: UITableViewCell {

    // MARK: - Property
    /// 订单详情模型
    var model: OrderForm? {
        didSet {
            
            guard let model = model else { return }
            
            /// 订单状态
            if let status = MalaOrderStatus(rawValue: (model.status ?? "")) {
                switch status {
                // 待付款、已退款状态时，不显示支付时间
                case .penging, .canceled:
                    
                    paymentAtLabel.isHidden = true
                    
                    createAtLabel.snp.remakeConstraints { (maker) -> Void in
                        maker.top.equalTo(orderCodeLabel.snp.bottom).offset(12)
                        maker.left.equalTo(orderCodeLabel)
                        maker.height.equalTo(orderCodeLabel)
                        maker.bottom.equalTo(contentView).offset(-15.5)
                    }
                    break
                default:
                    break
                }
            }
            
            orderCodeLabel.text = String(format: "订单编号：%@", (model.orderId ?? "-"))
            createAtLabel.text = String(format: "创建时间：%@", getDateTimeString(model.createdAt ?? 0))
            paymentAtLabel.text = String(format: "支付时间：%@", getDateTimeString(model.paidAt ?? 0))
        }
    }
    
    
    // MARK: - Components
    /// 布局容器
    private lazy var content: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// 订单编号
    private lazy var orderCodeLabel: UILabel = {
        let label = UILabel(
            text: "订单编号：",
            font: UIFont(name: "PingFang-SC-Regular", size: 13),
            textColor: UIColor(named: .HeaderTitle),
            opacity: 0.8
        )
        return label
    }()
    /// 创建时间
    private lazy var createAtLabel: UILabel = {
        let label = UILabel(
            text: "创建时间：",
            font: UIFont(name: "PingFang-SC-Regular", size: 13),
            textColor: UIColor(named: .HeaderTitle),
            opacity: 0.8
        )
        return label
    }()
    /// 支付时间
    private lazy var paymentAtLabel: UILabel = {
        let label = UILabel(
            text: "支付时间：",
            font: UIFont(name: "PingFang-SC-Regular", size: 13),
            textColor: UIColor(named: .HeaderTitle),
            opacity: 0.8
        )
        return label
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
        contentView.backgroundColor = UIColor(named: .CardBackground)
        
        // SubViews
        contentView.addSubview(content)
        content.addSubview(orderCodeLabel)
        content.addSubview(createAtLabel)
        content.addSubview(paymentAtLabel)
        
        // Autolayout
        content.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView)
            maker.left.equalTo(contentView).offset(12)
            maker.right.equalTo(contentView).offset(-12)
            maker.bottom.equalTo(contentView)
        }
        orderCodeLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(content).offset(18)
            maker.left.equalTo(content).offset(13)
            maker.height.equalTo(14)
        }
        createAtLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(orderCodeLabel.snp.bottom).offset(12)
            maker.left.equalTo(orderCodeLabel)
            maker.height.equalTo(orderCodeLabel)
            maker.bottom.equalTo(paymentAtLabel.snp.top).offset(-12)
        }
        paymentAtLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(createAtLabel.snp.bottom).offset(12)
            maker.left.equalTo(orderCodeLabel)
            maker.height.equalTo(orderCodeLabel)
            maker.bottom.equalTo(contentView).offset(-15.5)
        }
    }
}
