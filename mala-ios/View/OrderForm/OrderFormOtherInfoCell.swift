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
            
            guard let model = model else {
                return
            }
            
            /// 订单状态
            if let status = MalaOrderStatus(rawValue: (model.status ?? "")) {
                switch status {
                // 待付款、已退款状态时，不显示支付时间
                case .Penging, .Canceled:
                    
                    paymentDateString.isHidden = true
                    paymentDateLabel.isHidden = true
                    
                    createDateString.snp.remakeConstraints { (maker) -> Void in
                        maker.top.equalTo(titleString.snp.bottom).offset(10)
                        maker.left.equalTo(titleString)
                        maker.height.equalTo(12)
                        maker.bottom.equalTo(contentView).offset(-16)
                    }
                    break
                default:
                    break
                }
            }
            
            titleLabel.text = model.order_id ?? "-"
            createDateLabel.text = getDateTimeString(model.createAt ?? 0)
            paymentDateLabel.text = getDateTimeString(model.paidAt ?? 0)
        }
    }
    
    
    // MARK: - Components
    /// 布局容器
    private lazy var content: UIView = {
        let view = UIView(UIColor.white)
        return view
    }()
    /// 订单编号
    private lazy var titleString: UILabel = {
        let label = UILabel(
            text: "订单编号：",
            fontSize: 12,
            textColor: MalaColor_939393_0
        )
        return label
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            fontSize: 12,
            textColor: MalaColor_939393_0
        )
        return label
    }()
    /// 创建时间
    private lazy var createDateString: UILabel = {
        let label = UILabel(
            text: "创建时间：",
            fontSize: 12,
            textColor: MalaColor_939393_0
        )
        return label
    }()
    private lazy var createDateLabel: UILabel = {
        let label = UILabel(
            fontSize: 12,
            textColor: MalaColor_939393_0
        )
        return label
    }()
    /// 支付时间
    private lazy var paymentDateString: UILabel = {
        let label = UILabel(
            text: "支付时间：",
            fontSize: 12,
            textColor: MalaColor_939393_0
        )
        return label
    }()
    private lazy var paymentDateLabel: UILabel = {
        let label = UILabel(
            fontSize: 12,
            textColor: MalaColor_939393_0
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
        contentView.backgroundColor = MalaColor_EDEDED_0
        
        // SubViews
        contentView.addSubview(content)
        content.addSubview(titleString)
        content.addSubview(titleLabel)
        content.addSubview(createDateString)
        content.addSubview(createDateLabel)
        content.addSubview(paymentDateString)
        content.addSubview(paymentDateLabel)
        
        // Autolayout
        content.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView)
            maker.left.equalTo(contentView).offset(12)
            maker.right.equalTo(contentView).offset(-12)
            maker.bottom.equalTo(contentView)
        }
        titleString.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(content).offset(16)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(12)
        }
        titleLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(titleString)
            maker.left.equalTo(titleString.snp.right).offset(10)
            maker.height.equalTo(12)
        }
        createDateString.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(titleString.snp.bottom).offset(10)
            maker.left.equalTo(titleString)
            maker.height.equalTo(12)
            maker.bottom.equalTo(paymentDateString.snp.bottom).offset(-16)
        }
        createDateLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(createDateString)
            maker.left.equalTo(createDateString.snp.right).offset(10)
            maker.height.equalTo(12)
        }
        paymentDateString.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(createDateString.snp.bottom).offset(10)
            maker.left.equalTo(titleString)
            maker.height.equalTo(12)
            maker.bottom.equalTo(contentView).offset(-16)
        }
        paymentDateLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(paymentDateString)
            maker.left.equalTo(paymentDateString.snp.right).offset(10)
            maker.height.equalTo(12)
        }
    }
}
