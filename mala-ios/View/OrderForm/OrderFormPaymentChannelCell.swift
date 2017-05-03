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
                iconView.image = UIImage(asset: .alipayIcon)
                break
            case .Wechat:
                payChannelLabel.text = "微信"
                iconView.image = UIImage(asset: .wechatIcon)
                break
            case .AliQR:
                payChannelLabel.text = "支付宝扫码支付"
                iconView.image = UIImage(asset: .qcpayIcon)
                break
            case .WxQR:
                payChannelLabel.text = "微信扫码支付"
                iconView.image = UIImage(asset: .qcpayIcon)
                break
            case .QRPay:
                payChannelLabel.text = "家长代付"
                iconView.image = UIImage(asset: .qcpayIcon)
                break
            case .WechatPub:
                payChannelLabel.text = "微信公众号支付"
                iconView.image = UIImage(asset: .wechatIcon)
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
            textColor: UIColor(named: .ThemeTextBlue)
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
            textColor: UIColor(named: .ArticleText)
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
