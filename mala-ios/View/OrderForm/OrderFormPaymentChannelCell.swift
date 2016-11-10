//
//  OrderFormPaymentChannelCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/13.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class OrderFormPaymentChannelCell: UITableViewCell {

    // MARK: - Property
    /// 支付方式
    var channel: MalaPaymentChannel = .Other {
        didSet {
            switch channel {
            case .Alipay:
                payChannelLabel.text = "支付宝"
                iconView.image = UIImage(named: "alipay_icon")
                break
            case .Wechat:
                payChannelLabel.text = "微信"
                iconView.image = UIImage(named: "wechat_icon")
                break
            case .QCPay:
                payChannelLabel.text = "家长代付"
                iconView.image = UIImage(named: "qcpay_icon")
                break
            case .Other:
                payChannelLabel.text = "其他支付方式"
                break
            }
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
            text: "支付方式",
            fontSize: 15,
            textColor: MalaColor_333333_0
        )
        return label
    }()
    /// 支付渠道icon
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    /// 支付渠道
    private lazy var payChannelLabel: UILabel = {
        let label = UILabel(
            text: "支付方式",
            fontSize: 13,
            textColor: MalaColor_636363_0
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
        contentView.backgroundColor = MalaColor_F2F2F2_0
        
        // SubViews
        contentView.addSubview(content)
        content.addSubview(titleLabel)
        content.addSubview(iconView)
        content.addSubview(payChannelLabel)
        
        // Autolayout
        content.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView)
            maker.left.equalTo(contentView).offset(12)
            maker.right.equalTo(contentView).offset(-12)
            maker.bottom.equalTo(contentView)
            maker.height.equalTo(44)
        }
        titleLabel.snp.updateConstraints { (maker) -> Void in
            maker.centerY.equalTo(content)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(17)
        }
        iconView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(content)
            maker.right.equalTo(payChannelLabel.snp.left).offset(-5)
            maker.width.equalTo(22)
            maker.height.equalTo(22)
        }
        payChannelLabel.snp.updateConstraints { (maker) -> Void in
            maker.centerY.equalTo(content)
            maker.right.equalTo(content).offset(-12)
            maker.height.equalTo(21)
        }
    }
}
