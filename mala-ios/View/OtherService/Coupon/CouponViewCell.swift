//
//  CouponViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 3/3/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class CouponViewCell: UITableViewCell {
    
    // MARK: - Property
    /// 奖学金模型
    var model: CouponModel? {
        didSet {
            
            guard let model = model, let status = model.status else {
                return
            }
            
            // 设置奖学金对象模型数据
            priceLabel.text = model.amountString
            titleLabel.text = model.minPriceString
            validityTermLabel.text = model.expiredString
            selectedView.isHidden = true
            
            // 根据奖学金状态渲染UI
            switch status {
            case .used:
                // 已使用
                setStyleUsed()
                break
                
            case .unused:
                // 未使用
                setStyleUnused()
                break
                
            case .expired:
                // 已过期
                setStyleExpired()
                break
                
            case .disabled:
                // 已冻结
                disabled = true
                break
            }
        }
    }
    // 是否显示[选中指示器]标识
    var showSelectedIndicator: Bool = false {
        didSet {
            self.selectedView.isHidden = !showSelectedIndicator
        }
    }
    /// 是否被冻结
    var disabled: Bool = false {
        didSet {
            if disabled {
                setStyleDisable()
            }
        }
    }
    
    
    // MARK: - Components
    /// 顶部分隔线视图
    private lazy var separatorView: UIView = {
        let view = UIView()
        return view
    }()
    /// 主要布局容器
    private lazy var content: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "coupon_valid"))
        return imageView
    }()
    /// 左侧布局容器
    private lazy var leftLayoutView: UIView = {
        let view = UIView()
        return view
    }()
    /// 右侧布局容器
    private lazy var rightLayoutView: UIView = {
        let view = UIView()
        return view
    }()
    /// 货币符号标签
    private lazy var moneySymbol: UILabel = {
        let label = UILabel(
            text: "￥",
            fontSize: 17,
            textColor: UIColor.white
        )
        return label
    }()
    /// 价格文本框
    private lazy var priceLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 37,
            textColor: UIColor.white
        )
        // label.font = UIFont(name: "Damascus", size: 37)
        return label
    }()
    /// 标题标签
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 17,
            textColor: MalaColor_6DB2E5_0
        )
        return label
    }()
    /// 有效期标签
    private lazy var validityTermLabel: UILabel = {
        let label = UILabel(
            text: "",
            fontSize: 13,
            textColor: MalaColor_999999_0
        )
        return label
    }()
    /// 状态标识图标
    private lazy var statusIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "coupon_expired"))
        imageView.isHidden = true
        return imageView
    }()
    /// 选中效果箭头
    lazy var selectedView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "coupon_selected"))
        imageView.isHidden = true
        return imageView
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
        content.addSubview(leftLayoutView)
        content.addSubview(rightLayoutView)
        
        leftLayoutView.addSubview(moneySymbol)
        leftLayoutView.addSubview(priceLabel)
        rightLayoutView.addSubview(titleLabel)
        rightLayoutView.addSubview(selectedView)
        rightLayoutView.addSubview(validityTermLabel)
        rightLayoutView.addSubview(statusIcon)

        // Autolayout
        separatorView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(self.contentView.snp.top)
            maker.left.equalTo(self.contentView.snp.left).offset(12)
            maker.bottom.equalTo(content.snp.top)
            maker.right.equalTo(self.contentView.snp.right).offset(-12)
            maker.height.equalTo(8)
        }
        content.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(separatorView.snp.bottom)
            maker.left.equalTo(self.contentView.snp.left).offset(12)
            maker.bottom.equalTo(self.contentView.snp.bottom)
            maker.right.equalTo(self.contentView.snp.right).offset(-12)
        }
        leftLayoutView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(content.snp.top)
            maker.bottom.equalTo(content.snp.bottom)
            maker.left.equalTo(content.snp.left)
            maker.width.equalTo(content.snp.width).multipliedBy(0.2865)
        }
        rightLayoutView.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(content.snp.top)
            maker.bottom.equalTo(content.snp.bottom)
            maker.left.equalTo(leftLayoutView.snp.right)
            maker.right.equalTo(content.snp.right)
        }
        moneySymbol.snp.makeConstraints { (maker) -> Void in
            maker.right.equalTo(priceLabel.snp.left)
            maker.bottom.equalTo(priceLabel.snp.bottom).offset(-4)
            maker.height.equalTo(17)
        }
        priceLabel.snp.makeConstraints { (maker) -> Void in
            maker.height.equalTo(37)
            maker.centerX.equalTo(leftLayoutView.snp.centerX).offset(5)
            maker.centerY.equalTo(leftLayoutView.snp.centerY)
        }
        titleLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(content.snp.top).offset(20)
            maker.left.equalTo(rightLayoutView.snp.left).offset(20)
            maker.height.equalTo(17)
        }
        validityTermLabel.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(titleLabel.snp.bottom).offset(12)
            maker.left.equalTo(rightLayoutView.snp.left).offset(20)
            maker.height.equalTo(13)
        }
        statusIcon.snp.makeConstraints { (maker) -> Void in
            maker.top.equalTo(rightLayoutView.snp.top).offset(6)
            maker.right.equalTo(rightLayoutView.snp.right).offset(-6)
            maker.width.equalTo(50)
            maker.height.equalTo(50)
        }
        selectedView.snp.makeConstraints { (maker) -> Void in
            maker.centerY.equalTo(rightLayoutView.snp.centerY)
            maker.right.equalTo(rightLayoutView.snp.right).offset(-10)
        }
    }
    ///  不可用样式(当前选课条件不满足使用条件)
    private func setStyleDisable() {
        titleLabel.textColor = MalaColor_999999_0
        content.image = UIImage(named: "coupon_unvalid")
        statusIcon.isHidden = true
    }
    ///  过期样式(不可用)
    private func setStyleExpired() {
        titleLabel.textColor = MalaColor_999999_0
        content.image = UIImage(named: "coupon_unvalid")
        statusIcon.isHidden = false
        statusIcon.image = UIImage(named: "coupon_expired")
    }
    ///  已使用样式(不可用)
    private func setStyleUsed() {
        titleLabel.textColor = MalaColor_999999_0
        content.image = UIImage(named: "coupon_unvalid")
        statusIcon.isHidden = false
        statusIcon.image = UIImage(named: "coupon_used")
    }
    ///  未使用样式(可用)
    private func setStyleUnused() {
        titleLabel.textColor = MalaColor_6DB2E5_0
        content.image = UIImage(named: "coupon_valid")
        statusIcon.isHidden = true
    }
}
